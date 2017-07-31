//
//  BLPreviewImageHeaderView.m
//  BLImagePickerLib
//
//  Created by 冰泪 on 2017/7/18.
//  Copyright © 2017年 冰泪. All rights reserved.
//
//

#import "BLPreviewImageHeaderView.h"
#import "BLPickerConfig.h"
typedef NS_ENUM(NSInteger, BL_PreviewImageType) {
    BL_PreviewImageTypeSome,
    BL_PreviewImageTypeAll
};

@interface BLPreviewImageHeaderView()

@property (nonatomic, strong) PHAsset *tempAsset;
@property (nonatomic, assign) BL_PreviewImageType previewType;

@end

@implementation BLPreviewImageHeaderView



- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.4];
}



- (void)initHeaderWihtDataSource:(NSMutableArray *)dataSource withIndexPath:(NSIndexPath *)indexPath {
    self.IndexPath = indexPath;
    PHAsset *asset = dataSource[indexPath.row];
    if ([dataSource isEqual:[BLImageHelper shareImageHelper].phassetArr]) {
        self.previewType = BL_PreviewImageTypeAll;
    }else {
        self.previewType = BL_PreviewImageTypeSome;
    }
    self.tempAsset = (PHAsset *)asset;
    self.chooseButton.selected  = asset.chooseFlag;
    if (asset.chooseFlag ) {
        [self.chooseButton setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
    }else {
        [self.chooseButton setImage:[UIImage imageNamed:@"unChoose"] forState:UIControlStateNormal];
    }
    [self.chooseButton setNeedsLayout];
}





#pragma mark    interFaceBuilder    Method
- (IBAction)dismiss:(id)sender {
    [self.delegate BL_previewImageHeaderViewTapDismissAction];
}

- (IBAction)changeStatus:(id)sender {
    self.chooseButton.selected = !self.chooseButton.selected;
    NSInteger maxNumTemp= [BLImageHelper shareImageHelper].maxNum;
    NSInteger selectCount = [BLImageHelper shareImageHelper].phassetChoosedArr.count;
    
    if (self.chooseButton.selected) {
        if(selectCount>=maxNumTemp){
            
            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"已超过个数限制" preferredStyle:UIAlertControllerStyleAlert];
            [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSLog(@"点击确认");
                
            }]];

            [self.superVC presentViewController:alter animated:YES completion:nil];
    
            self.chooseButton.selected = NO;
            return;
            
        }else{
            [self.chooseButton setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
            self.tempAsset.chooseFlag = YES;
            [self animationAction];
            [[BLImageHelper shareImageHelper].phassetChoosedArr addObject:self.tempAsset];

        }

    }else {
        
        [self.chooseButton setImage:[UIImage imageNamed:@"unChoose"] forState:UIControlStateNormal];
        self.tempAsset.chooseFlag = NO;
        [[BLImageHelper shareImageHelper].phassetChoosedArr removeObject:self.tempAsset];
    }
    
    if (self.delegate) {
        [self.delegate BL_previewImageRefreshItem:self.IndexPath];
    }
    [self.delegate BL_previewImageHeaderViewTapChangeChooseStatusAction];
}
#pragma mark    按钮动画
- (void)animationAction {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.repeatCount = 1;
    animation.removedOnCompletion = YES;
    animation.duration = 0.4;
    animation.fillMode = kCAFillModeForwards;
    animation.values = @[@(1.05), @(1.1), @(1.15),@(1.1), @(1.05), @(1), @(1.05), @(1.1), @(1.15),@(1.1), @(1.05),@(1)];
    [self.chooseButton.imageView.layer addAnimation:animation forKey:@"animation"];
    
}


- (void)dealloc {
    NSMutableArray *tempArr = [[BLImageHelper shareImageHelper].phassetChoosedArr mutableCopy];
    for (PHAsset *asset in tempArr) {
        if (asset.chooseFlag == NO) {
            [[BLImageHelper shareImageHelper].phassetChoosedArr removeObject:asset];
        }
    }
    [self.chooseButton.layer removeAnimationForKey:@"animation"];
    [self.chooseButton.layer removeAllAnimations];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
