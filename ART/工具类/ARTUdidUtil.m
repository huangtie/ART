//
//  ARTUdidUtil.m
//  ART
//
//  Created by huangtie on 16/5/3.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTUdidUtil.h"

static NSString * const kAccountName = @"com.ART.yishangyacang";

@implementation ARTUdidUtil

+ (NSString *)LoadUDID
{
    NSString *UDID = [SSKeychain passwordForService:@"UDID" account:kAccountName];
    
    if(!UDID || !UDID.length)
    {
        [[self class] SaveUDID];
    }
    return [SSKeychain passwordForService:@"UDID" account:kAccountName];
}

+ (void)SaveUDID
{
    CFUUIDRef uuid_ref=CFUUIDCreate(nil);
    CFStringRef uuid_string_ref=CFUUIDCreateString(nil, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid=[NSString stringWithString:CFBridgingRelease(uuid_string_ref)];
    
    [SSKeychain setPassword:uuid forService:@"UDID" account:kAccountName];
}

@end
