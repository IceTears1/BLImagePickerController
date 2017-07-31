//
//  SelectedImageVC.h
//  BLImagePickerVCDemo
//
//  Created by 冰泪 on 2017/7/31.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
@interface SelectedImageVC : UIViewController
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)UIImage *editImage;
@end
