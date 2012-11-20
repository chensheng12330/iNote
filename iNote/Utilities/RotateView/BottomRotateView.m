//
//  BottomRotateView.m
//  MM
//
//  Created by user on 12-2-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BottomRotateView.h"

@interface BottomRotateView (private)
-(void)reTransformSubviews:(CGFloat) newangle;
@end

@implementation BottomRotateView

- (void)setRotate:(float)degress
{
    [super setRotate:degress];  
    [self reTransformSubviews:-1*CC_DEGREES_TO_RADIANS(rateAngle)];
}


-(void)reTransformSubviews:(CGFloat) newangle{
    CGAffineTransform newtransform2 = CGAffineTransformMakeRotation(newangle);    
    for (UIView *subview in self.subviews) {
        [subview setTransform:newtransform2];
    } 
}

-(void)endRotatemoved{
    [super endRotatemoved];    
    
    CGFloat per = 360.0/self.menuCount;
    rateAngle=per*currentIndex;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [self reTransformSubviews:-1 * CC_DEGREES_TO_RADIANS( per*currentIndex)];  
    [UIView commitAnimations];
    
}
@end
