//
//  SHNoteListViewController.h
//  iNote
//
//  Created by Sherwin.Chen on 12-12-26.
//
//

#import <UIKit/UIKit.h>
#import "SHNoteBookModelManager.h"

@interface SHNoteListViewController : UITableViewController
{
    NSMutableArray *myTableDataSource;
    SHNoteBookModelManager *notebookMM;
}
@end
 