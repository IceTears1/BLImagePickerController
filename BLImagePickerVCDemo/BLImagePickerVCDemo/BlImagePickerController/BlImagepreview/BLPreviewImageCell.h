//
//  BLPreviewImageCell.h
//  BLImagePickerLib
//
//  Created by 冰泪 on 2017/7/18.
//  Copyright © 2017年 冰泪. All rights reserved.
//
//

#import <UIKit/UIKit.h>

@protocol BLPreviewImageCollectionViewCellDelegate  <NSObject>

- (void)Bl_previewImageCollectionViewCellSingleRecognizer;//单击操作
@end


@interface BLPreviewImageCell : UICollectionViewCell
@property (nonatomic, weak) id<BLPreviewImageCollectionViewCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *fullImage;


- (void)initDataSource:(NSMutableArray *)dataSource  inedexPath:(NSIndexPath *)indexPath isOriginalImage:(BOOL)isOriginal;
@end
