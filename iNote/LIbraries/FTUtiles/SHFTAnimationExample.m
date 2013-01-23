//
//  SHFTAnimationExample.m
//  iNote
//
//  Created by sherwin.chen on 13-1-16.
//
//

#import "SHFTAnimationExample.h"
#import "FTUtils+UIGestureRecognizer.h"

@implementation SHFTAnimationExample

+(void) BackInOut:(FTAnimationDirection)direction
        mainView:(UIView*)_mainView
          inView:(UIView*)_inView
        withFade:(BOOL)fade
        duration:(NSTimeInterval)duration
        delegate:(id)delegate
   startSelector:(SEL)startSelector
    stopSelector:(SEL)stopSelector
{
    // parameter check
    NSAssert(!(direction <kFTAnimationTop || direction>kFTAnimationBottomRight ||
               _mainView == NULL || _mainView.retainCount<1 ||
               _inView   == NULL || _inView.retainCount<1),
             @"SHFTAnimationExample->BacInOut: paramerter is null");
    
    if(_mainView.hidden) {
        [_mainView backInFrom:direction inView:_inView withFade:NO duration:duration delegate:delegate startSelector:startSelector stopSelector:stopSelector];
    } else {
        [_mainView backOutTo:direction inView:_inView withFade:NO duration:duration delegate:delegate startSelector:startSelector stopSelector:stopSelector];
    }
    return;
}

+(void) SlideInOut:(FTAnimationDirection)direction
          mainView:(UIView*)_mainView
            inView:(UIView*)_inView
          withFade:(BOOL)fade
          duration:(NSTimeInterval)duration
          delegate:(id)delegate
     startSelector:(SEL)startSelector
      stopSelector:(SEL)stopSelector
{
    NSAssert(!(direction <kFTAnimationTop || direction>kFTAnimationBottomRight ||
               _mainView == NULL || _mainView.retainCount<1 ||
               _inView   == NULL || _inView.retainCount<1),
             @"SHFTAnimationExample->SlideInOut: paramerter is null");
    
    if(_mainView.hidden) {
        [_mainView slideInFrom:direction inView:_inView duration:duration delegate:delegate startSelector:startSelector stopSelector:stopSelector];
    } else {
        [_mainView slideOutTo:direction inView:_inView duration:duration delegate:delegate startSelector:startSelector stopSelector:stopSelector];
    }
    return;
}

+(void) FadeBackgroundColorInOut:(NSTimeInterval)duration
                        mainView:(UIView*)_mainView
                        delegate:(id)delegate
                   startSelector:(SEL)startSelector
                    stopSelector:(SEL)stopSelector
{
    // parameter check
    NSAssert(!(_mainView == NULL || _mainView.retainCount<1),
             @"SHFTAnimationExample->FadeBackgroundColorInOut: paramerter is null");
    if(_mainView.hidden) {
        [_mainView fadeBackgroundColorIn:duration delegate:delegate startSelector:startSelector stopSelector:stopSelector];
    } else {
        [_mainView fadeBackgroundColorOut:duration delegate:delegate startSelector:startSelector stopSelector:stopSelector];
    }
}

//渐入视图
+(void) FadeInOut:(NSTimeInterval)duration
         mainView:(UIView*)_mainView
         delegate:(id)delegate
    startSelector:(SEL)startSelector
     stopSelector:(SEL)stopSelector
{
    // parameter check
    NSAssert(!(_mainView == NULL || _mainView.retainCount<1),
             @"SHFTAnimationExample->FadeInOut: paramerter is null");
    
    if(_mainView.hidden) {
        [_mainView fadeIn:duration delegate:delegate startSelector:startSelector stopSelector:stopSelector];
    } else {
        [_mainView fadeOut:duration delegate:delegate startSelector:startSelector stopSelector:stopSelector];
    }
    return;
}

//放大消失(飞出)
+(void) FlyOut:(NSTimeInterval)duration
      mainView:(UIView*)_mainView
      delegate:(id)delegate
 startSelector:(SEL)startSelector
  stopSelector:(SEL)stopSelector
{
    // parameter check
    NSAssert(!(_mainView == NULL || _mainView.retainCount<1),
             @"SHFTAnimationExample->FlyOut: paramerter is null");
    if(_mainView.hidden) {
        [_mainView fadeIn:duration-0.2 delegate:delegate startSelector:startSelector stopSelector:stopSelector];
    } else {
        [_mainView flyOut:duration delegate:delegate startSelector:startSelector stopSelector:stopSelector];
    }
}

