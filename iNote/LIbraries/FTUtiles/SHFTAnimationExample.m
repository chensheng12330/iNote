//
//  SHFTAnimationExample.m
//  iNote
//
//  Created by sherwin.chen on 13-1-16.
//
//

#import "SHFTAnimationExample.h"

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

-(void) SlideInOut:(FTAnimationDirection)direction
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
        [_mainView fallIn:duration delegate:nil startSelector:nil stopSelector:nil];
    } else {
        [_mainView fallOut:duration delegate:nil startSelector:nil stopSelector:nil];
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
    
    if(_mainView.hidden) {
        [_mainView popIn:duration delegate:nil startSelector:nil stopSelector:nil];
    } else {
        [_mainView popOut:duration delegate:nil startSelector:nil stopSelector:nil];
    }
    return;
}
@end
