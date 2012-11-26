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
@end


// 有道云词典
#define kOAuthConsumerKey				@"448412811a0a2fcac811ca08b8b2c258"		//REPLACE ME
#define kOAuthConsumerSecret			@"10c6d13eec190b97248591e51b2abe0d"		//REPLACE ME
//end

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
    [super dealloc];
    return;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //NSKeyedArchiver
    // Do any additional setup after loading the view from its nib.
    
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
    
	if (controller)
        [self.navigationController pushViewController: controller animated: YES];
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
    return;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //NSLog(@"viewDidAppear 被调用");
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
	//UIViewController *controller = [OAuthController controllerToEnterCredentialsWithEngine: _engine delegate: self]
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
