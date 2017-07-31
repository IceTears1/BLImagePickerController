//
//  UINavigationController+BLPushTrasition.m
//  BLTransitionAnimatorLib
//
//  Created by 冰泪 on 2017/6/22.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import "UINavigationController+BLPushTrasition.h"
#import "BLPushTransitionAnimator.h"

BLTransitionAnimatorStyle bl_Type;

@implementation UINavigationController (BLPushTrasition)

#pragma mark -
#pragma mark UINavigationControllerDelegate   //push跳转   的代理

//| ----------------------------------------------------------------------------
//  The navigation controller tries to invoke this method on its delegate to
//  retrieve an animator object to be used for animating the transition to the
//  incoming view controller.  Your implementation is expected to return an
//  object that conforms to the UIViewControllerAnimatedTransitioning protocol,
//  or nil if the transition should use the navigation controller's default
//  push/pop animation.
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    
    return [[BLPushTransitionAnimator alloc]initWithTargetStyle:bl_Type];
}
-(void)BL_pushViewController:(UIViewController *)vc AnimatorStyle:(BLTransitionAnimatorStyle)type animated:(BOOL)flag{
    
    self.delegate = self;
    bl_Type = type;

    [self pushViewController:vc animated:flag];
}

@end
