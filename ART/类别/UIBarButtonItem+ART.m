//
//  UIBarButtonItem+ART.m
//  ART
//
//  Created by huangtie on 16/5/26.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "UIBarButtonItem+ART.h"

@implementation UIBarButtonItem (ART)

+ (UIBarButtonItem * _Nullable)barItemWithBack:(nullable id)target action:(nullable SEL)action
{
    return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"baritem_icon_back"] style:UIBarButtonItemStylePlain target:target action:action];
}

+ (UIBarButtonItem * _Nullable)barItemWithMore:(nullable id)target action:(nullable SEL)action
{
    return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"baritem_icon_ddd"] style:UIBarButtonItemStylePlain target:target action:action];
}


@end
