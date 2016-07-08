//
//  ARTTalkComData.m
//  ART
//
//  Created by huangtie on 16/5/6.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTTalkComData.h"

@implementation ARTTalkReplayData

@end

@implementation ARTTalkComData

+ (NSDictionary *)objectClassInArray
{
    return @{@"replays" : [ARTTalkReplayData class]};
}


@end