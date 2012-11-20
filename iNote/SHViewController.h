//
//  SHViewController.h
//  iNote
//
//  Created by clochase on 12-9-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberCenterRotateView.h"

@interface SHViewController : UIViewController<RotateViewDelegate>
{
    UIButton *centerButton;
    NSArray *menuTitles;
    NSArray *menuBgs;
    NSArray *menuClass;
    
    UIImageView *backImageView;
}

@property(nonatomic,retain) UIImageView *backImageView;
@property(nonatomic,retain) NSArray *menuTitles;
@property(nonatomic,retain) NSArray *menuBgs;
@property(nonatomic,retain) NSArray *menuClass;
@property(nonatomic,retain) UIButton *centerButton;

-(void)centerbuttonClicked:(id)sender;
@end
