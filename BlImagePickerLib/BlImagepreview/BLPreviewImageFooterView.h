//
//  BLPreviewImageFooterView.h
//  BLImagePickerLib
//
//  Created by 冰泪 on 2017/7/18.
//  Copyright © 2017年 冰泪. All rights reserved.
//
//

#import <UIKit/UIKit.h>

@protocol BLPreviewImageFooterViewDelegate <NSObject>
@required
- (void)BL_chooseImageSendAction;

@end

@interface BLPreviewImageFooterView : UIView
@property (nonatomic, weak) id<BLPreviewImageFooterViewDelegate>delegate;
- (void)initFooterWithCount:(NSInteger)count;

@end
