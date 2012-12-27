//
//  SHNoteListViewController.h
//  iNote
//
//  Created by Sherwin.Chen on 12-12-26.
//
//

#import <UIKit/UIKit.h>
#import "SHDBManage.h"

@interface SHNoteListViewController : UITableViewController
{
    NSMutableArray *myTableDataSource;
    SHDBManage *dbManage;
}
@end
 