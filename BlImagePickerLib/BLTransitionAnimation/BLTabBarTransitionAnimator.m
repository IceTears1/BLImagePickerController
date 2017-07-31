//
//  BLTabBarTransitionAnimator.m
//  翻页效果
//
//  Created by 冰泪 on 2017/6/20.
//  Copyright © 2017年 冰泪. All rights reserved.
//tabbar 转场动画

#import "BLTabBarTransitionAnimator.h"

@implementation BLTabBarTransitionAnimator
- (instancetype)initWithTargetStyle:(BLTabBarSlidingDirectionStyle)style
{
    self = [self init];
    if (self) {
        self.style = style ;
    }
    return self;
}

//| ----------------------------------------------------------------------------
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return TransitionDuration;
}


//| ----------------------------------------------------------------------------
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    
    
    UIView *fromView;
    UIView *toView;
    
    //从文本控制器里边拿到 源控制器view（fromView） 和  目标控制器的 view（toView）
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        fromView = fromViewController.view;
        toView = toViewController.view;
    }
    
    fromView.frame = [transitionContext initialFrameForViewController:fromViewController];
    toView.frame = [transitionContext finalFrameForViewController:toViewController];
    
    //获取from 和 toview 的 frame
    CGRect fromFrame = [transitionContext initialFrameForViewController:fromViewController];
    CGRect toFrame = [transitionContext finalFrameForViewController:toViewController];
    //执行动画的时间
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    
    switch (self.style) {
        case BLTabBarSlidingDirectionLeft:{
            [containerView addSubview:toView];
            fromView.frame = fromFrame;
            toView.frame = CGRectMake(-toFrame.size.width, 0, toFrame.size.width, toFrame.size.height);
            
            [UIView animateWithDuration:transitionDuration animations:^{
                
                
                toView.frame = toFrame;
                
                fromView.frame = CGRectMake( fromFrame.size.width,0, fromFrame.size.width, fromFrame.size.height);
                
            } completion:^(BOOL finished) {
                
                BOOL wasCancelled = [transitionContext transitionWasCancelled];
                if (wasCancelled)
                    [toView removeFromSuperview];
                [transitionContext completeTransition:!wasCancelled];
            }];
        }
            break;
        case BLTabBarSlidingDirectionRight:{
            [containerView addSubview:toView];
            fromView.frame = fromFrame;
            toView.frame = CGRectMake(toFrame.size.width, 0,toFrame.size.width, toFrame.size.height);
            
            [UIView animateWithDuration:transitionDuration animations:^{
                
                
                toView.frame = toFrame;
                
                fromView.frame = CGRectMake(-fromFrame.size.width, 0 , fromFrame.size.width, fromFrame.size.height);
                
            } completion:^(BOOL finished) {
                
                BOOL wasCancelled = [transitionContext transitionWasCancelled];
                if (wasCancelled)
                    [toView removeFromSuperview];
                [transitionContext completeTransition:!wasCancelled];
            }];

        }
            break;
       
            
        default:{
            
        }
            break;
    }
    
    
}
@end
