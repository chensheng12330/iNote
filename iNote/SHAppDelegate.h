//
//  SHAppDelegate.h
//  iNote
//
//  Created by clochase on 12-9-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

//git commit
/*
 git push -u origin master
 */

#import <UIKit/UIKit.h>
#import "SHDBManage.h"

@class SHViewController;

@interface SHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) SHViewController *viewController;

@property (readonly) SHDBManage *dbManage;
@end
