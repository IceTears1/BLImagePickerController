//
//  BLTransitionAnimator.m
//  翻页效果
//
//  Created by 冰泪 on 2017/6/16.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import "BLPresentTransitionAnimator.h"
#import "BLDIYTrasitionAnimation.h"

@implementation BLPresentTransitionAnimator

- (instancetype)initWithTargetStyle:(BLTransitionAnimatorStyle)animatorStyle
{
    self = [self init];
    if (self) {
        self.animatorStyle = animatorStyle;
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
    
    //判断是present 还是dismiss
    BOOL isPresenting = (toViewController.presentingViewController == fromViewController);

    if (isPresenting){
         [containerView addSubview:toView];
    }else{
         [containerView insertSubview:toView belowSubview:fromView];
    }
    
    //执行动画的时间
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    
    switch (self.animatorStyle) {
        case BLTransitionAnimatorTop:{
            if (isPresenting) {
            
                fromView.frame = fromFrame;
                toView.frame = CGRectMake(0, -toFrame.size.height, toFrame.size.width, toFrame.size.height);
            } else {
                fromView.frame = fromFrame;
                toView.frame = toFrame;
            }
            [UIView animateWithDuration:transitionDuration animations:^{
                
                if (isPresenting) {
                    toView.frame = toFrame;
                } else {
                    fromView.frame = CGRectMake(0, -fromFrame.size.height, fromFrame.size.width, fromFrame.size.height);
                }
            } completion:^(BOOL finished) {
                // When we complete, tell the transition context
                // passing along the BOOL that indicates whether the transition
                // finished or not.
                BOOL wasCancelled = [transitionContext transitionWasCancelled];
                if (wasCancelled)
                    [toView removeFromSuperview];
                [transitionContext completeTransition:!wasCancelled];
            }];
        }
            break;
        case BLTransitionAnimatorBottom:{
            
            if (isPresenting) {
                fromView.frame = fromFrame;
                toView.frame = CGRectMake(0, toFrame.size.height, toFrame.size.width, toFrame.size.height);
            } else {
                fromView.frame = fromFrame;
                toView.frame = toFrame;
            }
            [UIView animateWithDuration:transitionDuration animations:^{
                
                if (isPresenting) {
                    toView.frame = toFrame;
                } else {
                    // For a dismissal, the fromView slides off the screen.
                    fromView.frame = CGRectMake(0, fromFrame.size.height, fromFrame.size.width, fromFrame.size.height);
                }
            } completion:^(BOOL finished) {
                // When we complete, tell the transition context
                // passing along the BOOL that indicates whether the transition
                // finished or not.
                BOOL wasCancelled = [transitionContext transitionWasCancelled];
                if (wasCancelled)
                    [toView removeFromSuperview];
                [transitionContext completeTransition:!wasCancelled];
            }];
        }
            break;
        case BLTransitionAnimatorLeft:{
            
            if (isPresenting) {
                fromView.frame = fromFrame;
                toView.frame = CGRectMake(-toFrame.size.width, 0, toFrame.size.width, toFrame.size.height);
            } else {
                fromView.frame = fromFrame;
                toView.frame = toFrame;
            }
            [UIView animateWithDuration:transitionDuration animations:^{
                
                if (isPresenting) {
                    toView.frame = toFrame;
                } else {
           
                    fromView.frame = CGRectMake(-fromFrame.size.width, 0, fromFrame.size.width, fromFrame.size.height);
                }
            } completion:^(BOOL finished) {

                BOOL wasCancelled = [transitionContext transitionWasCancelled];
                if (wasCancelled)
                    [toView removeFromSuperview];
                [transitionContext completeTransition:!wasCancelled];
            }];
        }
            break;
        case BLTransitionAnimatorRight:{
            if (isPresenting) {
                fromView.frame = fromFrame;
                toView.frame = CGRectMake(toFrame.size.width, 0, toFrame.size.width, toFrame.size.height);
            } else {
                fromView.frame = fromFrame;
                toView.frame = toFrame;
            }
            [UIView animateWithDuration:transitionDuration animations:^{
                
                if (isPresenting) {
                    toView.frame = toFrame;
                } else {
                    fromView.frame = CGRectMake(fromFrame.size.width, 0, fromFrame.size.width, fromFrame.size.height);
                }
            } completion:^(BOOL finished) {

                BOOL wasCancelled = [transitionContext transitionWasCancelled];
                if (wasCancelled)
                    [toView removeFromSuperview];
                [transitionContext completeTransition:!wasCancelled];
            }];
        }
            break;
        case BLTransitionAnimatorCustom:{
            
            BLTransitionType type ;
            if (isPresenting) {
                
                type = BLTransitionTypePresent;
            } else {
                type = BLTransitionTypeDismiss;
            }
            BLDIYTrasitionAnimation *diy = [[BLDIYTrasitionAnimation alloc]init];
            
            [diy customAnimationType:type ToView:toView FromView:fromView transitionDuration:transitionDuration finished:^(NSString *finished) {
//                NSLog(@"%@",finished);
                BOOL wasCancelled = [transitionContext transitionWasCancelled];
                if (wasCancelled)
                    [toView removeFromSuperview];
                [transitionContext completeTransition:!wasCancelled];
                
            }];
        }
            break;
            
        default:
            break;
    }
    


}
@end
