//
//  BLListCollectionViewCell.h
//  BLImagePickerLib
//
//  Created by 冰泪 on 2017/7/18.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLListCollectionViewCellDelegate <NSObject>

#pragma mark    将选择的图片个数传递出去
- (void)BL_imageHelperGetImageCount:(NSInteger)count;

//#pragma mark    用于刷新collection的某一行
//- (void)BL_ListCollectionRefreshItem:(NSIndexPath *)indexPath;
@end




@interface BLListCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<BLListCollectionViewCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;

- (void)initCellWithDataSource:(NSMutableArray *)dataSource withIndexPath:(NSIndexPath *)indexPath isCancleAction:(BOOL)cancleAction;

@property (nonatomic,strong)NSIndexPath *IndexPath;

@property (nonatomic,assign)BOOL isPad;

@property (nonatomic,strong)UIViewController *superVC;
@end
