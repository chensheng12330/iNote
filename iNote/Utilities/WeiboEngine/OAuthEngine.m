//
//  OAuthEngine.m
//  WeiboPad
//
//  Created by junmin liu on 10-10-5.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "OAuthEngine.h"
#import "OAConsumer.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"


@interface OAuthEngine (private)

- (void) requestURL:(NSURL *) url token:(OAToken *)token onSuccess:(SEL)success onFail:(SEL)fail;
- (void) outhTicketFailed: (OAServiceTicket *) ticket data: (NSData *) data;

- (void) setRequestToken: (OAServiceTicket *) ticket withData: (NSData *) data;
- (void) setAccessToken:  (OAServiceTicket *) ticket withData: (NSData *) data;

- (NSString *) extractUsernameFromHTTPBody:(NSString *)body;

// MGTwitterEngine impliments this
// include it here just so that we
// can use this private method
- (NSString *)_queryStringWithBase:(NSString *)base parameters:(NSDictionary *)params prefixed:(BOOL)prefixed;

@end

static OAuthEngine * _currentOAuthEngine;

@implementation OAuthEngine

@synthesize pin = _pin, requestTokenURL = _requestTokenURL, accessTokenURL = _accessTokenURL, authorizeURL = _authorizeURL;
@synthesize consumerSecret = _consumerSecret, consumerKey = _consumerKey;
@synthesize username = _username;
@synthesize consumer = _consumer;
@synthesize requestToken = _requestToken;
@synthesize accessToken = _accessToken;

- (void) dealloc {
	self.pin = nil;
	self.authorizeURL = nil;
	self.requestTokenURL = nil;
	self.accessTokenURL = nil;
	
	[_username release];
	[_accessToken release];
	[_requestToken release];
	[_consumer release];
	[super dealloc];
}

+ (OAuthEngine *) OAuthEngineWithDelegate: (NSObject *) delegate {
    return [[[OAuthEngine alloc] initOAuthWithDelegate: delegate] autorelease];
}


+ (OAuthEngine *) currentOAuthEngine {
	return _currentOAuthEngine;
}


+ (void)setCurrentOAuthEngine:(OAuthEngine *)_engine{
	if (_currentOAuthEngine != _engine) {
		[_currentOAuthEngine release];
		_currentOAuthEngine = [_engine retain];
	}
}


#define BASE_URL @"http://note.youdao.com"

- (OAuthEngine *) initOAuthWithDelegate: (NSObject *) delegate {
    if (self = (id) [super init]) {
		_delegate = (id)delegate;
		self.requestTokenURL    = [NSURL URLWithString:[NSString stringWithFormat:@"%@/oauth/request_token",BASE_URL]];
        //[NSURL URLWithString: @"http://api.t.sina.com.cn/oauth/request_token"];
		self.accessTokenURL     = [NSURL URLWithString:[NSString stringWithFormat:@"%@/oauth/access_token",BASE_URL]];
        //[NSURL URLWithString: @"http://api.t.sina.com.cn/oauth/access_token"];
		self.authorizeURL       = [NSURL URLWithString:[NSString stringWithFormat:@"%@/oauth/authorize",BASE_URL]];
        //[NSURL URLWithString: @"http://api.t.sina.com.cn/oauth/authorize"];
	}
    return self;
}

//=============================================================================================================================
#pragma mark OAuth Code
- (BOOL) OAuthSetup {
	return _consumer != nil;
}

- (OAConsumer *) consumer {
	if (_consumer) 
        return _consumer;
	
	NSAssert(self.consumerKey.length > 0 && self.consumerSecret.length > 0, @"You must first set your Consumer Key and Consumer Secret properties. Visit http://open.t.sina.com.cn/ to obtain these.");
	_consumer = [[OAConsumer alloc] initWithKey: self.consumerKey secret: self.consumerSecret];
	return _consumer;
}

- (OAToken *) requestToken {
	if (_requestToken) {
		return _requestToken;
	}
	return nil;
}

- (OAToken *) accessToken {
	if (_accessToken) {
		return _accessToken;
	}
	return nil;
}

- (void)signOut {
	[self clearAccessToken];
}

- (BOOL) isAuthorized {	
	if (_accessToken.key && _accessToken.secret) return YES;
	
	//first, check for cached creds
	NSString					*accessTokenString = [_delegate respondsToSelector: @selector(cachedOAuthDataForUsername:)] ? [(id) _delegate cachedOAuthDataForUsername: self.username] : @"";
	
	if (accessTokenString.length) {				
		[_accessToken release];
		_accessToken = [[OAToken alloc] initWithHTTPResponseBody: accessTokenString];
		self.username = [self extractUsernameFromHTTPBody: accessTokenString];
		if (_accessToken.key && _accessToken.secret) 
			return YES;
	}
	
	[_accessToken release];										// no access token found.  create a new empty one
	_accessToken = [[OAToken alloc] initWithKey: nil secret: nil];
	return NO;
}


