//
//  ViewController.h
//  BLImagePickerVCDemo
//
//  Created by 冰泪 on 2017/7/31.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataSource;

@end

