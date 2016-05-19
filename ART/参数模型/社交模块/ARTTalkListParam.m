//
//  ARTTalkListParam.m
//  ART
//
//  Created by huangtie on 16/5/19.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTTalkListParam.h"

@implementation ARTTalkListParam

- (NSMutableDictionary *)buildRequestParam
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [ARTBaseParam filter:self.talkAllLook key:@"talkAllLook" param:param];
    [ARTBaseParam filter:self.userID key:@"userID" param:param];
    [ARTBaseParam filter:self.offset key:@"offset" param:param];
    [ARTBaseParam filter:self.limit key:@"limit" param:param];
    return param;
}

@end
