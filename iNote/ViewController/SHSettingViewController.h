//
//  SHSettingViewController.h
//  iNote
//
//  Created by 1322 on 12-11-26.
//
//

#import <UIKit/UIKit.h>

#import "OAuthController.h"
#import "SHNoteClient.h"

//页面登陆事件处理
@interface SHSettingViewController : UIViewController<OAuthControllerDelegate,OAuthEngineDelegate>
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