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
@interface SHSettingViewController : UIViewController
<OAuthControllerDelegate,
     OAuthEngineDelegate,
   UITableViewDataSource,
        UITabBarDelegate>
{
    OAuthEngine				 *_engine;       //授权管理
	SHNoteClient             *ydNoteClient;   //有道api管理
    
    //nib init table cell
    NSMutableDictionary *myTableCellDit;
    NSArray *myAllCellKey;
}

@property (nonatomic,retain) IBOutlet UITableViewCell *myCell1;
@property (nonatomic,retain) IBOutlet UITableViewCell *myCell2;
@property (nonatomic,retain) IBOutlet UITableViewCell *myCell3;
@property (nonatomic,retain) IBOutlet UITableViewCell *myCell4;
@property (nonatomic,retain) IBOutlet UITableViewCell *myCell5;
@property (nonatomic,retain) IBOutlet UITableViewCell *myCell6;
@property (nonatomic,retain) IBOutlet UITableViewCell *myCell7;
@property (nonatomic,retain) IBOutlet UITableViewCell *myCell8;
@property (nonatomic,retain) IBOutlet UITableViewCell *myCell9;
@property (nonatomic,retain) IBOutlet UITableViewCell *myCell10;

@property (nonatomic,retain) IBOutlet UITableView *myTableView;



//登陆管理
- (void)openAuthenticateView;
- (void)timelineDidReceive:(SHNoteClient*)sender obj:(NSObject*)obj;

- (void)loadTimeline;
- (void)loadData;

@end