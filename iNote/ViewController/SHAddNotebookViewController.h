//
//  SHAddNotebookViewController.h
//  iNote
//
//  Created by Sherwin.Chen on 13-1-9.
//
//

#import <UIKit/UIKit.h>

@class SHAddNotebookViewController;

@protocol SHAddNotebookDelegate<NSObject>
@optional
-(void) viewControl:(SHAddNotebookViewController*)_viewControl
       getNotebookName:(NSString*)_notebookName;
@end

@interface SHAddNotebookViewController : UIViewController
{
}
@property (assign) id<SHAddNotebookDelegate> delegate;
@property (nonatomic,retain)  IBOutlet UITextField *tfNotebookName;
-(IBAction)Back:(id)sender;
-(IBAction)Save:(id)sender;
@end
