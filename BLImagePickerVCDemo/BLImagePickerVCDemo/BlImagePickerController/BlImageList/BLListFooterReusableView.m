//
//  BLListFooterReusableView.m
//  BLImagePickerLib
//
//  Created by 冰泪 on 2017/7/26.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import "BLListFooterReusableView.h"

@implementation BLListFooterReusableView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createLabel];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createLabel];
    }
    return self;
}
-(void)createLabel{
    self.label =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-10)];
    self.label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
     self.label.textColor = [UIColor grayColor];
     self.label.textAlignment = NSTextAlignmentCenter;
    [self addSubview: self.label];
}
@end
