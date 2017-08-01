//
//  SelectedImageVC.m
//  BLImagePickerVCDemo
//
//  Created by 冰泪 on 2017/7/31.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import "SelectedImageVC.h"

@interface SelectedImageVC ()

@end

@implementation SelectedImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.dataSource) {
        CGFloat w =  SCREEN_WIDTH/4-10;
        NSInteger i=0;
        for (UIImage *img1 in self.dataSource) {
            
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(i%4*w+10, i/4*w+64, w, w)];
            img.image = img1;
            img.contentMode = UIViewContentModeScaleAspectFit;
            [self.view addSubview:img];
            i++;
        }
    }
    if (self.editImage) {
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        img.image =self.editImage;
        [self.view addSubview:img];
        //            DDLOG(@"%@",NSStringFromCGSize(editedImage.size));
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
