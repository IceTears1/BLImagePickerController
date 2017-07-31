//
//  BLPhotoListFooterView.m
//  BLImagePickerLib
//
//  Created by 冰泪 on 2017/7/18.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import "BLPhotoListFooterView.h"

@interface BLPhotoListFooterView()
@property (nonatomic, weak) IBOutlet UILabel *countLable;
@property (nonatomic, weak) IBOutlet UIView *animationView;
@property (nonatomic, weak) IBOutlet UIButton *previewBtn;
@end

@implementation BLPhotoListFooterView


- (void)initFooterWithCount:(NSInteger)count {
    self.countLable.text = [@(count) stringValue];
    [self animationAction];
}

- (IBAction)previewAction:(id)sender {
    [self.delegate BL_photoListFooterViewTapWithType:BLTapTypePreview];
}

- (IBAction)senderAction:(id)sender {
    [self.delegate BL_photoListFooterViewTapWithType:BLTapTypeSend];
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
