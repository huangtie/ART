//
//  SystemMacros.h
//  ART
//
//  Created by huangtie on 16/5/13.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#ifndef SystemMacros_h
#define SystemMacros_h

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define SCREEN_WIDTH     ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT    ([UIScreen mainScreen].bounds.size.height)

#define NAVIGATION_HEIGH 80

#define ARTPAGESIZE @"10"

#define IOS7_OR_LATER  (IOS_VERSION>= 7.0)

/// 一像素的线的宽度
#define ONE_POINT_LINE_WIDTH    (1.0 / [UIScreen mainScreen].scale)

#endif /* SystemMacros_h */
