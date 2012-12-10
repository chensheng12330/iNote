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

@property (retain, nonatomic) IBOutlet UITableViewCell *myCell1;
@property (retain, nonatomic) IBOutlet UITableViewCell *myCell2;
@property (retain, nonatomic) IBOutlet UITableViewCell *myCell3;
@property (retain, nonatomic) IBOutlet UITableViewCell *myCell4;
@property (retain, nonatomic) IBOutlet UITableViewCell *myCell5;

@end
