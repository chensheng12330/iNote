//
//  SHWebUtility.m
//  iNote
//
//  Created by sherwin.chen on 12-12-9.
//
//

#import "Reachability.h" //网络监测
#import "SHWebUtility.h"

@implementation SHWebUtility

+(BOOL) isNetWork
{
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus hostStatus = [reachability currentReachabilityStatus];
    
    if ( hostStatus == kNotReachable) return FALSE;
    return TRUE;
}

@end
