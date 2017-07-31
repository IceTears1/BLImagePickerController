//
//  BLTransitionAnimator.h
//  翻页效果
//
//  Created by 冰泪 on 2017/6/16.
//  Copyright © 2017年 冰泪. All rights reserved.
//  模态跳转 动画
#import "BLTrasitionAnimatorConfig.h"
@import UIKit;

@interface BLPresentTransitionAnimator : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) BLTransitionAnimatorStyle animatorStyle;
- (instancetype)initWithTargetStyle:(BLTransitionAnimatorStyle)animatorStyle;
@end
