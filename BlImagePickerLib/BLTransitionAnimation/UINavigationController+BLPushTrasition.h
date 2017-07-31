//
//  UINavigationController+BLPushTrasition.h
//  BLTransitionAnimatorLib
//
//  Created by 冰泪 on 2017/6/22.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLTrasitionAnimatorConfig.h"


@interface UINavigationController (BLPushTrasition)<UINavigationControllerDelegate>


- (void)BL_pushViewController:(UIViewController *)vc AnimatorStyle:(BLTransitionAnimatorStyle)type animated:(BOOL)flag;

@end
