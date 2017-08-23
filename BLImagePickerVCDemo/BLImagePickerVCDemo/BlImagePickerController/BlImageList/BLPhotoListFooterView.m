//
//  BLPhotoListFooterView.m
//  BLImagePickerLib
//
//  Created by 冰泪 on 2017/7/18.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import "BLPhotoListFooterView.h"
#import "BLPickerConfig.h"
@interface BLPhotoListFooterView()
@property (nonatomic, weak) IBOutlet UILabel *countLable;
@property (nonatomic, weak) IBOutlet UIView *animationView;
@property (nonatomic, weak) IBOutlet UIButton *previewBtn;

@property (nonatomic, weak) IBOutlet UIView *originalBGView;

@property (nonatomic, weak) IBOutlet UIView *originalTipsView;
@property (nonatomic, assign) BOOL isOrigial;
@property (nonatomic, strong)UIView *centerView;

@end

@implementation BLPhotoListFooterView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.isOrigial = NO;
    self.originalTipsView.layer.borderColor = [UIColor colorWithRed: 17/255.0 green: 173/255.0 blue: 95/255.0 alpha:1.0].CGColor;
    self.originalTipsView.layer.cornerRadius = self.originalTipsView.bl_width/2;
    self.originalTipsView.layer.borderWidth = 1;
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event:)];
    [self.originalBGView addGestureRecognizer:tapGesture];
    [tapGesture setNumberOfTapsRequired:1];
    [self createSelectedView];
    if ([BLImageHelper shareImageHelper].showOrignalBtn) {
        self.originalBGView.hidden = NO;
    }else{
        self.originalBGView.hidden = YES;
        
    }
}
- (void)createSelectedView{
    self.centerView = [[UIView alloc]initWithFrame:CGRectMake(2, 2, self.originalTipsView.bl_width-4, self.originalTipsView.bl_height-4)];
    [self.originalTipsView addSubview: self.centerView];
    self.centerView.backgroundColor = [UIColor clearColor];
    self.centerView.layer.cornerRadius = self.centerView.bl_width/2;
}
    

- (void)event:(UITapGestureRecognizer *)gesture
{
    if (self.isOrigial) {
        self.isOrigial = NO;
        self.centerView.backgroundColor = [UIColor clearColor];
    }else{
        self.isOrigial = YES;
        self.centerView.backgroundColor = [UIColor colorWithRed: 17/255.0 green: 173/255.0 blue: 95/255.0 alpha:1.0];
    }
    if (self.delegate) {
        [self.delegate BL_photoListFooterViewShowOriginal:self.isOrigial];
    }
}
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