//从天而降-缩小消失
+(void) FallInOut:(NSTimeInterval)duration
         mainView:(UIView*)_mainView
         delegate:(id)delegate
    startSelector:(SEL)startSelector
     stopSelector:(SEL)stopSelector
{
    // parameter check
    NSAssert(!(_mainView == NULL || _mainView.retainCount<1),
             @"SHFTAnimationExample->FallInOut: paramerter is null");
    
    if(_mainView.hidden) {
        [_mainView fallIn:duration delegate:delegate startSelector:startSelector stopSelector:stopSelector];
    } else {
        [_mainView fallOut:duration delegate:delegate startSelector:startSelector stopSelector:stopSelector];
    }
    return;
}

//弹入，弹出
+(void) PopInOut:(NSTimeInterval)duration
        mainView:(UIView*)_mainView
        delegate:(id)delegate
   startSelector:(SEL)startSelector
    stopSelector:(SEL)stopSelector
{
    // parameter check
    NSAssert(!(_mainView == NULL || _mainView.retainCount<1),
             @"SHFTAnimationExample->PopInOut: paramerter is null");
    
    if(!_mainView.hidden) {
        [_mainView popIn:duration delegate:delegate startSelector:startSelector stopSelector:stopSelector];
    } else {
        [_mainView popOut:duration delegate:delegate startSelector:startSelector stopSelector:stopSelector];
    }
    return;
}

+(void) MoveView:(UIView*)viewToAnimate
{
    // parameter check
    NSAssert(!(viewToAnimate == NULL || viewToAnimate.retainCount<1),
             @"SHFTAnimationExample->ControlViewMove: paramerter is null");
    
    viewToAnimate.userInteractionEnabled = YES;
    viewToAnimate.multipleTouchEnabled   = YES;
#if NS_BLOCKS_AVAILABLE
    
    [viewToAnimate addGestureRecognizer:
     [UIPanGestureRecognizer recognizerWithActionBlock:^(UIPanGestureRecognizer *pan) {
        if(pan.state == UIGestureRecognizerStateBegan ||
           pan.state == UIGestureRecognizerStateChanged) {
            CGPoint translation = [pan translationInView:viewToAnimate.superview];
            
            viewToAnimate.center =  CGPointMake(viewToAnimate.center.x + translation.x,
                                                     viewToAnimate.center.y + translation.y);
            [pan setTranslation:CGPointZero inView:viewToAnimate.superview];
        }
    }]];
    
    UIPinchGestureRecognizer *thePinch = [UIPinchGestureRecognizer recognizer];
    thePinch.actionBlock = ^(UIPinchGestureRecognizer *pinch) {
        if ([pinch state] == UIGestureRecognizerStateBegan ||
            [pinch state] == UIGestureRecognizerStateChanged) {
            viewToAnimate.transform = CGAffineTransformScale(viewToAnimate.transform, pinch.scale, pinch.scale);
            [pinch setScale:1];
        }
    };
    [viewToAnimate addGestureRecognizer:thePinch];
    
    UITapGestureRecognizer *doubleTap = [UITapGestureRecognizer recognizerWithActionBlock:^(id dTap) {
        thePinch.disabled = !thePinch.disabled;
        [UIView animateWithDuration:.25f animations:^{
            viewToAnimate.transform = CGAffineTransformIdentity;
        }];
    }];
    doubleTap.numberOfTapsRequired = 2;
    [viewToAnimate addGestureRecognizer:doubleTap];
    
#endif
    
}
+(void) ReleaseMoveControl4View:(UIView*)viewToAnimate
{
    // parameter check
    NSAssert(!(viewToAnimate == NULL || viewToAnimate.retainCount<1),
             @"SHFTAnimationExample->ReleaseControlView: paramerter is null");
    
    for(UIGestureRecognizer *recognizer in viewToAnimate.gestureRecognizers) {
        [viewToAnimate removeGestureRecognizer:recognizer];
    }
}
@end
