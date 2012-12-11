//
//  SHSettingViewController.m
//  iNote
//
//  Created by sherwin.chen on 12-11-26.
//
//

#import "SHSettingViewController.h"

#import "JSON.h"
#import "SHWebUtility.h"
#import "SHSynSettingViewController.h"

@interface SHSettingViewController (Private)
- (void)postNewStatus;
- (void)initTableViewData;

-(void)UserLog:(UIBarButtonItem*)sender;
@end


// 有道云词典
#define kOAuthConsumerKey				@"448412811a0a2fcac811ca08b8b2c258"		//REPLACE ME
#define kOAuthConsumerSecret			@"10c6d13eec190b97248591e51b2abe0d"		//REPLACE ME

#define OAUTH_SAVE_KEY  @"YDauthData"
// end

@implementation SHSettingViewController
@synthesize myCell1 = _myCell1;
@synthesize myCell2 = _myCell2;
@synthesize myCell3 = _myCell3;
@synthesize myCell4 = _myCell4;
@synthesize myCell5 = _myCell5;
@synthesize myCell6 = _myCell6;
@synthesize myCell7 = _myCell7;
@synthesize myCell8 = _myCell8;
@synthesize myCell9 = _myCell9;
@synthesize myCell10= _myCell10;
@synthesize myTableView = _myTableView;

- (id)init
{
    self = [super init];
    if (self) {
        
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
    
    [myAllCellKey   release];
    [myTableCellDit release];
    
    [super dealloc];
    return;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dbManage = [SHDBManage sharedDBManage];
    
    // Do any additional setup after loading the view from its nib.
    
    // Add view element
    [self initTableViewData];
    
    //授权管理初使化
    NSData *getData = [[NSUserDefaults standardUserDefaults] objectForKey: OAUTH_SAVE_KEY];
    _engine = [[OAuthEngine unarchivedOAuthEngineWithData:getData] retain];
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"登陆" style:UIBarButtonItemStylePlain target:self action:@selector(UserLog:)];
    self.navigationItem.rightBarButtonItem = btn;
    [btn release];
    
    //右标题设置
    if (_engine) {
        [self.navigationItem.rightBarButtonItem setTitle:@"注销"];
        [self.navigationItem.rightBarButtonItem setTag:1];
    }
    else
    {
        [self.navigationItem.rightBarButtonItem setTitle:@"登陆"];
        [self.navigationItem.rightBarButtonItem setTag:2];
    }
    
    if (!_engine){
		_engine = [[OAuthEngine alloc] initOAuthWithDelegate: self];
		_engine.consumerKey    = kOAuthConsumerKey;
		_engine.consumerSecret = kOAuthConsumerSecret;
	}
    
    [self loadTimeline];
    return;
}

- (void)loadTimeline {
    
    OAuthController *controller = nil;
    
    if ([SHWebUtility isNetWork]) {  //有网络才请求登陆
        controller = [OAuthController controllerToEnterCredentialsWithEngine: _engine delegate: self];
    }
    [controller setStTitle:@"登陆授权"];
    
    //presentModalViewController
	if (controller)
    {
        isReqForWeb = YES;
        [self presentModalViewController:controller animated:YES];
    }
    else
    {
        isReqForWeb = NO;
        [self loadData];
    }
    return ;
}

