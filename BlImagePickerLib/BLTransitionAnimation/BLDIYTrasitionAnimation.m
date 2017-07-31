//
//  BLDIYTrasitionAnimation.m
//  BLTransitionAnimatorLib
//
//  Created by 冰泪 on 2017/6/26.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import "BLDIYTrasitionAnimation.h"

#define DeviceMaxHeight ([UIScreen mainScreen].bounds.size.height)
#define DeviceMaxWidth ([UIScreen mainScreen].bounds.size.width)
@implementation BLDIYTrasitionAnimation

-(void)customAnimationType:(BLTransitionType)transitionType ToView:(UIView *)toView FromView:(UIView *)fromView transitionDuration:(CGFloat)transitionDuration finished:(BL_AnimationFinished)block{
    _myBlock = block;
    CGRect fromFrame = fromView.frame;
    CGRect toFrame = toView.frame;
    
    //自行对fromeView 和toView 进行动画
    
    // For a Presentation/push:
    //      fromView = The presenting view.
    //      toView   = The presented view.
    // For a Dismissal/pop:
    //      fromView = The presented view.
    //      toView   = The presenting view.
    
    switch (transitionType) {
        case BLTransitionTypePush:
        case BLTransitionTypePresent:
        {
            
            fromView.frame = fromFrame;
            toView.frame = CGRectMake(toView.frame.size.width, 0, toView.frame.size.width, toView.frame.size.height);
            
            [UIView animateWithDuration:transitionDuration animations:^{
                
                toView.frame = CGRectMake((DeviceMaxWidth -50)/2, (DeviceMaxHeight-50)/2, 50, 50) ;
                toView.layer.cornerRadius = 50/2;
                
            } completion:^(BOOL finished) {
                
                toView.frame = toFrame;
                toView.layer.cornerRadius = 0;
                
                _myBlock(@"finish");
                
            }];
            
        }
            break;
        case BLTransitionTypePop:
        case BLTransitionTypeDismiss:
        {
            
            fromView.frame = fromFrame;
            toView.frame = toFrame;
            
            [UIView animateWithDuration:transitionDuration animations:^{
                
                
                fromView.frame = CGRectMake(fromFrame.size.width, 0, fromFrame.size.width, fromFrame.size.height);
                
            } completion:^(BOOL finished) {
                
                _myBlock(@"finish");
            }];
            
        }
            break;
            
        default:
            break;
    }
}
@end
