//
//  ImageHelper.h
//  BLImagePickerLib
//
//  Created by 冰泪 on 2017/7/18.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLPickerConfig.h"

@interface BLImageHelper : NSObject

+ (BLImageHelper *)shareImageHelper;

#pragma mark    所有相片集合, 里面是一个个的PHAsset
@property (nonatomic, strong) NSMutableArray *phassetArr;
#pragma mark    所有被选择的PHAsset
@property (nonatomic, strong) NSMutableArray *phassetChoosedArr;

#pragma mark    实际获取相册所有照片的操作
- (void)getAllImageActionWithCollection:(PHFetchResult *)result;

#pragma mark    实际获取相册属性
- (void)getAllCollectionData:(NSDictionary *)dict;

#pragma mark    获取相册里边最新的一张照片
- (PHAsset *)getFirstObjectAllCollection;

#pragma mark    所有相片集合, 里面是一个个的PHAsset
@property (nonatomic, strong) NSMutableArray *groupArr;
- (void)getAllImagesGroup;

#pragma mark    移除数据
-(void)removeAllData;

#pragma mark  相机相册使用权限
- (NSInteger)photoAblumPermissions;

- (NSInteger)cameraPermissions;

@property (nonatomic,assign)NSInteger maxNum;
//存储上一次选中的item 用于只选择一张图片时候 刷新使用
@property (nonatomic,strong)NSIndexPath *lastSelectIndex;
@property (nonatomic,assign)BOOL showCamera;
@property (nonatomic,assign)BOOL isAllphoto;//是相机胶卷相册

@property (nonatomic,copy)NSString *currentGroupTitle;//当前相册名字

//预览图片放大缩小的倍数
@property (nonatomic,assign)CGFloat maxScale;
@property (nonatomic,assign)CGFloat minScale;

@property (nonatomic,assign)BOOL showOrignal;//强制使用原图
@property (nonatomic,assign)BOOL showOrignalBtn;//时候显示查看原图的按钮
@end
