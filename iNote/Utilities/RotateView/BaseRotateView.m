//
//  RotateView.m
//  TryRoundDisk
//
//  Created by sean sean on 12-2-3.
//  Copyright (c) 2012年 clochase. All rights reserved.
//

#import "BaseRotateView.h"


 
@interface BaseRotateView (Private)
-(void)didmoved;

- (float) toAngle:(CGPoint) v;
- (CGPoint) cgpSub:(CGPoint)v1: (CGPoint)v2;


@end

@implementation BaseRotateView

@synthesize menuCount;
@synthesize delegate;
@synthesize rateAngle;

 
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        rateAngle = 0.0f;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)setRotate:(float)degress
{
    rateAngle+=degress;
    //NSLog(@"jiaodu=%f,%f",ratejiaodu,degress);
    float rotate = CC_DEGREES_TO_RADIANS(degress);
    
    CGAffineTransform transform = self.transform; 	 
    
	CGAffineTransform newtransform = CGAffineTransformRotate(transform, rotate);
	self.transform = newtransform; 
    
    NSInteger t =   (NSInteger)rateAngle%360;
    if (t<0) {
        t = 360 + t;
    }
    
    if (self.menuCount==0) {
        return;
    }
    NSInteger per = (NSInteger)(360/self.menuCount);    
    NSInteger index = t / per;
    NSInteger yu = t % per; 

    //NSInteger m = t % self.menuCount;
    if (yu>per/2) {
        index++;
    } 
    index = index % self.menuCount;
   // NSLog(@"index=%d,yu=%d,offset=%d",index,yu,per-yu);
    if (currentIndex != index) {
        currentIndex = index;
        if (self.delegate!=nil) {
            [self.delegate willRotateToMenu:currentIndex rotateview:self];
        }
    }
    
}
-(CGPoint)newCirclePoint:(CGPoint)point center:(CGPoint)center theangle:(float)theangle{
    float x = (point.x - center.x)*cosf(-theangle) + (point.y - center.y ) * sinf(-theangle) + center.x;
    float y = (point.y - center.y)*cosf(-theangle) - (point.x - center.x)*sinf(-theangle) + center.y;
    return CGPointMake(x, y);
}

- (CGPoint) cgpSub:(CGPoint)v1: (CGPoint)v2
{
    CGPoint point;
    point.x = v1.x - v2.x;
    point.y = v1.y - v2.y;
    
    return point; 
}
- (float) toAngle:(CGPoint) v
{
    return atan2f(v.x, v.y);
}
 

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    angle = 0;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	
    UITouch *touch = [touches anyObject];
    
    CGPoint previousLocation = [touch previousLocationInView:touch.view];
    CGPoint previouscgp = [self cgpSub:previousLocation :self.center];
    float previousVector = [self toAngle:previouscgp];
    
    float previousDrgress = CC_RADIANS_TO_DEGREES(previousVector);
    
    CGPoint nowLocation = [touch locationInView:touch.view];
    CGPoint nowcgp = [self cgpSub:nowLocation :self.center];
    float nowVector = [self toAngle:nowcgp];
    float nowDrgress = CC_RADIANS_TO_DEGREES(nowVector);
    
    angle = -(nowDrgress - previousDrgress);
   // NSLog(@"%f",angle);
    [self setRotate:angle];
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
   // currentIndex
    if (self.menuCount==0) {
        return;
    }
    [self endRotatemoved];
}

-(void)endRotatemoved{
    
    CGFloat per = 360.0/self.menuCount;
    rateAngle=per*currentIndex;
    CGAffineTransform newtransform = CGAffineTransformMakeRotation(CC_DEGREES_TO_RADIANS(per*currentIndex));
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDidStopSelector:@selector(didmoved)];
    self.transform = newtransform;
    [UIView commitAnimations];
}

-(void)didmoved{
    if (self.delegate) {
        [self.delegate didRotateToMenu:currentIndex rotateview:self];
    }
}

@end
