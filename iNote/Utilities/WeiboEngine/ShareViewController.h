//
//  ShareViewController.h
//  WeiBo
//
//  Created by sherwin.chen on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OAuthController.h"
#import "SHNoteClient.h"

//页面登陆事件处理
@interface ShareViewController : UIViewController<OAuthControllerDelegate,OAuthEngineDelegate>
{
    OAuthEngine				 *_engine;       //授权管理
	SHNoteClient             *ydNoteClient;   //有道api管理
}

//登陆管理
- (void)openAuthenticateView;
- (void)timelineDidReceive:(SHNoteClient*)sender obj:(NSObject*)obj;

- (void)loadTimeline;
- (void)loadData;

@end
