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

+ (BOOL)isRemmenber
{
    return [SSKeychain passwordForService:@"REMMENBER" account:kAccountName].boolValue;
}

+ (void)remmenber:(BOOL)isRemmenber
{
    [SSKeychain setPassword:[NSString stringWithFormat:@"%@",@(isRemmenber)] forService:@"REMMENBER" account:kAccountName];
}

+ (void)saveAccoutName:(NSString *)name pwd:(NSString *)pwd
{
    if (!name.length || !pwd.length)
    {
        return;
    }
    NSDictionary *dic = @{@"name":name,@"pwd":pwd};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    [SSKeychain setPasswordData:data forService:@"account" account:kAccountName];
}

+ (NSDictionary *)loadAccount
{
    NSData *data = [SSKeychain passwordDataForService:@"account" account:kAccountName];
    if (!data)
    {
        return nil;
    }
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
}

@end
