//
//  ARTSendTalkParam.m
//  ART
//
//  Created by huangtie on 16/5/5.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTSendTalkParam.h"

@implementation ARTSendTalkParam

- (NSMutableDictionary *)buildRequestParam
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [ARTBaseParam filter:self.talkText key:@"talkText" param:param];
    [ARTBaseParam filter:self.talkAllLook key:@"talkAllLook" param:param];
    return param;
}

@end
