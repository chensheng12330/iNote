//
//  SHAddNotebookViewController.m
//  iNote
//
//  Created by Sherwin.Chen on 13-1-9.
//
//

#import "SHAddNotebookViewController.h"

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
    
    [self.editButtonItem setTitle:@"保存"];
    //[self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    //save notebook name
    //process
    
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
