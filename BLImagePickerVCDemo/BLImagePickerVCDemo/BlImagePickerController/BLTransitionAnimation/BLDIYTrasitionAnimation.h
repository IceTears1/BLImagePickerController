//
//  BLDIYTrasitionAnimation.h
//  BLTransitionAnimatorLib
//
//  Created by 冰泪 on 2017/6/26.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLTrasitionAnimatorConfig.h"
@interface BLDIYTrasitionAnimation : NSObject

@property (nonatomic,copy)BL_AnimationFinished myBlock;
/*
 
 @transitionType 跳转类型 push present  pop  dismiss 四中
 @toView   //目标页面的view
 @fromView  //源页面的view
 @transitionDuration  //执行动画时间
 @block   //执行完动画回调
 */
-(void)customAnimationType:(BLTransitionType)transitionType ToView:(UIView *)toView FromView:(UIView *)fromView transitionDuration:(CGFloat)transitionDuration finished:(BL_AnimationFinished)block;
@end
