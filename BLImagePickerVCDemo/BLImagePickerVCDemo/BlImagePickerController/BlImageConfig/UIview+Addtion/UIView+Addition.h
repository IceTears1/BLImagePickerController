//
//  UIView+Addition.h
//  UIView
//
//  Created by 冰泪 on 2017/7/18.
//  Copyright © 2017年 冰泪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Addition)

//宽
- (CGFloat)bl_width;

//高
- (CGFloat)bl_height;

//上
- (CGFloat)bl_Y;

//下
- (CGFloat)bl_MaxY;

//左
- (CGFloat)bl_X;

//右
- (CGFloat)bl_MaxX;

//设置宽
- (void)setWidth:(CGFloat)width;

//设置高
- (void)setHeight:(CGFloat)height;

//设置x
- (void)setXOffset:(CGFloat)x;

//设置y
- (void)setYOffset:(CGFloat)y;

//设置Origin
- (void)setOrigin:(CGPoint)origin;

//设置size
- (void)setSize:(CGSize)size;


@end
