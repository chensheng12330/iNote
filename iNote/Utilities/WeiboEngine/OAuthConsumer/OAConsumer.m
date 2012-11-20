//
//  OAConsumer.m
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

#import "OAConsumer.h"
#import "MacroDefine.h"

@implementation OAConsumer
@synthesize key, secret;

#pragma mark init

- (id)initWithKey:(NSString *)aKey secret:(NSString *)aSecret 
{
	if (self = [super init])
	{
		self.key = aKey;
		self.secret = aSecret;
	}
	return self;
}

- (void)dealloc
{
	[key release];
	[secret release];
	[super dealloc];
}

//对象序列化
-(void) encodeWithCoder:(NSCoder *) coder{
    [coder encodeObject:self.key forKey:@"key"];
    [coder encodeObject:self.secret forKey:@"secret"];
    return;
}

-(id) initWithCoder:(NSCoder *)  decoder{
    if(self =[super init]){
        self.key = [decoder decodeObjectForKey:@"key"];
        self.secret = [decoder decodeObjectForKey:@"secret"];
    }
    return self;
}
-(NSString *) description{
    NSString *descripton=[NSString stringWithFormat:@"key:%@  secret:%@",self.key,self.secret];
    return (descripton);
}


- (NSData*) OAConsumer2Data
{
    NSString *combString = [NSString stringWithFormat:@"%@%@%@",self.key,OA2DATA_STRING,self.secret];
    return [combString dataUsingEncoding:NSUTF8StringEncoding];
}

- (void) Data2OAConsumerAttribute:(NSData*) _data
{
    if (_data == nil || _data.length<=0) {
        return;
    }
    
    id combString = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    if ([combString isKindOfClass:[NSString class]]) {
        NSArray *strings = [combString componentsSeparatedByString:OA2DATA_STRING];
        if (strings.count>1) {
            self.key   = [strings objectAtIndex:0];
            self.secret= [strings objectAtIndex:1];
        }
    }
    return;
}
@end
