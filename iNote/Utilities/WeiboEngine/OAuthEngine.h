//
//  OAuthEngine.h
//  WeiboPad
//
//  Created by junmin liu on 10-10-5.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OAuthEngineDelegate 
@optional
- (void) storeCachedOAuthData: (NSString *) data forUsername: (NSString *) username;					//implement these methods to store off the creds returned by Twitter
- (NSString *) cachedOAuthDataForUsername: (NSString *) username;										//if you don't do this, the user will have to re-authenticate every time they run
- (void) oAuthConnectionFailedWithData: (NSData *) data; 
@end

@class OAToken;
@class OAConsumer;

//////#####storng to NSData with key 
#define CONSUMER_SECRET @"consumerSecret"
#define CONSUMER_KEY    @"consumerKey"
#define USER_NAME       @"username"
#define PIN             @"pin"
#define CONSUMER        @"consumer"
#define REQ_TOKEN       @"requestToken"
#define ACC_TOKEN       @"accessToken"

@interface OAuthEngine : NSObject<NSCoding>{
    @public
	NSObject <OAuthEngineDelegate> *_delegate;
	NSString	*_consumerSecret;
	NSString	*_consumerKey;
    
	NSURL		*_requestTokenURL;
	NSURL		*_accessTokenURL;
	NSURL		*_authorizeURL;
	
    NSString *_username;
	
	NSString	*_pin;
	
	OAConsumer	*_consumer;
	OAToken		*_requestToken;
	OAToken		*_accessToken; 
}

@property (nonatomic, retain) NSString *username;
@property (nonatomic, readwrite, retain) NSString *consumerSecret, *consumerKey;
@property (nonatomic, readwrite, retain) NSURL *requestTokenURL, *accessTokenURL, *authorizeURL;				//you shouldn't need to touch these. Just in case...
@property (nonatomic, readonly) BOOL OAuthSetup;

+ (OAuthEngine *) currentOAuthEngine;
+ (void)setCurrentOAuthEngine:(OAuthEngine *)_engine;

+ (OAuthEngine *) OAuthEngineWithDelegate: (NSObject *) delegate;
- (OAuthEngine *) initOAuthWithDelegate: (NSObject *) delegate;

+(NSData*) archivedDataWithOAuthEngine:(OAuthEngine*) _oauthEngine;
+(OAuthEngine *)unarchivedOAuthEngineWithData:(NSData*)_data;

- (BOOL) isAuthorized;
- (void) signOut;
- (void) requestAccessToken;
- (void) requestRequestToken;
- (void) clearAccessToken;

-(NSData*) OAuthEngine2Data;
-(void) Data2OAuthEngineAttribute:(NSData*) _data;

@property (nonatomic, readwrite, retain)  NSString	*pin;
@property (nonatomic, readonly) NSURLRequest *authorizeURLRequest;
@property (nonatomic, readonly) OAConsumer *consumer;
@property (nonatomic, readonly) OAToken		*requestToken;
@property (nonatomic, readonly) OAToken		*accessToken; 
@end
