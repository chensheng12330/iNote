//
//  SHFTAnimationExample.h
//  iNote
//
//  Created by sherwin.chen on 13-1-16.
//
//

#import <Foundation/Foundation.h>
#import "FTAnimation.h"

@interface SHFTAnimationExample : NSObject

#define BACKINOUT_DURA (0.4)
//跳动移动视图 [方向可选]
+(void) BackInOut:(FTAnimationDirection)direction  //动画方向
        mainView:(UIView*)_mainView               //主视图（运动主体）
          inView:(UIView*)_inView                 //运动参照视图（一般是 _mainView.superView）
        withFade:(BOOL)fade                       //是否翻转
        duration:(NSTimeInterval)duration         //运动时间
        delegate:(id)delegate                     //动作事件传送对象
   startSelector:(SEL)startSelector               //开始动作事件
    stopSelector:(SEL)stopSelector;               //结束动作事件

//平向移动视图，不加任何附属动作 [方向可选]
#define SLIDE_INOUT_DIRA (0.4)
-(void) SlideInOut:(FTAnimationDirection)direction
          mainView:(UIView*)_mainView
            inView:(UIView*)_inView
          withFade:(BOOL)fade
          duration:(NSTimeInterval)duration
          delegate:(id)delegate
     startSelector:(SEL)startSelector
      stopSelector:(SEL)stopSelector;

#define FADE_COLOR_INOUT_DURA (0.4)
//视图背景颜色渐变
+(void) FadeBackgroundColorInOut:(NSTimeInterval)duration
                        mainView:(UIView*)_mainView
                        delegate:(id)delegate
                   startSelector:(SEL)startSelector
                    stopSelector:(SEL)stopSelector;
//渐入视图
+(void) FadeInOut:(NSTimeInterval)duration
         mainView:(UIView*)_mainView
         delegate:(id)delegate
    startSelector:(SEL)startSelector
     stopSelector:(SEL)stopSelector;

//放大消失(飞出)
+(void) FlyOut:(NSTimeInterval)duration
      mainView:(UIView*)_mainView
      delegate:(id)delegate
 startSelector:(SEL)startSelector
  stopSelector:(SEL)stopSelector;

//从天而降-缩小消失
+(void) FallInOut:(NSTimeInterval)duration
         mainView:(UIView*)_mainView
         delegate:(id)delegate
    startSelector:(SEL)startSelector
     stopSelector:(SEL)stopSelector;

//弹入，弹出
+(void) PopInOut:(NSTimeInterval)duration
        mainView:(UIView*)_mainView
        delegate:(id)delegate
   startSelector:(SEL)startSelector
    stopSelector:(SEL)stopSelector;

@end