//This generates a URL request that can be passed to a UIWebView. It will open a page in which the user must enter their Twitter creds to validate
- (NSURLRequest *) authorizeURLRequest {
	if (!_requestToken.key && _requestToken.secret) return nil;	// we need a valid request token to generate the URL
	
	OAMutableURLRequest			*request = [[[OAMutableURLRequest alloc] initWithURL: self.authorizeURL consumer: nil token: _requestToken realm: nil signatureProvider: nil] autorelease];	
	
	[request setParameters: [NSArray arrayWithObject: [[[OARequestParameter alloc] initWithName: @"oauth_token" value: _requestToken.key] autorelease]]];	
	return request;
}


//A request token is used to eventually generate an access token
- (void) requestRequestToken {
	[self requestURL: self.requestTokenURL token: nil 
		   onSuccess: @selector(setRequestToken:withData:) 
			  onFail: @selector(outhTicketFailed:data:)];
}

//this is what we eventually want
- (void) requestAccessToken {
	[self requestURL: self.accessTokenURL token: _requestToken onSuccess: @selector(setAccessToken:withData:) onFail: @selector(outhTicketFailed:data:)];
}


- (void) clearAccessToken {
	if ([_delegate respondsToSelector: @selector(storeCachedOAuthData:forUsername:)]) 
		[(id) _delegate storeCachedOAuthData: @"" forUsername: self.username];
	[_accessToken release];
	_accessToken = nil;
	[_consumer release];
	_consumer = nil;
	self.pin = nil;
	[_requestToken release];
	_requestToken = nil;
}

- (void) setPin: (NSString *) pin {
	[_pin autorelease];
	_pin = [pin retain];
	
	_accessToken.pin = pin;
	_requestToken.pin = pin;
}

//=============================================================================================================================
#pragma mark Private OAuth methods
- (void) requestURL: (NSURL *) url token: (OAToken *) token onSuccess: (SEL) success onFail: (SEL) fail {
    OAMutableURLRequest				*request = [[[OAMutableURLRequest alloc] initWithURL: url consumer: self.consumer token:token realm:nil signatureProvider: nil] autorelease];
	if (!request) 
		return;
	
	if (self.pin.length) 
		token.pin = self.pin;
    [request setHTTPMethod: @"POST"];
	
    OADataFetcher				*fetcher = [[[OADataFetcher alloc] init] autorelease];	
    [fetcher fetchDataWithRequest: request delegate: self didFinishSelector: success didFailSelector: fail];
}


//
// if the fetch fails this is what will happen
// you'll want to add your own error handling here.
//
- (void) outhTicketFailed: (OAServiceTicket *) ticket data: (NSData *) data {
	if ([_delegate respondsToSelector: @selector(oAuthConnectionFailedWithData:)]) 
		[(id) _delegate oAuthConnectionFailedWithData: data];
}


//
// request token callback
// when twitter sends us a request token this callback will fire
// we can store the request token to be used later for generating
// the authentication URL
//
- (void) setRequestToken: (OAServiceTicket *) ticket withData: (NSData *) data {
	if (!ticket.didSucceed || !data) 
		return;
	
	NSString *dataString = [[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] autorelease];
	if (!dataString) 
		return;
	
	[_requestToken release];
	_requestToken = [[OAToken alloc] initWithHTTPResponseBody:dataString];
	
	if (self.pin.length) 
		_requestToken.pin = self.pin;
}


//
// access token callback
// when twitter sends us an access token this callback will fire
// we store it in our ivar as well as writing it to the keychain
// 
- (void) setAccessToken: (OAServiceTicket *) ticket withData: (NSData *) data {
	if (!ticket.didSucceed || !data) 
		return;
	
	NSString *dataString = [[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] autorelease];
	if (!dataString) 
		return;
	
	if (self.pin.length && [dataString rangeOfString: @"oauth_verifier"].location == NSNotFound) 
		dataString = [dataString stringByAppendingFormat: @"&oauth_verifier=%@", self.pin];
	
	NSString				*uid = [self extractUsernameFromHTTPBody:dataString];
	
	if (uid.length > 0) {
		self.username = uid;
		if ([_delegate respondsToSelector: @selector(storeCachedOAuthData:forUsername:)]) 
			[(id) _delegate storeCachedOAuthData: dataString forUsername: uid];
	}
	
	[_accessToken release];
	_accessToken = [[OAToken alloc] initWithHTTPResponseBody:dataString];
}


