//
//  SHNoteListViewController.h
//  iNote
//
//  Created by Sherwin.Chen on 12-12-26.
//
//

#import <UIKit/UIKit.h>
#import "SHNoteModelManager.h"
#import "SHBottomMenuView.h"

@interface SHNoteListViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,
SHBottomMenuDelegate,UISearchBarDelegate>
{
    UITableView *tableView;
    NSMutableArray *myTableDataSource;
    SHNoteModelManager *noteMM;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic,readonly, retain) SHBottomMenuView *youkuMenuView;
@end
 