//
//  ViewController.m
//  BLImagePickerVCDemo
//
//  Created by 冰泪 on 2017/7/31.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import "ViewController.h"
#import "BLImagePickerViewController.h"
#import <SVProgressHUD.h>
#import "SelectedImageVC.h"


#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.view.backgroundColor = [UIColor redColor];
    
    [self.dataSource addObjectsFromArray:@[@"选择 单张图片 不剪裁",@"选择 单张图片+相机 不剪裁",@"选择 单张图片 剪裁",@"选择 单张图片+相机 剪裁",@"选择5张图片不带相机",@"选择5张图片带相机",@"选择5张图片带相机+预览原图 按钮",@"选择5张图片带相机+强制预览原图"]];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BLImagePickerViewController *imgVc = [[BLImagePickerViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:imgVc];

    switch (indexPath.row) {
        case 0:
        {
            //选择 单张图片 不剪裁
            imgVc.imageClipping = NO;
            imgVc.showCamera = NO;
            imgVc.maxNum = 1;
            imgVc.clippingItemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH);
           
        }
            break;
        case 1:
        {
            //选择 单张图片+相机 不剪裁
            imgVc.imageClipping = NO;
            imgVc.showCamera = YES;
            imgVc.maxNum = 1;
        }
            break;
        case 2:
        {
            //选择 单张图片 剪裁
            imgVc.imageClipping = YES;
            imgVc.showCamera = NO;
            imgVc.clippingItemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH);
            imgVc.maxNum = 1;
        }
            break;
        case 3:
        {
            //选择 单张图片+相机 剪裁
            imgVc.imageClipping = YES;
            imgVc.clippingItemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH);
            imgVc.showCamera = YES;
            imgVc.maxNum = 1;
        }
            break;
        case 4:
        {
            //选择 5张图片
            imgVc.maxNum = 5;
        }
            break;
        case 5:
        {
            //选择 5张图片+相机
            imgVc.imageClipping = YES;
            imgVc.showCamera = YES;
            imgVc.maxNum = 5;
            imgVc.maxScale = 2.0;
            imgVc.minScale = 0.5; 
        }
            break;
        case 6:
        {
            //选择 5张图片+相机+选择预览原图 按钮
            imgVc.imageClipping = YES;
            imgVc.showCamera = YES;
            imgVc.maxNum = 5;
            imgVc.maxScale = 2.0;
            imgVc.minScale = 0.5;
            imgVc.showOrignalBtn = YES;
        }
            break;
        case 7:
        {
            //选择 5张图片+相机+强制预览原图
            imgVc.imageClipping = YES;
            imgVc.showCamera = YES;
            imgVc.maxNum = 5;
            imgVc.maxScale = 2.0;
            imgVc.minScale = 0.5;
            imgVc.showOrignal = YES;
        }
            break;
            
        default:
            break;
    }
    __weak typeof(self) weakSelf = self;
    [imgVc initDataProgress:^(CGFloat progress) {
        
        [SVProgressHUD showProgress:progress];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        
    } finished:^(NSArray<UIImage *> *resultAry, NSArray<PHAsset *> *assetsArry, UIImage *editedImage) {
        
        [SVProgressHUD dismiss];
//        DDLOG(@"%@",assetsArry);
        SelectedImageVC *vc = [[SelectedImageVC alloc]init];
        if (resultAry) {
            vc.dataSource = [NSMutableArray arrayWithArray:resultAry];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        if (editedImage) {
            vc.editImage = editedImage;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        
    } cancle:^(NSString *cancleStr) {
//        DDLOG(@"取消了");
    }];
  [self presentViewController:nav animated:YES completion:nil];
}


-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
        
    }
    return _dataSource;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
