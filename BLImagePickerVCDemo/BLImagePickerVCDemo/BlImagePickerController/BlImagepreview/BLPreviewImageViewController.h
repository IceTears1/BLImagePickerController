//
//  BLPreviewImageViewController.h
//  BLImagePickerLib
//
//  Created by 冰泪 on 2017/7/18.
//  Copyright © 2017年 冰泪. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import "BLPickerBaseViewController.h"


typedef NS_ENUM(NSInteger, BL_PreviewImageType) {
    BL_PreviewSelect, //预览部分
    BL_PreviewAll   //预览全部照片
};
@protocol BLPreviewImageViewControllerDelegate <NSObject>
@required
- (void)BL_previewImageVCSendAction;
- (void)BL_previewImageVCRefreshType:(BL_PreviewImageType)previewType Item:(NSIndexPath *) indexPath;
@end

@interface BLPreviewImageViewController : BLPickerBaseViewController

@property (nonatomic, assign) BOOL isOriginal;
@property (nonatomic, assign) BL_PreviewImageType previewType;
@property (nonatomic, assign) NSInteger previewIndex;
@property (nonatomic, weak) id<BLPreviewImageViewControllerDelegate>delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerVIewHight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewTop;

@end
