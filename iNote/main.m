//
//  main.m
//  iNote
//
//  Created by clochase on 12-9-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SHNotebook.h"

#import "SHAppDelegate.h"

int main(int argc, char *argv[])
{
    int retVal;
    
    //Utility fuction Testing
    SHNotebook *note = [[SHNotebook alloc] init];
    [note setStrNotes_num:@"123345"];
    [note setStrNotes_num:@"asdf234"];
    
    @autoreleasepool {
        @try {
           retVal= UIApplicationMain(argc, argv, nil, NSStringFromClass([SHAppDelegate class]));
        }
        @catch (NSException *exception) {
            NSLog(@"CRASH: %@", exception);
            NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
            NSLog(@"App Over");
        }
    }
    return retVal;
}