- (void)loadData {
    //成功返回授权相关信息
	if (ydNoteClient==nil) {
        //将获取的授权信息存储
        NSData *saveEngine = [OAuthEngine archivedDataWithOAuthEngine:_engine];
        
        NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject: saveEngine forKey: OAUTH_SAVE_KEY];
        [defaults synchronize];
        
        //初使化管理
        ydNoteClient = [[SHNoteClient alloc] initWithTarget:self
                                                     engine:_engine
                                                     action:@selector(timelineDidReceive:obj:)];
	}
    
    //数据显示及处理
    if ([SHWebUtility isNetWork]) {
        //从网络下载数据
        NSData * data = [ydNoteClient getUseInfoWithRequesMode:Reques_Syn];
        NSString *strRep = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary* dic = [strRep JSONValue];
        noteUserInfo = [[SHNoteUser alloc] initWithJSON:dic];
        
        //更新数据库
        [dbManage setNoteUserDataToDB:noteUserInfo];
        [strRep release];
    }
    else
    {
        //从数据库读取数据
        noteUserInfo = [dbManage getNoteUserInfo];
    }

    if (isReqForWeb) [self.myTableView reloadData];
    return;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
    myTableCellDit = [[NSMutableDictionary alloc] init];
    myAllCellKey   = [[NSArray alloc] initWithObjects:@"",@"账户信息",@"更多功能设置",@"关于", nil];
    
    NSArray *ar1 = [NSArray arrayWithObjects:_myCell1, nil];
    [myTableCellDit setObject:ar1 forKey:[myAllCellKey objectAtIndex:0]];
    
    NSArray *ar2 = [NSArray arrayWithObjects:_myCell3,_myCell5,_myCell6,_myCell7,_myCell8,_myCell9, nil];
    [myTableCellDit setObject:ar2 forKey:[myAllCellKey objectAtIndex:1]];
    
    NSArray *ar3 = [NSArray arrayWithObjects:_myCell2,_myCell4,nil];
    [myTableCellDit setObject:ar3 forKey:[myAllCellKey objectAtIndex:2]];
    
    NSArray *ar4 = [NSArray arrayWithObjects:_myCell10, nil];
    [myTableCellDit setObject:ar4 forKey:[myAllCellKey objectAtIndex:3]];
    return;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    @try {
        NSString *strKey = [myAllCellKey   objectAtIndex:section];
        NSArray  *arCells= [myTableCellDit objectForKey:strKey];
        return [arCells count];
    }
    @catch (NSException *exception) {
        //process
        NSLog(@"CRASH: %@", exception);
    }
    @finally {
        
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row     = indexPath.row;
    int section = indexPath.section;
    
    @try {
        NSString *strKey = [myAllCellKey   objectAtIndex:section];
        NSArray  *arCells= [myTableCellDit objectForKey:strKey];
        
        UITableViewCell *cell = [arCells objectAtIndex:row];
        NSAssert(cell!=nil, @"Sherwin: SettingMVC:cellForFowAtIndexPath,cell is null");
        
        //cell add infomation
        if (section==1) { //账户信息
            if (row ==1 ) {
                UIProgressView *progView = (UIProgressView *)[cell viewWithTag:1];
                [progView setProgress:[[noteUserInfo objectWithIndex:1] doubleValue]];
            }
            else
            {
                UILabel *tag4view = (UILabel *)[cell viewWithTag:1];
                [tag4view setText:[noteUserInfo objectWithIndex:row]];
            }
            
        }
        return cell;
    }
    @catch (NSException *exception) {
        //process
        NSLog(@"CRASH: %@", exception);
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [myTableCellDit count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [myAllCellKey objectAtIndex:section];
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==2 && indexPath.row ==0) {
        SHSynSettingViewController *synSettingViewController = [[SHSynSettingViewController alloc] init];
        [self.navigationController pushViewController:synSettingViewController animated:YES];
        [synSettingViewController release];
    }
}

#pragma mark WeiBoOpreate
- (void)timelineDidReceive:(SHNoteClient*)sender obj:(NSObject*)obj
{
	NSLog(@"begin timelineDidReceive");
    if (sender.hasError) {
		NSLog(@"timelineDidReceive error!!!, errorMessage:%@, errordetail:%@"
			  , sender.errorMessage, sender.errorDetail);
		//[sender alert];
        if (sender.statusCode == 401) {
            //[self openAuthenticateView];
        }
    }
    
    //解释obj
    
    return;
}


//=============================================================================================================================
#pragma mark OAuthSinaWeiboControllerDelegate
- (void) OAuthController: (OAuthController *) controller authenticatedWithUsername: (NSString *) username {
	NSLog(@"Authenicated for %@", username);
	//[self loadTimeline];
    //[OAuthEngine setCurrentOAuthEngine:_engine];
    
    //NSArray * ar = controller.navigationController.viewControllers;
    
    [controller dismissModalViewControllerAnimated:YES];
    
    [self.navigationItem.rightBarButtonItem setTitle:@"注销"];
    self.navigationItem.rightBarButtonItem.tag = 1;
    
    //数据载入
    [OAuthEngine setCurrentOAuthEngine:_engine];
    [self loadData];
}

- (void) OAuthControllerFailed: (OAuthController *) controller {
	NSLog(@"Authentication Failed!");
	//UIViewController *controller = [OAuthController controllerToEnterCredentialsWithEngine: _engine delegate: self];
	NSAssert(controller!=nil, @"Sherwin: OAuthControllerFailed.");
    
    [self.navigationItem.rightBarButtonItem setTitle:@"登陆"];
    self.navigationItem.rightBarButtonItem.tag = 2;
    
    [controller dismissModalViewControllerAnimated:YES];
    
	
}

- (void) OAuthControllerCanceled: (OAuthController *) controller {
	NSLog(@"Authentication Canceled.");
    //data process
    [self.navigationItem.rightBarButtonItem setTitle:@"登陆"];
    self.navigationItem.rightBarButtonItem.tag = 2;
    //etc:
    [controller dismissModalViewControllerAnimated:YES];
    return;
}

#pragma mark - button event
-(void)UserLog:(UIBarButtonItem*)sender
{
    if (sender.tag == 2) {
        if (_engine) [_engine release];
        
        _engine = [[OAuthEngine alloc] initOAuthWithDelegate: self];
		_engine.consumerKey    = kOAuthConsumerKey;
		_engine.consumerSecret = kOAuthConsumerSecret;
        
        [self loadTimeline];
        
        //登陆操作
        //初使化数据
    }else if(sender.tag ==1)
    {
        //注销操作
        //清除缓存
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:OAUTH_SAVE_KEY];
        [_engine release]; _engine = nil;
        [sender setTitle:@"登陆"]; sender.tag = 2;
        
        //清除数据库用户表数据
        [dbManage deleteNoteUserForDB];
    }
    
    NSLog(@"%@",sender);
}

- (IBAction)synchrodataEven:(UIButton *)sender {
    //同步处理
}

- (IBAction)switchPasswordProtection:(UISwitch *)sender {
    //数据存储
}
@end
