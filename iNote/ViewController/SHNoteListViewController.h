//
//  SHNoteListViewController.h
//  iNote
//
//  Created by Sherwin.Chen on 12-12-26.
//
//

#import <UIKit/UIKit.h>
#import "SHNoteModelManager.h"
#import "HHYoukuMenuView.h"

@interface SHNoteListViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableView;
    NSMutableArray *myTableDataSource;
    SHNoteModelManager *noteMM;
}
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic,readonly, retain) HHYoukuMenuView *youkuMenuView;
@end
 