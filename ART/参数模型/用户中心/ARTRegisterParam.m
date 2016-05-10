//
//  ARTRegisterParam.m
//  ART
//
//  Created by huangtie on 16/4/29.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTRegisterParam.h"

@implementation ARTRegisterParam

- (NSMutableDictionary *)buildRequestParam
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [ARTBaseParam filter:self.userName key:@"userName" param:param];
    [ARTBaseParam filter:[self.userPassword base64EncodedString] key:@"userPassword" param:param];
    [ARTBaseParam filter:self.userNick key:@"userNick" param:param];
    return param;
}

@end
