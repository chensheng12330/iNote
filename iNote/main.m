//
//  main.m
//  iNote
//
//  Created by clochase on 12-9-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SHAppDelegate.h"
#import "NSLoggerSent.h"

int main(int argc, char *argv[])
{
    int retVal;
    
    //Utility fuction Testing
    
    @autoreleasepool {
        @try {
            StartLoggerMessages(@"192.168.0.78:56248", YES, YES);
            LogMessage(@"Main", 0, @"App Begain Run");
            //StartLoggerMessages(nil, YES, YES);
            retVal= UIApplicationMain(argc, argv, nil, NSStringFromClass([SHAppDelegate class]));
            
        }
        @catch (NSException *exception) {
            NSLog(@"CRASH: %@", exception);
            NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
            NSLog(@"App Over");
        }
    }
    LogMessage(@"Main", 0, @"App Run Completed");
    return retVal;
}
