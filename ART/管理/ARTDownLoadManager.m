//
//  ARTDownLoadManager.m
//  ART
//
//  Created by huangtie on 16/5/16.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTDownLoadManager.h"

@implementation ARTDownLoadManager

+ (instancetype)sharedInstance
{
    static ARTDownLoadManager *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[ARTDownLoadManager alloc] init];
    });
    
    return instance;
}

@end
