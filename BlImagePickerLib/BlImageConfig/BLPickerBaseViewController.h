//
//  BLPickerBaseViewController.h
//  BLImagePickerLib
//
//  Created by 冰泪 on 2017/7/18.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <objc/runtime.h>
@interface BLPickerBaseViewController : UIViewController
//界面翻转  isPortrait是yes的时候是竖屏，false是横屏
-(void)screenChanges;
- (void)onDeviceOrientationChange;
//iphone的横竖屏

@property (nonatomic,assign) BOOL isPhonePortrait;

//ipad的横竖屏
@property (nonatomic,assign) BOOL isPadPortrait;

//isiPad
@property (nonatomic,assign) BOOL isiPad;

//isiPhone
@property (nonatomic,assign) BOOL isiPhone;



/** vc 回退处理*/
//- (void)backEvent;

/** 隐藏返回按钮*/
//- (void)hiddenBackBtn;

/** 显示返回按钮*/
//- (void)showBackBtn;

///**  vc push跳转封装方法  item是具体对象或者类名字符串都行*/
//-(void)pushViewController:(id)item;
//
///** vc 回退处理*/
//-(void)popViewController;
//
///** vc回退到指定的视图控制器处理*/
//-(void)popToViewController:(NSString *)className;
//
///**  vc push跳转封装方法(隐藏BottomBarView操作)*/
//-(void)pushViewController:(NSString*)className hiddenBottomBar:(BOOL)hidden;
//
///** storyboard vc跳转方法*/
//-(void)pushViewControllerWithStoryborad:(NSString*)bordName vcName:(NSString*)vcName;
//
///** vc present跳转封装方法(默认动画)*/
//-(void)presentViewController:(id)item;
//
///** vc present跳转封装方法(是否添加动画)*/
//-(void)presentViewController:(id)item animated:(BOOL)animated;
@end
