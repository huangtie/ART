//
//  ARTCustomParam.m
//  ART
//
//  Created by huangtie on 16/5/5.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTCustomParam.h"

@implementation ARTCustomParam

- (NSMutableDictionary *)buildRequestParam
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [ARTBaseParam filter:self.talkID key:@"talkID" param:param];
    [ARTBaseParam filter:self.key key:@"key" param:param];
    [ARTBaseParam filter:self.offset key:@"offset" param:param];
    [ARTBaseParam filter:self.limit key:@"limit" param:param];
    return param;
}

@end
