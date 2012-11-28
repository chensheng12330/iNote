//
//  SHViewController.m
//  iNote
//
//  Created by sherwin.chen on 12-9-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//  Main Page Controller

#import "SHViewController.h"
#import <AudioToolbox/AudioToolbox.h>

#import "SHSettingViewController.h"

@interface SHViewController ()

@end

@implementation SHViewController
@synthesize centerButton;
@synthesize menuTitles,menuBgs,menuClass;
@synthesize backImageView;

- (id)init {
    self = [super init];
    if (self) {
        
        menuBgs    =nil;
        menuClass  =nil;
        menuTitles =nil;
    }
    return self;
}

-(void)dealloc
{
    [menuBgs        release];
    [menuClass      release];
    [menuTitles     release];
    [centerButton   release];
    [backImageView  release];
    [super dealloc];
    return;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Firstbg0.png"]];
    backImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);    
    [self.view addSubview:self.backImageView];
    
    // Do any additional setup after loading the view from its nib.
    NSMutableDictionary *menTb = [[[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menuData" ofType:@"plist"]]autorelease];
    self.menuBgs = [menTb objectForKey:@"menuBgs"];
    self.menuTitles = [menTb objectForKey:@"menuTitle"];
    
    
    CGFloat _cirewidth = 411.0/2.0;
    CGFloat _cirepointx = 57.0f;    
    CGFloat _cirepointy = 101.0f;
    
    BaseRotateView *mainView = [[BaseRotateView alloc] initWithFrame:CGRectMake(_cirepointx-_cirewidth/2, _cirepointy-_cirewidth/2, _cirewidth*2, _cirewidth*2)];
    mainView.backgroundColor = [UIColor clearColor];
    mainView.delegate = self;
    UIImageView *mainbg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Circle.png"]]; 
    
    mainbg.frame = CGRectMake(0, 0, _cirewidth, _cirewidth);
    mainbg.center = [mainView convertPoint:mainView.center fromView:self.view];
    [mainView addSubview:mainbg];
    [mainbg release];
    
    mainView.menuCount = 5;
    [self.view addSubview:mainView];
    [mainView release];
    

    UIImageView *iconbg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icobg.png"]]; 
    iconbg.frame = CGRectMake(110, 114, 199.0/2.0, 281.0/2.0);
    [self.view addSubview:iconbg];
    [iconbg release];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"Hot01.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(centerbuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(133, 177, 110.0/2.0, 110.0/2.0);
    centerButton = btn;
    [self.view addSubview:self.centerButton];
    return;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    return;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillDisappear:animated];
    
}

-(void)willRotateToMenu:(NSInteger)index rotateview:(BaseRotateView *)rotateview{
    //NSLog(@"index = %d",index);
    
    [self.centerButton setImage:[UIImage imageNamed:[self.menuBgs objectAtIndex:index]] forState:UIControlStateNormal];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"light-switch-1" ofType:@"wav"];
    if (path)
    {
        SystemSoundID soundId;
        AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path], &soundId);
        AudioServicesPlaySystemSound(soundId);  
    }
    self.centerButton.tag = index;
    self.backImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Firstbg%d.png",index]];
}

-(void)didRotateToMenu:(NSInteger)index rotateview:(BaseRotateView *)rotateview{
    self.centerButton.tag = index;
}

-(void)centerbuttonClicked:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
//    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"you click" message:[NSString stringWithFormat:@"%d",btn.tag] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] autorelease];
//    [alert show];
    
    UIViewController *subViewController = [[SHSettingViewController alloc] init];

    //id subClass = 
    switch (btn.tag) {
            NSLog(@"%d",btn.tag);
    }
    
    if (subViewController) {
        [self.navigationController pushViewController:subViewController animated:YES];
    }
    //    else{
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@ 栏目即将推出，敬请期待。",[self.menuTitles objectAtIndex:btn.tag]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    //        [alert show];
    //        [alert release]; 
    //    }
    [subViewController release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
@end
