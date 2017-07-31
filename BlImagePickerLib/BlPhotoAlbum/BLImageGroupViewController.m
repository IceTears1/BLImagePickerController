//
//  BLImageGroupViewController.m
//  BLImagePickerLib
//
//  Created by 冰泪 on 2017/7/19.
//  Copyright © 2017年 冰泪. All rights reserved.
//相册vc

#import "BLImageGroupViewController.h"
#import "BLImageHelper.h"
#import "BLImagePickerViewController.h"
#import "BLPickerConfig.h"

@interface BLImageGroupViewController ()

@end

@implementation BLImageGroupViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"相册";
    [[BLImageHelper shareImageHelper].groupArr removeAllObjects];
    [[BLImageHelper shareImageHelper] getAllImagesGroup];
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(clickCancel:)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:self action:nil];
}

- (void)clickCancel:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
    if (self.delegate) {
        [self.delegate BL_imageGroupClickCancel];
    }
}



#pragma mark    UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [BLImageHelper shareImageHelper].groupArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BLPhotoGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BLPhotoGroupCell" forIndexPath:indexPath];
    [cell initCellWithDataSource:[BLImageHelper shareImageHelper].groupArr indexPath:indexPath];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(IS_IPHONE){
        return 80;
    }else{
        return 125;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    __weak typeof(self) weakSelf = self;
    NSDictionary *data = [BLImageHelper shareImageHelper].groupArr[indexPath.row];
    PHFetchResult *result = data[@"result"];
    if (result.count > 0) {
        
        [[BLImageHelper shareImageHelper] getAllImageActionWithCollection:result];
        [[BLImageHelper shareImageHelper] getAllCollectionData:data];
        [[BLImageHelper shareImageHelper].phassetChoosedArr removeAllObjects];
        if(self.delegate){
            [self.delegate BL_imageGroupSelectImageGrou];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"该相册为空" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
