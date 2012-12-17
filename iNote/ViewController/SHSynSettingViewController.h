//
//  SHSynSettingViewController.h
//  iNote
//
//  Created by sherwin.chen on 12-12-10.
//
//

#import <UIKit/UIKit.h>

@interface SHSynSettingViewController : UITableViewController
{
    NSArray *arCells;
}

@property (nonatomic,retain) IBOutlet UITableViewCell *myCell1;
@property (nonatomic,retain) IBOutlet UITableViewCell *myCell2;
@property (nonatomic,retain) IBOutlet UITableViewCell *myCell3;
@property (nonatomic,retain) IBOutlet UITableViewCell *myCell4;
@property (nonatomic,retain) IBOutlet UITableViewCell *myCell5;

@end
