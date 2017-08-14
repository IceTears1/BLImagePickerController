//
//  BLPickerBaseViewController.m
//  BLImagePickerLib
//
//  Created by 冰泪 on 2017/7/18.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import "BLPickerBaseViewController.h"
//快捷判断对象是否为空
#define isNull_ALS(obj) (!obj||[obj isEqual:[NSNull null]]||[obj isEqual:@""])
//Navigation默认字体大小
#define kPANavigationTextFontSize 18.0
//导航栏返回按钮(默认)大小
#define kNaviBackBarFrameSize 44.0
#define UIDeviceOrientationIsUnknown(orientation)  ((orientation) == UIDeviceOrientationFaceUp || (orientation) == UIDeviceOrientationFaceDown || (orientation) == UIDeviceOrientationUnknown)

//在iphone上面运行
#define IS_IPHONE_ALS ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ? YES : NO)

//解决ios10 真机模式下不打印问题
#ifdef DEBUG

#define DDLOG(...) printf(" %s\n",[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);
#define DDLOG_CURRENT_METHOD NSLog(@"%@-%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd))

#else

#define DDLOG(...) ;
#define DDLOG_CURRENT_METHOD ;

#endif

@interface BLPickerBaseViewController ()
//自定义返回按钮
@property (nonatomic, strong) UIButton *backBtn;
@end

@implementation BLPickerBaseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        //        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IS_IPHONE_ALS) {
        self.isiPhone = YES;
        self.isiPad = NO;
    }else{
        self.isiPhone = NO;
        self.isiPad = YES;
    }
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.navigationController.viewControllers.count > 1) {
        //        [self showBackBtn];
    }
    [self onDeviceOrientationChange];
    //监听界面翻转
    //监听设备方向变化的通知
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    ////程序启动时获取当前驱动的方向的方法,获得当前的设备是横屏还是竖屏,从UIDevice的orientation属性，就可以得到方向。不过在获得方向之前要调用UIDevice的beginGeneratingDeviceOrientationNotifications方法更新设备信息。
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

//屏幕方向发生变化的话
- (void)onDeviceOrientationChange {
    
    if (IS_IPHONE_ALS) {
        //如果iphone 适配横竖屏 宽高使用这个
        if(UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)){
            if(!self.isPhonePortrait){
                [self screenChanges];
            }

            self.isPhonePortrait = YES;

        }else{
            if(self.isPhonePortrait){
                [self screenChanges];
            }

            self.isPhonePortrait = NO;
        }
    }else{
        if(UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)){
            if(!self.isPadPortrait){
                [self screenChanges];
            }
            
            self.isPadPortrait = YES;
        }else if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)){
            if(self.isPadPortrait){
                [self screenChanges];
            }
            
            self.isPadPortrait = NO;
        }else{
            //            DDLOG(@"未知，朝上， 朝下");
        }
    }
}

-(void)screenChanges
{
//                DDLOG(@"未知，朝上， 朝下");
}
/**
 初始化返回按钮
 
 @return 出参：UIButton
 */
-(UIButton *)backBtn{
    if (!_backBtn) {
        
        _backBtn = [[UIButton alloc] init];
        _backBtn.frame = CGRectMake(0, 0, kNaviBackBarFrameSize, kNaviBackBarFrameSize);
        [_backBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

//将自定义返回按钮添加到导航栏
-(void)addButtonToNavigationBar{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.backBtn];
}

//导航栏返回按钮点击处理方法
- (void)backEvent{
    NSLog(@"\r[控制器:%@ == 引用计数器:%ld]", NSStringFromClass([self class]), CFGetRetainCount((__bridge CFTypeRef)(self)));
    if(self.presentedViewController){
        [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 隐藏Navigationbar返回按钮
 */
-(void)hiddenBackBtn {
    self.backBtn.hidden = YES;
}

/**
 显示Navigationbar返回按钮
 */
- (void)showBackBtn {
    [self addButtonToNavigationBar];
    self.backBtn.hidden = NO;
}

-(void)dealloc
{
    //    NSLog(@"\r[销毁控制器:%@(%@)]", NSStringFromClass([self class]),self.title);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
