//
//  ImageHelper.m
//  BLImagePickerLib
//
//  Created by 冰泪 on 2017/7/18.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import "BLImageHelper.h"

@implementation BLImageHelper


+ (BLImageHelper *)shareImageHelper {
    static BLImageHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (helper == nil) {
            helper = [[BLImageHelper alloc] init];
        }
    });
    return helper;
}

- (NSInteger)photoAblumPermissions
{
    /*
     表明用户尚未选择关于客户端是否可以访问硬件
     AVAuthorizationStatusNotDetermined = 0, 
     客户端未被授权访问硬件的媒体类型。用户不能改变客户机的状态,可能由于活跃的限制,如家长控制 AVAuthorizationStatusRestricted,
     明确拒绝用户访问硬件支持的媒体类型的客户 AVAuthorizationStatusDenied,
     客户端授权访问硬件支持的媒体类型 AVAuthorizationStatusAuthorized
     */
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        return 0;
    }else if(status == PHAuthorizationStatusNotDetermined){
        return -1;
    }else{
        return 1;
    }
   
}

- (NSInteger)cameraPermissions
{
    //相机的使用权限
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (status == AVAuthorizationStatusRestricted ||
        status == AVAuthorizationStatusDenied) {
        return 0;
    }else if(status == AVAuthorizationStatusNotDetermined){
        return -1;
    }else{
        return 1;
    }
}

#pragma mark    Method
#pragma mark    实际获取相册所有照片的操作
- (void)getAllImageActionWithCollection:(PHFetchResult *)result {
    if(self.phassetArr.count>0){
        [self.phassetArr removeAllObjects];
    }
    if (result) {
        for (id obj in result) {//获取标识符
            [self.phassetArr addObject:obj];
            
        }
    }else {
        // 获取所有资源的集合，并按资源的创建时间排序
        ///获取资源时的参数
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        //表示一系列的资源的集合,也可以是相册的集合
        PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
        for (id obj in assetsFetchResults) {//获取标识符
            [self.phassetArr addObject:obj];
        }
        //result 为nil 说明现在进入的是相机胶卷
        self.isAllphoto = YES;
    }
}
-(PHAsset *)getFirstObjectAllCollection{
    // 获取所有资源的集合，并按资源的创建时间排序
    ///获取资源时的参数
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    //表示一系列的资源的集合,也可以是相册的集合
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    return assetsFetchResults.firstObject;
}

-(void)getAllCollectionData:(NSDictionary *)dict{
    //result 为nil 说明现在进入的是相机胶卷
    NSString *title = dict[@"title"];
    
    if ([title isEqualToString:@"Camera Roll"] || [title isEqualToString:@"相机胶卷"]){
        //把相机胶卷 相册放在第一行
        self.isAllphoto = YES;
    }else{
        self.isAllphoto = NO;
    }
    self.currentGroupTitle = title;
}
#pragma mark    Case
- (NSMutableArray *)phassetArr {
    if (!_phassetArr) {
        _phassetArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _phassetArr;
}


- (NSMutableArray *)phassetChoosedArr  {
    if (!_phassetChoosedArr) {
        _phassetChoosedArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _phassetChoosedArr;
}

- (void)getAllImagesGroup {
    
    if (self.groupArr.count >0) {
        [self.groupArr removeAllObjects];
    }
    PHAssetCollectionSubtype smartAlbumSubtype = PHAssetCollectionSubtypeSmartAlbumUserLibrary | PHAssetCollectionSubtypeSmartAlbumRecentlyAdded | PHAssetCollectionSubtypeSmartAlbumScreenshots |PHAssetCollectionSubtypeSmartAlbumFavorites | PHAssetCollectionSubtypeAlbumRegular | PHAssetCollectionSubtypeSmartAlbumAllHidden;
    
    //获取系统相册
    PHFetchResult *kindAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:smartAlbumSubtype options:nil];
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    for (PHAssetCollection *colllection  in kindAlbum) {
        
        NSString *kindName = colllection.localizedTitle;
        
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:colllection options:options];
        
        if (result.count < 1) continue;
        
        NSString *imageCount = [@(result.count) stringValue];
        NSDictionary *resultDic = @{@"count" : imageCount, @"title" : kindName, @"result" : result};
        if ([kindName isEqualToString:@"Camera Roll"] || [kindName isEqualToString:@"相机胶卷"]) {
            //把相机胶卷 相册放在第一行
            [self.groupArr insertObject:resultDic atIndex:0];
        } else {
            [self.groupArr addObject:resultDic];
        }
    }
    
    //获取自定义相册
    PHFetchResult *kindAlbum1 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:smartAlbumSubtype options:nil];
    for (PHAssetCollection *colllection  in kindAlbum1) {
        
        NSString *kindName = colllection.localizedTitle;
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:colllection options:options];
        
        if (result.count < 1) continue;
        
        NSString *imageCount = [@(result.count) stringValue];
        NSDictionary *resultDic = @{@"count" : imageCount, @"title" : kindName, @"result" : result};
        if ([kindName isEqualToString:@"Camera Roll"] || [kindName isEqualToString:@"相机胶卷"]) {
            //把相机胶卷 相册放在第一行
            [self.groupArr insertObject:resultDic atIndex:0];
        } else {
            [self.groupArr addObject:resultDic];
        }
    }
    
}


#pragma mark    Case
- (NSMutableArray *)groupArr {
    if (!_groupArr) {
        _groupArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _groupArr;
}
-(void)removeAllData{
    self.maxNum = 0;
    [self.phassetChoosedArr removeAllObjects];
    [self.phassetArr removeAllObjects];
    [self.groupArr removeAllObjects];
    self.lastSelectIndex = nil;
    self.showCamera = NO;
    self.currentGroupTitle = @"";
    self.minScale = 1.0;
    self.maxScale = 2.0;
    self.showOrignal = NO;
    self.showOrignalBtn = NO;
}

@end
