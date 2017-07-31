//
//  BLTrasitionAnimatorConfig.h
//  翻页效果
//
//  Created by 冰泪 on 2017/6/19.
//  Copyright © 2017年 冰泪. All rights reserved.
//
#import <UIKit/UIKit.h>
#ifndef BLTrasitionAnimatorConfig_h
#define BLTrasitionAnimatorConfig_h

#define TransitionDuration 0.4  //翻转动画执行的时间间隔
typedef void(^BL_AnimationFinished)(NSString *finished);

typedef NS_OPTIONS(NSUInteger, BLTransitionAnimatorStyle) {
    BLTransitionAnimatorTop= 0,//从顶部滑入
    BLTransitionAnimatorLeft, //从左边滑入
    BLTransitionAnimatorBottom, //从底部滑入
    BLTransitionAnimatorRight,//从右边滑入
    BLTransitionAnimatorCustom//自定义动画
};

typedef NS_OPTIONS(NSUInteger, BLTabBarSlidingDirectionStyle) {

    BLTabBarSlidingDirectionLeft = 0, //点击左边按钮
    BLTabBarSlidingDirectionRight, //点击右边按钮
    BLTabBarSlidingDirectionNone //点击当前页按钮
};

typedef NS_ENUM(NSUInteger, BLGestureDirection) {//手势的方向
    BLGestureDirectionLeft = 0,
    BLGestureDirectionRight,
    BLGestureDirectionUp,
    BLGestureDirectionDown
};

typedef NS_ENUM(NSUInteger, BLTransitionType) {//手势控制哪种转场
    BLTransitionTypePresent = 0,
    BLTransitionTypeDismiss,
    BLTransitionTypePush,
    BLTransitionTypePop,
};

#endif /* BLTrasitionAnimatorConfig_h */
