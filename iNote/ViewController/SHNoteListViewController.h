//
//  SHNoteListViewController.h
//  iNote
//
//  Created by Sherwin.Chen on 12-12-26.
//
//

#import <UIKit/UIKit.h>
#import "SHNoteModelManager.h"

@interface SHNoteListViewController : UITableViewController
{
    NSMutableArray *myTableDataSource;
    SHNoteModelManager *noteMM;
}
@end
 