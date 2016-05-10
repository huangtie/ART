//
//  ARTSendTalkComParam.m
//  ART
//
//  Created by huangtie on 16/5/5.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTSendTalkComParam.h"

@implementation ARTSendTalkComParam

- (NSMutableDictionary *)buildRequestParam
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [ARTBaseParam filter:self.talkID key:@"talkID" param:param];
    [ARTBaseParam filter:self.replayID key:@"replayID" param:param];
    [ARTBaseParam filter:self.accept key:@"accept" param:param];
    [ARTBaseParam filter:self.text key:@"text" param:param];
    return param;
}

@end
