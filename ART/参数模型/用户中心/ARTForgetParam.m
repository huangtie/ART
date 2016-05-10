//
//  ARTForgetParam.m
//  ART
//
//  Created by huangtie on 16/5/3.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTForgetParam.h"

@implementation ARTForgetParam

- (NSMutableDictionary *)buildRequestParam
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [ARTBaseParam filter:self.userName key:@"userName" param:param];
    [ARTBaseParam filter:[self.userPassword base64EncodedString] key:@"userPassword" param:param];
    [ARTBaseParam filter:self.userPhone key:@"userPhone" param:param];
    return param;
}

@end