- (NSString *) extractUsernameFromHTTPBody: (NSString *) body {
	if (!body) return nil;
	
	NSArray					*tuples = [body componentsSeparatedByString: @"&"];
	if (tuples.count < 1) return nil;
	
	for (NSString *tuple in tuples) {
		NSArray *keyValueArray = [tuple componentsSeparatedByString: @"="];
		
		if (keyValueArray.count == 2) {
			NSString				*key = [keyValueArray objectAtIndex: 0];
			NSString				*value = [keyValueArray objectAtIndex: 1];
			
			if ([key isEqualToString:@"screen_name"]) return value;
			if ([key isEqualToString:@"user_id"]) return value;
		}
	}
	
	return nil;
}

#pragma mark -  To Data
-(void) encodeWithCoder:(NSCoder *) coder{
    [coder encodeObject:_consumerSecret   forKey:CONSUMER_SECRET];
    [coder encodeObject:_consumerKey      forKey:CONSUMER_KEY];
    [coder encodeObject:_username         forKey:USER_NAME];
    [coder encodeObject:_pin              forKey:PIN];
    [coder encodeObject:_consumer         forKey:CONSUMER];
    [coder encodeObject:_requestToken     forKey:REQ_TOKEN];
    [coder encodeObject:_accessToken      forKey:ACC_TOKEN];
    return;
}

-(id) initWithCoder:(NSCoder *)  decoder{
    if(self =[super init]){
        self.consumerSecret = [decoder decodeObjectForKey:CONSUMER_SECRET];
        self.consumerKey    = [decoder decodeObjectForKey:CONSUMER_KEY];
        self.username       = [decoder decodeObjectForKey:USER_NAME];
        self.pin            = [decoder decodeObjectForKey:PIN];
        _consumer       = [[decoder decodeObjectForKey:CONSUMER] retain];
        _requestToken   = [[decoder decodeObjectForKey:REQ_TOKEN] retain];
        _accessToken    = [[decoder decodeObjectForKey:ACC_TOKEN] retain];
    }
    return self;
}

+(NSData*)archivedDataWithOAuthEngine:(OAuthEngine *)_oauthEngine
{
    if (nil ==_oauthEngine  || ![_oauthEngine isKindOfClass:[OAuthEngine class]] ) {
        return nil;
    }
    
    NSData *freezeDrid;
    freezeDrid=[NSKeyedArchiver archivedDataWithRootObject:_oauthEngine];
    return freezeDrid;
}

+(OAuthEngine*) unarchivedOAuthEngineWithData:(NSData *)_data
{
    if (nil == _data || [_data length]<=0) {
        return nil;
    }
    
    id tempOAeg = nil;
    tempOAeg = [NSKeyedUnarchiver unarchiveObjectWithData:_data];
    if (nil  == tempOAeg || ![tempOAeg isKindOfClass:[OAuthEngine class]]) {
        return nil;
    }
    return (OAuthEngine*)tempOAeg;
}

-(NSString *) description{
    NSString *descripton=[NSString stringWithFormat:@"consumerSecret:%@  consumerKey:%@  username:%@  pin:%@  consumer:%@ requestToke%@ accessToken%@",_consumerSecret,_consumerKey,_username, _pin,[_consumer description],[_requestToken description], [_accessToken description]];
    return (descripton);
}

-(NSData*) OAuthEngine2Data
{
    NSMutableDictionary *toDataOfMDic = [[[NSMutableDictionary alloc] init] autorelease];
    [toDataOfMDic setValue:_consumerSecret  forKey:CONSUMER_SECRET];
    [toDataOfMDic setValue:_consumerKey     forKey:CONSUMER_KEY];
    [toDataOfMDic setValue:_username        forKey:USER_NAME];
    [toDataOfMDic setValue:_pin             forKey:PIN];
    [toDataOfMDic setValue:[_consumer OAConsumer2Data]  forKey:CONSUMER];
    [toDataOfMDic setValue:[_requestToken OAToken2Data] forKey:REQ_TOKEN];
    [toDataOfMDic setValue:[_accessToken  OAToken2Data] forKey:ACC_TOKEN];
    
    NSString *tempFile =  [NSTemporaryDirectory() stringByAppendingString:@"temp.data"];
    [toDataOfMDic writeToFile:tempFile atomically:YES];
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:tempFile];
    return [data autorelease];
}

-(void) Data2OAuthEngineAttribute:(NSData*) _data
{
    
}
@end
