//
//  ARTUMengUtil.m
//  ART
//
//  Created by huangtie on 16/5/13.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTUMengUtil.h"
#define UMENG_APPKEY @"57344ea367e58e9f270020e3"
@implementation ARTUMengUtil

+ (void)initUMengSDK
{
    UMConfigInstance.appKey = UMENG_APPKEY;
    [MobClick startWithConfigure:UMConfigInstance];
#ifdef DEBUG
    [MobClick setLogEnabled:YES];
#endif
}

@end
