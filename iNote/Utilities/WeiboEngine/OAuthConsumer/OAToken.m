//
//  OAToken.m
//  OAuthConsumer
//
//  Created by Jon Crosby on 10/19/07.
//  Copyright 2007 Kaboomerang LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


#import "OAToken.h"
#import "MacroDefine.h"


@implementation OAToken

@synthesize key, secret;
@synthesize pin;

#pragma mark init

- (id)init 
{
	if (self = [super init])
	{
		self.key = @"";
		self.secret = @"";
	}
    return self;
}

- (id)initWithKey:(NSString *)aKey secret:(NSString *)aSecret 
{
	if (self = [super init])
	{
		self.key = aKey;
		self.secret = aSecret;
	}
	return self;
}

-(void) encodeWithCoder:(NSCoder *) coder{
    [coder encodeObject:self.key    forKey:@"key"];
    [coder encodeObject:self.secret forKey:@"secret"];
    [coder encodeObject:self.pin    forKey:@"pin"];
    return;
}

-(id) initWithCoder:(NSCoder *)  decoder{
    if(self =[super init]){
        self.key    = [decoder decodeObjectForKey:@"key"];
        self.secret = [decoder decodeObjectForKey:@"secret"];
        self.pin    = [decoder decodeObjectForKey:@"pin"];
    }
    return self;
}
-(NSString *) description{
    NSString *descripton=[NSString stringWithFormat:@"key:%@  secret:%@  pin:%@",self.key,self.secret,self->pin];
    return (descripton);
}

- (id)initWithHTTPResponseBody:(NSString *)body 
{
	if (self = [super init])
	{
		NSArray *pairs = [body componentsSeparatedByString:@"&"];
		
		for (NSString *pair in pairs) {
			NSArray *elements = [pair componentsSeparatedByString:@"="];
			if ([[elements objectAtIndex:0] isEqualToString:@"oauth_token"]) {
				self.key = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			} else if ([[elements objectAtIndex:0] isEqualToString:@"oauth_token_secret"]) {
				self.secret = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			} else if ([[elements objectAtIndex:0] isEqualToString:@"oauth_verifier"]) {
				self.pin = [elements objectAtIndex:1];
			}
		}
	}    
    return self;
}

- (id)initWithUserDefaultsUsingServiceProviderName:(NSString *)provider prefix:(NSString *)prefix
{
	if (self = [super init])
	{
		NSString *theKey = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"OAUTH_%@_%@_KEY", prefix, provider]];
		NSString *theSecret = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"OAUTH_%@_%@_SECRET", prefix, provider]];
		if (theKey == NULL || theSecret == NULL)
			return(nil);
		self.key = theKey;
		self.secret = theSecret;
	}
	return self;
}

- (void)dealloc
{
	[key release];
	[secret release];
	[super dealloc];
}

#pragma mark -

- (int)storeInUserDefaultsWithServiceProviderName:(NSString *)provider prefix:(NSString *)prefix
{
	[[NSUserDefaults standardUserDefaults] setObject:self.key forKey:[NSString stringWithFormat:@"OAUTH_%@_%@_KEY", prefix, provider]];
	[[NSUserDefaults standardUserDefaults] setObject:self.secret forKey:[NSString stringWithFormat:@"OAUTH_%@_%@_SECRET", prefix, provider]];
	[[NSUserDefaults standardUserDefaults] synchronize];
	return(0);
}

#pragma mark -Archiver
- (NSData*) OAToken2Data
{
    //pin##key##secret 
    NSString *combString = [NSString stringWithFormat:@"%@%@%@%@%@",self.pin,OA2DATA_STRING,self.key,OA2DATA_STRING,self.secret];
    return [combString dataUsingEncoding:NSUTF8StringEncoding];
}

- (void) Data2OATokenAttribute:(NSData*) _data
{
    if (_data == nil || _data.length<=0) {
        return;
    }
    
    id combString = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    if ([combString isKindOfClass:[NSString class]]) {
        NSArray *strings = [combString componentsSeparatedByString:OA2DATA_STRING];
        if (strings.count>2) {
            self.pin    = [strings objectAtIndex:0];
            self.key    = [strings objectAtIndex:1];
            self.secret = [strings objectAtIndex:2];
        }
    }
    return;
}
@end
