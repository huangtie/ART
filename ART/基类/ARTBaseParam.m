//
//  ARTBaseParam.m
//  ART
//
//  Created by huangtie on 16/4/28.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBaseParam.h"
#import <MJExtension.h>

@implementation ARTBaseParam

MJExtensionCodingImplementation;

- (NSMutableDictionary *)buildRequestParam
{
    return nil;
}

+ (void)filter:(id)value key:(NSString *)key param:(NSMutableDictionary *)param
{
    if (value)
    {
        if ([value isKindOfClass:[NSString class]])
        {
            NSString *string = value;
            if (!string.length)
            {
                return;
            }
        }
        [param setValue:value forKey:key];
    }
}

@end
