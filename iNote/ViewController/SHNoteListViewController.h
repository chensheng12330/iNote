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
typedef enum {
    NL_ALL_NOTEBOOK=0,      //所有笔记本
    NL_SINGLE_NOTEBOOK,     //某个笔记本
    NL_SEARCH_NOTES         //
}NL_Data_Type;

@interface SHNoteListViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,
SHBottomMenuDelegate,UISearchBarDelegate>
{
    UITableView *tableView;
    NSMutableArray *myTableDataSource;
    SHNoteModelManager *noteMM;
}

@property (assign) NL_Data_Type emDataSourceType;
@property (nonatomic, copy)   NSString      *strTableHeadString;
@property (nonatomic, readonly, retain) NSMutableArray *myTableDataSource;
@property (nonatomic, retain) IBOutlet UISearchBar *mySearchBar;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic,readonly, retain) SHBottomMenuView *youkuMenuView;
@end
 