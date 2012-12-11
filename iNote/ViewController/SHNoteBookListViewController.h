//
//  SHNoteBookListViewController.h
//  iNote
//
//  Created by sherwin.chen on 12-12-11.
//
//

#import <UIKit/UIKit.h>
#import "SHDBManage.h"

@interface SHNoteBookListViewController : UITableViewController
{
    NSMutableArray *myTableDataSource;
    SHDBManage *dbManage;
}
@end
