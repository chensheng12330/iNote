//
//  MemberCenterRotateView.h
//  MM
//
//  Created by user on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseRotateView.h"

@interface MemberCenterRotateView : BaseRotateView
{
    NSArray *arMenuTitle;
}
@property(nonatomic,retain) NSArray *arMenuTitle;

-(void)reZoomSubviews;
- (void)setRotate:(float)degress animated:(BOOL)animated;
- (void)setRotate:(float)degress animated:(BOOL)animated second:(CGFloat)second;
@end
