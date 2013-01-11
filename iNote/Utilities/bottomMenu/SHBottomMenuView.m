//
//  HHYoukuMenuView.m
//  youku
//
//  Created by Eric on 12-3-12.
//  Copyright (c) 2012年 Tian Tian Tai Mei Net Tech (Bei Jing) Lt.d. All rights reserved.
//

#import "SHBottomMenuView.h"
#import <QuartzCore/QuartzCore.h>
#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)


@implementation SHBottomMenuView
@synthesize rotationView,arrayButtonIcon,bgView;
@synthesize delegate = _delegate;

- (void)dealloc
{
    [bgView release];
    [arrayButtonIcon release];
    [rotationView release];
    [super dealloc];
}

+ (CGRect)getFrame
{
    return CGRectMake((320.0 - 296.0)/2.0,460.0 - 148.0 + 14,296.0,148.0);
}

+ (CGRect)getHideFrame
{
    return CGRectMake((320.0 - 296.0)/2.0,460.0,296.0,148.0);
}

- (void)setButtonsFrame
{
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"bottomMenu" ofType:@"plist"];
    arrayButtonIcon = [[NSMutableArray alloc] initWithContentsOfFile:path];
    return;
}

- (void)initView
{
    bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menu1.png"]];
    bgView.frame = CGRectMake(53.0,49.0,191.0, 86.0);
    [self addSubview:bgView];
    //[bgView release];
    
    rotationView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menu2.png"]];
    rotationView.frame = CGRectMake(0.0, 0.0+ 148.0/2.0,296, 148);
    rotationView.userInteractionEnabled = YES;
    rotationView.layer.anchorPoint = CGPointMake(0.5,1.0);
    if (rotationViewIsNomal)
    {
        rotationView.layer.transform = CATransform3DIdentity;
    }
    else
    {
        rotationView.layer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(180),0.0, 0.0, 1.0);;
    }
    [self addSubview:rotationView];
    //[rotationView release];
    
    for (int i = 0;i < 11 ;i++ )
    {
        NSDictionary *dic = [arrayButtonIcon objectAtIndex:i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([dic objectForKey:@"frame"]) { button.frame = CGRectFromString([dic objectForKey:@"frame"]);}
    
        if ([dic objectForKey:@"nomal"]){[button setImage:[UIImage imageNamed:[dic objectForKey:@"nomal"]] forState:UIControlStateNormal];}
        
        if ([dic objectForKey:@"high"]){[button setImage:[UIImage imageNamed:[dic objectForKey:@"high"]] forState:UIControlStateHighlighted];}
        [button addTarget:self action:@selector(meunButtonDown:) forControlEvents:UIControlEventTouchUpInside];
        
        if([dic objectForKey:@"menu_kind"]){ button.tag = [[dic objectForKey:@"menu_kind"] intValue];}
        
        button.showsTouchWhenHighlighted = YES;
        
        if(i<7){[rotationView  addSubview:button];} //roteation view cell
        else [self  addSubview:button]; //memu view cell
    }
}


- (void)meunButtonDown:(id)sender
{
    
    UIButton *button = (UIButton *)sender;
    NSLog(@"%d",button.tag);
    if (button.tag == 8)
    {
        button.userInteractionEnabled = NO;
        [UIView beginAnimations:@"present-countdown" context:nil];
        [UIView setAnimationDuration:1];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDidStopSelector:@selector(rotationAnimationStop)];
        CGFloat angle = rotationViewIsNomal ? 180.0:0.0;
        rotationView.layer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(angle),0.0, 0.0, 1.0);
        [UIView commitAnimations];
    }
    // delegate message
    SEL sentAction = @selector(bottomMenuView:SelectButton:);
    if(_delegate!=NULL && [_delegate retainCount]>0 && [_delegate respondsToSelector:sentAction])
    {
        [_delegate bottomMenuView:self SelectButton:button.tag];
        //[_delegate performSelector:sentAction withObject:self withObject:button.tag];
    }
    return;
}

- (void)rotationAnimationStop
{
    UIButton *menuButton =  (UIButton *)[self viewWithTag:8];
    menuButton.userInteractionEnabled = YES;
    rotationViewIsNomal = !rotationViewIsNomal;
}

- (void)hideMenuAnimationStop
{
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        rotationViewIsNomal = NO;
        isMenuHide = NO;
        [self setButtonsFrame];
        [self initView];
    }
    return self;
}

- (void)showOrHideMenu
{
    [UIView beginAnimations:@"present-countdown" context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(hideMenuAnimationStop)];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

    if (!isMenuHide) 
    {
        self.frame = [SHBottomMenuView getHideFrame];
    }
    else
    {
        self.frame = [SHBottomMenuView getFrame];
    }
    isMenuHide = !isMenuHide;
    [UIView commitAnimations];
}

- (BOOL)getisMenuHide
{
    return isMenuHide;
}


@end
