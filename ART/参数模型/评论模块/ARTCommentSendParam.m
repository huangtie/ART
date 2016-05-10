//
//  ARTCommentSendParam.m
//  ART
//
//  Created by huangtie on 16/5/4.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTCommentSendParam.h"

@implementation ARTCommentSendParam

- (NSMutableDictionary *)buildRequestParam
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [ARTBaseParam filter:self.bookID key:@"bookID" param:param];
    [ARTBaseParam filter:self.commentText key:@"commentText" param:param];
    [ARTBaseParam filter:self.commentPoint key:@"commentPoint" param:param];
    return param;
}

@end
