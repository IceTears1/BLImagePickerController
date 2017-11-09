//
//  ViewController.m
//  BLImagePickerVCDemo
//
//  Created by 冰泪 on 2017/7/31.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import "ViewController.h"

#import <SVProgressHUD.h>
#import "SelectedImageVC.h"


#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<UIActionSheetDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.view.backgroundColor = [UIColor redColor];
    
    [self.dataSource addObjectsFromArray:@[@"选择 单张图片 不剪裁",@"选择 单张图片+相机 不剪裁",@"选择 单张图片 剪裁",@"选择 单张图片+相机 剪裁",@"选择5张图片不带相机",@"选择5张图片带相机",@"选择5张图片带相机+预览原图 按钮",@"选择5张图片带相机+强制预览原图",@"直接打开相机"]];
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
            [imgVc disPlayCurVerson];
        }
            break;
        case 8:
        {
           
          UIActionSheet *actionsheet03 = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册", @"拍照", nil];
            [actionsheet03 showInView:self.view];
            return;
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
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex=%ld", buttonIndex);
    
    // 方法1
        if (0 == buttonIndex)
        {
            NSLog(@"点击了相册按钮");
            //相册方法 参考上边的 写法
        }
        else if (1 == buttonIndex)
        {
            NSLog(@"点击了拍照按钮");
            [self openCamera];
            
            
        }
        else if (2 == buttonIndex)
        {
            NSLog(@"点击了取消按钮");
        }

}
#pragma mark 打开相机
- (void)openCamera
{
    if([[BLImageHelper shareImageHelper] cameraPermissions]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.sourceType = sourceType;
        picker.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [self presentViewController:picker animated:YES completion:nil];
        
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请允许app获得您的相机权限" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
        //保存相册 可以直接拿img 图片处理
        UIImageWriteToSavedPhotosAlbum(img,self,@selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),nil);
        
        [picker dismissViewControllerAnimated:NO completion:^{
            
        }];
    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 保存图片后的回调
- (void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError: (NSError*)error contextInfo:(id)contextInfo {
    if(error){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"照片保存失败" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        //需要用到剪切图片了再走这个方法 不需要剪切 直接拿didFinishPickingMediaWithInfo 方法里的img做后续处理即可
        BLImageClipingViewController *vc = [[BLImageClipingViewController alloc]initWithImage:image cropFrame:CGSizeMake(500, 500) limitScaleRatio:2.0];
        vc.delegate = self;
        [self.navigationController BL_pushViewController:vc AnimatorStyle:BLTransitionAnimatorBottom animated:NO];
    }
}
- (void)imageCliping:(BLImageClipingViewController *)clipingViewController didFinished:(UIImage *)editedImage{
    
    NSLog( @"%@",NSStringFromCGSize(editedImage.size));
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
