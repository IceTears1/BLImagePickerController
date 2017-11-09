//
//  BLImagePickerViewController.h
//  BLImagePickerLib
//
//  Created by 冰泪 on 2017/7/18.
//  Copyright © 2017年 冰泪. All rights reserved.

//BLImagePickerLib讲解:https://my.oschina.net/iceTear/blog/1498504
//我的博客:https://my.oschina.net/iceTear/blog
//git：https://github.com/IceTears1/BLImagePickerController
//

#import <UIKit/UIKit.h>
#import "BLPickerBaseViewController.h"
#import "BLPickerConfig.h"

NS_ASSUME_NONNULL_BEGIN
@interface BLImagePickerViewController : BLPickerBaseViewController

-(void)initDataProgress:(BLSelectImageLoading)progressBlock finished:(BLSelectImageFinishedBlock)finishedBlock cancle:(BLCancle)cancleBlock;

@property (nonatomic,copy)BLSelectImageFinishedBlock finishedBlock;//照片选择完成
@property (nonatomic,copy)BLSelectImageLoading progressBlock;//照片选择完成
@property (nonatomic,copy)BLCancle cancleBlock;//取消

/*
 @itemSize  拿到的图片的大小
 @默认 原图（比较大慎用）
 */
@property (nonatomic,assign)CGSize itemSize;
/*
 @maxNum  获取图片的数量
 @默认 10
 */
@property (nonatomic,assign)NSInteger maxNum;
/*
 @imageClipping  图片剪裁
 @默认 NO
 @注意 目前仅限获取相册 单张图片或者相机获取的图片时候使用
 */
@property (nonatomic,assign)BOOL imageClipping;

/*
 @imageClippingScale  图片剪裁页面图片可放大的倍数
 @默认 2.0
 只有图片剪裁页面生效
 */
@property (nonatomic,assign)CGFloat imageClippingScale;

/*
 @clippingItemSize  图片剪裁大小
 @注意
 1>使用相册获取单张图片时候使用
 2>使用拍照功能且单选图片时候使用
 
 如果设置太小可能导致 显示的剪切框非常小 可以在自己需求的大小基础上等比例放大
 例如 需求100*100   可以设置300*300  这样显示出来不至于太丑
 
 剪裁方框最大为屏幕的宽高等比缩放
 */
@property (nonatomic,assign)CGSize clippingItemSize;

/*
 @navColor  导航栏的背景颜色
 @默认红色
 */
@property (nonatomic,strong)UIColor *navColor;
/*
 @navColor  导航栏的字体颜色
 @默认白色
 */
@property (nonatomic,strong)UIColor *navTitleColor;

/*
 @navColor  导航栏的title
 @默认相册的名字
 */
@property (nonatomic,copy)NSString *navTitle;

/*
 @ 显示相机
 */
@property (nonatomic,assign)BOOL showCamera;

/*
 @ 预览时候 强制显示原图
 @默认 no
 */
@property (nonatomic,assign)BOOL showOrignal;

/*
 @ 是否显示查看原图的按钮
 @默认 no
注意 showOrignal = yes 时候 showOrignalBtn将不起作用
 */
@property (nonatomic,assign)BOOL showOrignalBtn;

/*
 @ 图片预览放大倍数
 默认2.0
 */
@property (nonatomic,assign)CGFloat maxScale;

/*
 @ 图片预览缩小倍数
 默认1.0
 */
@property (nonatomic,assign)CGFloat minScale;

/*
 @无法获取照相机权限时候的提示语
 @默认
 无法获取相机功能请在iphone/ipad的“设置-隐私-相机”选项中允许 “app名字” 访问您的相机"
 */
@property (nonatomic,copy)NSString *cameraMassage;
/*
 @ 无法获取相册权限时候的提示语
 @默认
 无法获取相册功能请在“iphone/ipad“的设置-隐私-相册”选项中允许 ”app名字“ 访问您的相册"
 */
@property (nonatomic,copy)NSString *photoAlbumMassage;



- (void)disPlayCurVerson;
@end
NS_ASSUME_NONNULL_END
