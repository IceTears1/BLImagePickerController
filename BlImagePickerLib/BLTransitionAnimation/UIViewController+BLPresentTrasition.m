//
//  UIViewController+BLPushTrasition.m
//  BLTransitionAnimatorLib
//
//  Created by 冰泪 on 2017/6/22.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import "UIViewController+BLPresentTrasition.h"
#import "BLPresentTransitionAnimator.h"


BLTransitionAnimatorStyle _bl_Type;

@implementation UIViewController (BLPresentTrasition)


#pragma mark UIViewControllerTransitioningDelegate   //模态跳转  的代理

//| ----------------------------------------------------------------------------
//  The system calls this method on the presented view controller's
//  transitioningDelegate to retrieve the animator object used for animating
//  the presentation of the incoming view controller.  Your implementation is
//  expected to return an object that conforms to the
//  UIViewControllerAnimatedTransitioning protocol, or nil if the default
//  presentation animation should be used.
//
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[BLPresentTransitionAnimator alloc] initWithTargetStyle:_bl_Type];
    
}
//| ----------------------------------------------------------------------------
//  The system calls this method on the presented view controller's
//  transitioningDelegate to retrieve the animator object used for animating
//  the dismissal of the presented view controller.  Your implementation is
//  expected to return an object that conforms to the
//  UIViewControllerAnimatedTransitioning protocol, or nil if the default
//  dismissal animation should be used.
//
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[BLPresentTransitionAnimator alloc] initWithTargetStyle:_bl_Type];
}



-(void)BL_presentViewController:(UIViewController *)vc AnimatorStyle:(BLTransitionAnimatorStyle)type animated:(BOOL)flag{
    vc.transitioningDelegate = self;
    _bl_Type = type;
    [self presentViewController:vc animated:flag completion:^{
        
    }];
}


@end
