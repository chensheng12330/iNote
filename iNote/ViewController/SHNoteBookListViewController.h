//
//  SHNoteBookListViewController.h
//  iNote
//
//  Created by sherwin.chen on 12-12-11.
//
//

#import <UIKit/UIKit.h>
#import "SHDBManage.h"
#import "SHNoteBookModelManager.h"

@interface SHNoteBookListViewController : UITableViewController
{
    NSMutableArray *myTableDataSource;
    NSMutableArray *myMostRecentlyUsed;   //最近使用
    NSMutableArray *myOftenUsed;          //经常使用
    
    //fuction obj
    SHNoteBookModelManager *notebookMM;
}

-(void) didLoadBookList:(NSMutableArray*) _array;
@end
