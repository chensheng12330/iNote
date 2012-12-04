#import <Foundation/Foundation.h>
#import "OAuthEngine.h"
#import "OAToken.h"
#import "OAConsumer.h"
#import "OAMutableURLRequest.h"

#define API_FORMAT @"json"
#define API_DOMAIN	@"note.youdao.com" //@"api.t.sina.com.cn"



typedef enum {
    Reques_Syn, //同步
    Reques_Asyn //异步
}Reques_Mode;

extern NSString *TWITTERFON_FORM_BOUNDARY;

@interface URLConnection : NSObject
{
	id                  delegate;
    NSString*           requestURL;
	NSURLConnection*    connection;
	NSMutableData*      buf;
    int                 statusCode;
    BOOL                needAuth;
	OAuthEngine*		_engine;
}

@property (nonatomic, readonly) NSMutableData* buf;
@property (nonatomic, assign) int statusCode;
@property (nonatomic, copy) NSString* requestURL;

- (id)initWithDelegate:(id)delegate engine:(OAuthEngine *)__engine;
- (NSData*)get:(NSString*)URL   requesMode:(Reques_Mode)_requesMode;
- (NSData*)post:(NSString*)aURL body:(NSString*)body requesMode:(Reques_Mode)_requesMode;
- (NSData*)post:(NSString*)aURL data:(NSData*)data   requesMode:(Reques_Mode)_requesMode;
- (void)cancel;

- (void)URLConnectionDidFailWithError:(NSError*)error;
- (void)URLConnectionDidFinishLoading:(NSString*)content;

@end

/*
 NSURL *url=[[NSURL alloc]initWithString:urlString];
 NSMutableURLRequest  *request=[[NSMutableURLRequest alloc]init];
 
 
 NSError *err=nil;
 
 NSData *data=[NSURLConnection sendSynchronousRequest:request
 
 returningResponse:nil
 
 error:&err];
 
 if(data==nil)
 
 {
 
 //if([err code])
 
 
 NSLog(@"Code:%d,domain:%@,localizedDesc:%@",[err code],
 
 [err domain],[err localizedDescription]);
 
 }
*/