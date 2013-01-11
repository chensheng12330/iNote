//
//  HHYoukuMenuView.h
//  youku
//
//  Created by Eric on 12-3-12.
//  Copyright (c) 2012年 Tian Tian Tai Mei Net Tech (Bei Jing) Lt.d. All rights reserved.
//

#import <UIKit/UIKit.h>
#define  kButtonNum  11

typedef enum
{
    MK_MORE1=0,
    MK_MORE2,
    MK_MORE3,
    MK_MORE4,
    MK_MORE5,
    MK_MORE6,
    MK_MORE7,
    MK_INFO,
    MK_MENU,
    MK_FIND,
    MK_HOME
}MENU_KIND;

@class SHBottomMenuView;

@protocol SHBottomMenuDelegate <NSObject>
-(void) bottomMenuView:(SHBottomMenuView*) botMenuView SelectButton:(MENU_KIND)_menu_kind;
@end

@interface SHBottomMenuView : UIView
{
    UIImageView *rotationView;
    UIImageView *bgView;
    CGRect rect[kButtonNum];
    NSMutableArray *arrayButtonIcon;
    BOOL rotationViewIsNomal;//NO 为不显示状态 
    BOOL isMenuHide;
}

@property (assign) id<SHBottomMenuDelegate> delegate;
@property (nonatomic, retain)  UIImageView *rotationView;
@property (nonatomic, retain)  UIImageView *bgView;
@property (nonatomic, retain)   NSMutableArray *arrayButtonIcon;
+ (CGRect)getFrame;
- (BOOL)getisMenuHide;
- (void)showOrHideMenu;
@end
