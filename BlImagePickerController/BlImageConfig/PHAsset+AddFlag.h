//
//  PHAsset+AddFlag.h
//  BLImagePickerLib
//
//  Created by 冰泪 on 2017/7/18.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import <Photos/Photos.h>

#pragma mark    为PHAsset绑定一个属性, 当被选择时.chooseFlag设为YES;
@interface PHAsset (AddFlag)

@property (nonatomic, assign) BOOL chooseFlag;


@end
