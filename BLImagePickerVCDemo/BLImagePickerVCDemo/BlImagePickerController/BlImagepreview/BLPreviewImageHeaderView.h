//
//  BLPreviewImageHeaderView.h
//  BLImagePickerLib
//
//  Created by 冰泪 on 2017/7/18.
//  Copyright © 2017年 冰泪. All rights reserved.
//
//

#import <UIKit/UIKit.h>

@protocol BLPreviewImageHeaderViewDelegate <NSObject>
@required
- (void)BL_previewImageHeaderViewTapDismissAction;
- (void)BL_previewImageHeaderViewTapChangeChooseStatusAction;
#pragma mark    用于刷新collection的某一行
- (void)BL_previewImageRefreshItem:(NSIndexPath *)indexPath;
@end


@interface BLPreviewImageHeaderView : UIView


@property (nonatomic, weak) IBOutlet UIButton *chooseButton;
@property (nonatomic, weak) id<BLPreviewImageHeaderViewDelegate>delegate;

- (void)initHeaderWihtDataSource:(NSMutableArray *)dataSource withIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic,strong)NSIndexPath *IndexPath;

@property (nonatomic, strong)UIViewController *superVC;

@end
