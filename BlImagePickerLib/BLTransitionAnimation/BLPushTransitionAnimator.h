//
//  BLPushTransitionAnimator.h
//  翻页效果
//
//  Created by 冰泪 on 2017/6/19.
//  Copyright © 2017年 冰泪. All rights reserved.
//push跳转动画

#import "BLTrasitionAnimatorConfig.h"
@import UIKit;

@interface BLPushTransitionAnimator : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) BLTransitionAnimatorStyle animatorStyle;
- (instancetype)initWithTargetStyle:(BLTransitionAnimatorStyle)animatorStyle;

@end
