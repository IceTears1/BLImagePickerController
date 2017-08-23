//
//  BLPhotoListFooterView.h
//  BLImagePickerLib
//
//  Created by 冰泪 on 2017/7/18.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BLTapType){
    BLTapTypePreview,
    BLTapTypeSend
};

@protocol BLPhotoListFooterViewDelegate <NSObject>
@required
- (void)BL_photoListFooterViewTapWithType:(BLTapType)type;

- (void)BL_photoListFooterViewShowOriginal:(BOOL)isOriginal;
@end


@interface BLPhotoListFooterView : UIView



@property (nonatomic, weak) id<BLPhotoListFooterViewDelegate>delegate;
- (void)initFooterWithCount:(NSInteger)count;



@end
