//
//  BLImageClipingViewController.h
//  BLImagePickerLib
//
//  Created by 冰泪 on 2017/7/20.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLPickerBaseViewController.h"
#import "BLPickerConfig.h"
@class BLImageClipingViewController;

@protocol BLImageClipingViewControllerDelegate <NSObject>

- (void)imageCliping:(BLImageClipingViewController *)clipingViewController didFinished:(UIImage *)editedImage;
@optional
//- (void)imageClipingDidCancel:(BLImageClipingViewController *)clipingViewController;

@end

@interface BLImageClipingViewController : BLPickerBaseViewController

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) id<BLImageClipingViewControllerDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;
@property (nonatomic, assign) CGSize cropSize;
- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGSize)cropFrame limitScaleRatio:(NSInteger)limitRatio;

@end
