//
//  PHAsset+AddFlag.m
//  BLImagePickerLib
//
//  Created by 冰泪 on 2017/7/18.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import "PHAsset+AddFlag.h"
#import <objc/runtime.h>

static const char *CHOOSEFLAG = "CHOOSEFLAG";

@implementation PHAsset (AddFlag)

- (void)setChooseFlag:(BOOL)chooseFlag {
    objc_setAssociatedObject(self, CHOOSEFLAG, @(chooseFlag), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)chooseFlag {
    return [objc_getAssociatedObject(self, CHOOSEFLAG) integerValue];
}

@end
