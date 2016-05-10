//
//  ARTUpsetParam.m
//  ART
//
//  Created by huangtie on 16/5/3.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTUpsetParam.h"

@implementation ARTUpsetParam

- (NSMutableDictionary *)buildRequestParam
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [ARTBaseParam filter:self.userNick key:@"userNick" param:param];
    [ARTBaseParam filter:self.userPhone key:@"userPhone" param:param];
    [ARTBaseParam filter:self.userEmail key:@"userEmail" param:param];
    [ARTBaseParam filter:self.userSex key:@"userSex" param:param];
    [ARTBaseParam filter:self.userSheng key:@"userSheng" param:param];
    [ARTBaseParam filter:self.userShi key:@"userShi" param:param];
    [ARTBaseParam filter:self.userQu key:@"userQu" param:param];
    [ARTBaseParam filter:self.userSign key:@"userSign" param:param];
    return param;
}

@end
