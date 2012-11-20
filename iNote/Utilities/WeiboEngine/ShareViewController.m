//
//  ShareViewController.m
//  WeiBo
//
//  Created by clochase on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController (Private)
- (void)postNewStatus;
@end


// 有道云词典
#define kOAuthConsumerKey				@"448412811a0a2fcac811ca08b8b2c258"		//REPLACE ME
#define kOAuthConsumerSecret			@"10c6d13eec190b97248591e51b2abe0d"		//REPLACE ME
//end

@implementation ShareViewController

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
    [weiboClient release];
    [super dealloc];
    return;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    //NSKeyedArchiver
    // Do any additional setup after loading the view from its nib.
    
    //授权管理初使化
    if (!_engine){
		_engine = [[OAuthEngine alloc] initOAuthWithDelegate: self];
		_engine.consumerKey    = kOAuthConsumerKey;
		_engine.consumerSecret = kOAuthConsumerSecret;
        
        OAConsumer *oc = [[OAConsumer alloc] initWithKey:@"1234" secret:@"321"];
        _engine->_consumer = oc;
        
        OAToken *ot = [[OAToken alloc] initWithKey:@"123" secret:@"321"];
        _engine->_requestToken = ot;
        _engine->_accessToken = [ot retain];
        
        NSData * data = [OAuthEngine archivedDataWithOAuthEngine:_engine];
        
        [_engine release];
        _engine = [OAuthEngine unarchivedOAuthEngineWithData:data];
        // usename
        // pin_key
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
	if (weiboClient) { 
		return;
	}
    
    NSString *str =@"sa";
    //[str dat]
    //储入engine数据
    NSData* saveDate = [_engine zone];
    //
    
	weiboClient = [[WeiboClient alloc] initWithTarget:self 
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
    NSLog(@"viewDidAppear 被调用");
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
- (void)timelineDidReceive:(WeiboClient*)sender obj:(NSObject*)obj
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
