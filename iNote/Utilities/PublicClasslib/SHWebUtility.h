//
//  SHWebUtility.h
//  iNote
//
//  Created by sherwin.chen on 12-12-9.
//  
//

#import <Foundation/Foundation.h>


@interface SHWebUtility : NSObject

//是否有可用网络
+(BOOL) isNetWork;
@end

/*
 +(BOOL) isNetWork
 {
 TeraGoAppDelegate * mydelegate = (TeraGoAppDelegate*)[[UIApplication sharedApplication] delegate];
 NetworkStatus hostStatus = [mydelegate.hostReachable currentReachabilityStatus];
 if ( hostStatus == kNotReachable)
 {
 return FALSE;
 }
 
 return TRUE;
 }
*/