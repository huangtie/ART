//
//  ARTUMengServer.m
//  ART
//
//  Created by huangtie on 16/5/12.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTUMengServer.h"

#define UMENG_APPKEY @"57344ea367e58e9f270020e3"
@interface ARTUMengServer()

@end

@implementation ARTUMengServer

+ (void)initUMengSDK
{
    [MobClick startWithAppkey:UMENG_APPKEY];
#ifdef DEBUG
    [MobClick setLogEnabled:YES];
#endif
}



@end
