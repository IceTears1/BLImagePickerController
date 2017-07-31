//
//  BLImageGroupViewController.h
//  BLImagePickerLib
//
//  Created by 冰泪 on 2017/7/19.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLPhotoGroupCell.h"
@protocol BLImageGroupViewControllerDelegate <NSObject>

#pragma mark    将选择的图片个数传递出去
- (void)BL_imageGroupClickCancel;
#pragma mark    选择了相册
- (void)BL_imageGroupSelectImageGrou;
@end

@interface BLImageGroupViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) id<BLImageGroupViewControllerDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
