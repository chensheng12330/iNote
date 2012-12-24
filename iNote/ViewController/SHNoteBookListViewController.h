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
    
    NSMutableArray *myMostRecentlyUsed;   //最近使用
    NSMutableArray *myOftenUsed;          //经常使用
}

-(void) didLoadBookList:(NSMutableArray*) _array;
@end
