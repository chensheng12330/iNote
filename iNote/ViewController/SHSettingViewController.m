//
//  SHSettingViewController.m
//  iNote
//
//  Created by 1322 on 12-11-26.
//
//

#import "SHSettingViewController.h"

@interface SHSettingViewController (Private)
- (void)postNewStatus;
- (void)initTableViewData;
@end


// 有道云词典
#define kOAuthConsumerKey				@"448412811a0a2fcac811ca08b8b2c258"		//REPLACE ME
#define kOAuthConsumerSecret			@"10c6d13eec190b97248591e51b2abe0d"		//REPLACE ME
// end

@implementation SHSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [_engine     release];
    [ydNoteClient release];
    [_myTableView release];
    [_myCell1 release];
    [_myCell2 release];
    [_myCell3 release];
    [_myCell4 release];
    [_myCell5 release];
    [_myCell6 release];
    [_myCell7 release];
    [_myCell8 release];
    [_myCell9 release];
    [_myCell10 release];
    [super dealloc];
    return;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    // Add view element
    [self initTableViewData];
    
    //授权管理初使化
    NSData *getData = [[NSUserDefaults standardUserDefaults] objectForKey: @"YDauthData"];
    _engine = [[OAuthEngine unarchivedOAuthEngineWithData:getData] retain];
    
    if (!_engine){
		_engine = [[OAuthEngine alloc] initOAuthWithDelegate: self];
		_engine.consumerKey    = kOAuthConsumerKey;
		_engine.consumerSecret = kOAuthConsumerSecret;
	}
    
    
    [self loadTimeline];
    return;
}

- (void)loadTimeline {
	OAuthController *controller = [OAuthController controllerToEnterCredentialsWithEngine: _engine delegate: self];
    [controller setStTitle:@"登陆授权"];
    
    
    //presentModalViewController
	if (controller) [self presentModalViewController:controller animated:YES];
        //[self.navigationController pushViewController: controller animated: YES];
}

- (void)loadData {
    //成功返回授权相关信息
	if (ydNoteClient) {
		return;
	}
    
    //将获取的授权信息存储
    NSData *saveEngine = [OAuthEngine archivedDataWithOAuthEngine:_engine];
    
    NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject: saveEngine forKey: @"YDauthData"];
	[defaults synchronize];
    
    //初使化管理
	ydNoteClient = [[SHNoteClient alloc] initWithTarget:self
                                                 engine:_engine
                                                 action:@selector(timelineDidReceive:obj:)];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:@"用户设置"];
    
    return;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //NSLog(@"viewDidAppear 被调用");
}

- (void)viewDidUnload
{
    [self setMyTableView:nil];
    [self setMyCell1:nil];
    [self setMyCell2:nil];
    [self setMyCell3:nil];
    [self setMyCell4:nil];
    [self setMyCell5:nil];
    [self setMyCell6:nil];
    [self setMyCell7:nil];
    [self setMyCell8:nil];
    [self setMyCell9:nil];
    [self setMyCell10:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - TableView Deleget

-(void)initTableViewData
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"";
}



#pragma mark WeiBoOpreate
- (void)timelineDidReceive:(SHNoteClient*)sender obj:(NSObject*)obj
{
	NSLog(@"begin timelineDidReceive");
    if (sender.hasError) {
		NSLog(@"timelineDidReceive error!!!, errorMessage:%@, errordetail:%@"
			  , sender.errorMessage, sender.errorDetail);
		[sender alert];
        if (sender.statusCode == 401) {
            [self openAuthenticateView];
        }
    }
    return;
}

#pragma mark OAuthEngineDelegate
- (void) storeCachedOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

- (void)removeCachedOAuthDataForUsername:(NSString *) username{
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults removeObjectForKey: @"authData"];
	[defaults synchronize];
}
//=============================================================================================================================
#pragma mark OAuthSinaWeiboControllerDelegate
- (void) OAuthController: (OAuthController *) controller authenticatedWithUsername: (NSString *) username {
	NSLog(@"Authenicated for %@", username);
	//[self loadTimeline];
    //[OAuthEngine setCurrentOAuthEngine:_engine];
    
    //NSArray * ar = controller.navigationController.viewControllers;
    
    [controller.navigationController popViewControllerAnimated:YES];
    
    [OAuthEngine setCurrentOAuthEngine:_engine];
    [self loadData];
    //NSLog(self);
    //[controller.navigationController popToViewController:self animated:YES];
}

- (void) OAuthControllerFailed: (OAuthController *) controller {
	NSLog(@"Authentication Failed!");
	//UIViewController *controller = [OAuthController controllerToEnterCredentialsWithEngine: _engine delegate: self];
	
	if (controller)
    {
        NSArray *ar = self.navigationController.viewControllers;
        int ncount = self.navigationController.viewControllers.count;
        UIViewController *viewControl = [ar objectAtIndex:ncount-3];
        [self.navigationController popToViewController:viewControl animated:YES];
    }
	
}

- (void) OAuthControllerCanceled: (OAuthController *) controller {
	NSLog(@"Authentication Canceled.");

    [controller dismissModalViewControllerAnimated:YES];
    
    return;
    if (controller)
    {
        NSArray *ar = self.navigationController.viewControllers;
        int ncount = self.navigationController.viewControllers.count;
        UIViewController *viewControl = [ar objectAtIndex:ncount-3];
        
        [self.navigationController popToViewController:viewControl animated:YES];
    }
    return;
}

@end
