//
//  BLTabBarTransitionAnimator.h
//  翻页效果
//
//  Created by 冰泪 on 2017/6/20.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import "BLTrasitionAnimatorConfig.h"
@import UIKit;

@interface BLTabBarTransitionAnimator : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) BLTabBarSlidingDirectionStyle style;
- (instancetype)initWithTargetStyle:(BLTabBarSlidingDirectionStyle)style;
@end
