//
//  ARTTalkData.m
//  ART
//
//  Created by huangtie on 16/5/5.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTTalkData.h"

@implementation ARTTalkData

+ (NSDictionary *)objectClassInArray
{
    return @{@"comList" : [ARTTalkComData class],@"zanList" : [ARTUserInfo class]};
}

@end
