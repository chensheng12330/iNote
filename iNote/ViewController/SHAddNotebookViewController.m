//
//  SHAddNotebookViewController.m
//  iNote
//
//  Created by Sherwin.Chen on 13-1-9.
//
//

#import "SHAddNotebookViewController.h"
#import "SHNoteBookModelManager.h"

@interface SHAddNotebookViewController ()

@end

@implementation SHAddNotebookViewController

@synthesize tfNotebookName  = _tfNotebookName;
@synthesize delegate        = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc
{
    _delegate           = nil;
    self.tfNotebookName = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SelfMethod
-(IBAction)Back:(id)sender
{
    //give up
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)Save:(id)sender
{
    // check user input notebook name Is repeated？
    SHNoteBookModelManager *notebookMM = [[[SHNoteBookModelManager alloc] init] autorelease];
    BOOL bflag = [_tfNotebookName.text isEqualToString:@""];
    
    if ( bflag || [notebookMM isAtForNotebookName:_tfNotebookName.text] ) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:(bflag?@"笔记本名称不能为空.":@"此笔记本已存在.")
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        return;
    }
    
    //sent notebook name to delegate
    SEL setNotebookName = @selector(viewControl:getNotebookName:);
    
    if ([_delegate respondsToSelector: setNotebookName])
    {
        [_delegate performSelector:setNotebookName withObject:self withObject:_tfNotebookName.text];
    }
    
    //disappear
    [self dismissModalViewControllerAnimated:YES];
}
@end
