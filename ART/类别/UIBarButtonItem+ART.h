//
//  UIBarButtonItem+ART.h
//  ART
//
//  Created by huangtie on 16/5/26.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (ART)

/*** 返回按钮 ***/
+ (UIBarButtonItem * _Nullable)barItemWithBack:(nullable id)target action:(nullable SEL)action;

/*** ...更多 ***/
+ (UIBarButtonItem * _Nullable)barItemWithMore:(nullable id)target action:(nullable SEL)action;

@end
