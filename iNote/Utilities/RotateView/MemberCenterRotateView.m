//
//  MemberCenterRotateView.m
//  iNote
//
//  Created by sean on 2/16/12.
//  Updated by Sherwin on 9/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MemberCenterRotateView.h"

#define ZOOM_ANGLE 0.5
#define ZOOM_Duration 1.0


@interface MemberCenterRotateView (private)
-(void)reTransformSubviews:(CGFloat) newangle;
-(NSString *)menuTitle:(NSInteger)index;
-(void)range90;
@end

@implementation MemberCenterRotateView
@synthesize arMenuTitle;

- (id)init
{
    self = [super init];
    if (self) {
        arMenuTitle = nil;
    }
    return self;
}

-(void)dealloc
{
    [arMenuTitle release];
    [super dealloc];
    return;
}

- (void)setRotate:(float)degress
{
    [super setRotate:degress];
    NSInteger t =   (NSInteger)rateAngle%360;
    NSLog(@"t=%d",t);
    [self reTransformSubviews: 3.14*2 - CC_DEGREES_TO_RADIANS(t)];
    /*
    if (t==180) {
       [self reTransformSubviews: 3.14*2 - CC_DEGREES_TO_RADIANS(t)];
    }
    else{
      [self reTransformSubviews: 3.14*2 - CC_DEGREES_TO_RADIANS(t)];  
    }
     */
    return;
}

- (void)setRotate:(float)degress animated:(BOOL)animated{
    if (animated) {           
        [UIView beginAnimations:nil context:nil];            
        [UIView setAnimationDuration:ZOOM_Duration];
        [self setRotate:degress]; 
        [UIView commitAnimations];        
    }
    else
    {
        [self setRotate:degress];
    }
}

- (void)setRotate:(float)degress animated:(BOOL)animated second:(CGFloat)second{
    if (animated) {   
        [UIView beginAnimations:nil context:nil];            
        [UIView setAnimationDuration:second];
        [self setRotate:degress]; 
        [UIView commitAnimations]; 
    }
    else
    {
        [self setRotate:degress];
    }
 
}

-(void)range90{
    [self setRotate:90 animated:YES second:ZOOM_Duration/2];
}


-(void)reTransformSubviews:(CGFloat) newangle{
    //NSLog(@"hudu = %f",newangle);
   
    CGAffineTransform newtransform2 = CGAffineTransformMakeRotation(newangle); 
    CGFloat menuAngle = 0;
    NSInteger t =   (NSInteger)rateAngle%360;
    if (t<0) {
        t = 360 + t;
    }
    for (UIView *subview in self.subviews) {          
        //current jiaodu
        menuAngle = (t + 360/self.menuCount * subview.tag ) % 360;
        if (menuAngle>180) {
            menuAngle = 360 - menuAngle; 
        }
        CGFloat zoom = 1- menuAngle / 180;
        zoom = ZOOM_ANGLE + zoom * ZOOM_ANGLE ;
        
        CGAffineTransform newTransform = CGAffineTransformScale(newtransform2,zoom, zoom);            
        subview.transform = newTransform;            
    }
}

-(void)endRotatemoved{
    [super endRotatemoved];     
    
    CGFloat per = 360.0/self.menuCount;
    rateAngle=per*currentIndex;    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [self reTransformSubviews:-1 * CC_DEGREES_TO_RADIANS( per*currentIndex)];  
    //[self reZoomSubviews];  
    [UIView commitAnimations];    
    
}

-(void)reZoomSubviews{    
    CGFloat menuAngle = 0;
    NSInteger t =   (NSInteger)rateAngle%360;
    if (t<0) {
        t = 360 + t;
    }
    for (UIView *subview in self.subviews) {          
        //current jiaodu
        menuAngle = (t + 360/self.menuCount * subview.tag ) % 360;
        if (menuAngle>180) {
            menuAngle = 360 - menuAngle; 
        }
        CGFloat zoom = 1- menuAngle / 180;
        zoom = ZOOM_ANGLE + zoom * ZOOM_ANGLE ;
        
        //NSLog(@"btn index = %d, %@ ,%f",subview.tag,[self menuTitle:subview.tag], zoom);
        CGAffineTransform oldTransform = subview.transform;
        CGAffineTransform newTransform = CGAffineTransformScale(oldTransform,zoom, zoom);            
        subview.transform = newTransform;            
        
    } 
}

-(NSString *)menuTitle:(NSInteger)index{
    if (arMenuTitle==nil || arMenuTitle.count<index) {
        return nil;
    }
    NSString *tStr = [arMenuTitle objectAtIndex:index];
    return (tStr==nil)? nil:tStr;
}
@end
