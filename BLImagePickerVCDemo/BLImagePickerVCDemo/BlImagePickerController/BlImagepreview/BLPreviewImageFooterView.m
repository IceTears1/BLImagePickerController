//
//  BLPreviewImageFooterView.m
//  BLImagePickerLib
//
//  Created by 冰泪 on 2017/7/18.
//  Copyright © 2017年 冰泪. All rights reserved.
//
//

#import "BLPreviewImageFooterView.h"

@interface BLPreviewImageFooterView()
@property (nonatomic, weak) IBOutlet UILabel *countLable;
@property (nonatomic, weak) IBOutlet UIView *animationView;

@end

@implementation BLPreviewImageFooterView


- (void)initFooterWithCount:(NSInteger)count {
    self.countLable.text = [@(count) stringValue];
    [self animationAction];
}


- (void)animationAction {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.repeatCount = 1;
    animation.removedOnCompletion = YES;
    animation.duration = 0.4;
    animation.fillMode = kCAFillModeForwards;
    animation.values = @[@(0.4), @(0.5), @(0.6), @(0.7), @(0.8), @(0.9),@(1), @(0.9), @(0.8), @(0.9),@(1)];
    [self.animationView.layer addAnimation:animation forKey:@"animation"];
    
}

#pragma mark    interFaceBuilder    method
- (IBAction)senderAction:(id)sender {
    [self.delegate BL_chooseImageSendAction];
}


- (void)dealloc {
    [self.animationView.layer removeAnimationForKey:@"animation"];
    [self.countLable.layer removeAllAnimations];
//    NSLog(@"[%@---------------dealloc]", self.class);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
