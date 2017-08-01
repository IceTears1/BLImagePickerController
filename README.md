# BLImagePickerController
使用方式
pod 'BLImagePickerLib', '~> 1.0.1’

相片选择器 
1、支持iphone/ipad 

2、兼容横竖屏切换

3、支持系统版本 ios8.0 以上

4、功能上可能还比较简单 如果有什么特殊需求 可以提给我 我会尽快完善

[我的博客](https://my.oschina.net/iceTear/blog)  
[BLImagePickerLib讲解](https://my.oschina.net/iceTear/blog/1498504)  


效果图
 ![img](https://../BLImagePickerController/blob/master/images/list.png)
 ![img](https://github.com/IceTears1/BLImagePickerController/blob/master/images/group.png)
 ![img](https://github.com/IceTears1/BLImagePickerController/blob/master/images/109F3CE5F9F780A8AB6A37BBE4E1805F.png)
 ![img](https://github.com/IceTears1/BLImagePickerController/blob/master/images/2B5A8B83A58398B892CFB4A2FC14C9A8.png)
1>使用方法

BLImagePickerViewController *imgVc = [[BLImagePickerViewController alloc]init];

UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:imgVc];

BLImagePickerViewController *imgVc = [[BLImagePickerViewController alloc]init];

UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:imgVc];

[imgVc initDataProgress:^(CGFloat progress) {


} finished:^(NSArray<UIImage *> *resultAry, NSArray<PHAsset *> *assetsArry, UIImage *editedImage) {

} cancle:^(NSString *cancleStr) {

}];

[self presentViewController:nav animated:YES completion:nil];

2>配置参数
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
@默认白色
*/


@property (nonatomic,strong)NSString *navTitle;

/*
@ 显示相机
*/


@property (nonatomic,assign)BOOL showCamera;


/*
@无法获取照相机权限时候的提示语
@默认
无法获取相机功能请在iphone/ipad的“设置-隐私-相机”选项中允许 “app名字” 访问您的相机"
*/

@property (nonatomic,strong)NSString *cameraMassage;

/*
@ 无法获取相册权限时候的提示语
@默认
无法获取相册功能请在“iphone/ipad“的设置-隐私-相册”选项中允许 ”app名字“ 访问您的相册"
*/

@property (nonatomic,strong)NSString *photoAlbumMassage;
