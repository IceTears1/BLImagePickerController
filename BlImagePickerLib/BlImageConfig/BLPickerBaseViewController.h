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


@end
