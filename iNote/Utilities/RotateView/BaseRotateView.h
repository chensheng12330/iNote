//
//  RotateView.h
//  TryRoundDisk
//
//  Created by sean sean on 12-2-3.
//  Copyright (c) 2012年 clochase. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CC_RADIANS_TO_DEGREES(__ANGLE__) (__ANGLE__ / M_PI * 180.0)
#define CC_DEGREES_TO_RADIANS(__ANGLE__) (__ANGLE__ / 180.0 * M_PI)

@class BaseRotateView;

@protocol RotateViewDelegate 
-(void)willRotateToMenu:(NSInteger)index rotateview:(BaseRotateView *)rotateview;
-(void)didRotateToMenu:(NSInteger)index rotateview:(BaseRotateView *)rotateview;
@end

@interface BaseRotateView : UIView
{
    float angle;
    float rateAngle;
    NSInteger menuCount;
    id <RotateViewDelegate> delegate; 
    NSInteger currentIndex;
}
@property float rateAngle;
@property(nonatomic,assign) NSInteger menuCount;
@property(nonatomic,assign) id <RotateViewDelegate> delegate;

- (void)setRotate:(float)degress;
-(CGPoint) newCirclePoint:(CGPoint)point center:(CGPoint)center theangle:(float)theangle;

-(void)endRotatemoved;

@end
