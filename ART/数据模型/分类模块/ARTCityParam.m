//
//  ARTCityParam.m
//  ART
//
//  Created by huangtie on 16/6/20.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTCityParam.h"

@implementation ARTCityParam

- (NSMutableDictionary *)buildRequestParam
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [ARTBaseParam filter:self.type key:@"type" param:param];
    [ARTBaseParam filter:self.code key:@"code" param:param];
    return param;
}

@end
