//
//  ARTBookListParam.m
//  ART
//
//  Created by huangtie on 16/5/4.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBookListParam.h"

@implementation ARTBookListParam

- (NSMutableDictionary *)buildRequestParam
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [ARTBaseParam filter:self.bookGroup key:@"bookGroup" param:param];
    [ARTBaseParam filter:self.bookVIP key:@"bookVIP" param:param];
    [ARTBaseParam filter:self.bookOrder key:@"bookOrder" param:param];
    [ARTBaseParam filter:self.bookFree key:@"bookFree" param:param];
    [ARTBaseParam filter:self.bookAuthor key:@"bookAuthor" param:param];
    [ARTBaseParam filter:self.key key:@"key" param:param];
    [ARTBaseParam filter:self.offset key:@"offset" param:param];
    [ARTBaseParam filter:self.limit key:@"limit" param:param];
    return param;
}

@end
