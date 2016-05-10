//
//  ARTCommentListParam.m
//  ART
//
//  Created by huangtie on 16/5/4.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTCommentListParam.h"

@implementation ARTCommentListParam

- (NSMutableDictionary *)buildRequestParam
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [ARTBaseParam filter:self.bookID key:@"bookID" param:param];
    [ARTBaseParam filter:self.offset key:@"offset" param:param];
    [ARTBaseParam filter:self.limit key:@"limit" param:param];
    return param;
}

@end
