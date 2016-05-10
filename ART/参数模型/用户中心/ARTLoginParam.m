//
//  ARTLoginParam.m
//  ART
//
//  Created by huangtie on 16/4/28.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTLoginParam.h"

@implementation ARTLoginParam

- (NSMutableDictionary *)buildRequestParam
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [ARTBaseParam filter:self.userType key:@"userType" param:param];
    [ARTBaseParam filter:self.userName key:@"userName" param:param];
    [ARTBaseParam filter:[self.userPassword base64EncodedString] key:@"userPassword" param:param];
    [ARTBaseParam filter:self.userPart key:@"userPart" param:param];
    [ARTBaseParam filter:self.userNick key:@"userNick" param:param];
    return param;
}

@end
