//
//  ARTHttpServers.m
//  ART
//
//  Created by huangtie on 16/4/28.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTHttpServers.h"
#import "ARTUdidUtil.h"
#import "ARTUserManager.h"
#import <YYKit.h>

@implementation ARTHttpServers

+ (instancetype)services
{
    return [[[self class] alloc] init];
}

+ (NSString *)URLParam:(NSDictionary *)dic
{
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
     {
         if ([obj isKindOfClass:[NSString class]])
         {
             NSString *strKey = key;
             NSString *strObj = obj;
             
             [mutableString appendString:strKey];
             [mutableString appendString:@"="];
             [mutableString appendString:strObj];
             [mutableString appendString:@"&"];
         }
     }];
    
    if (mutableString.length > 0)
    {
        if ([[mutableString substringFromIndex:(mutableString.length - 1)] isEqualToString:@"&"])
        {
            [mutableString deleteCharactersInRange:NSMakeRange(mutableString.length - 1, 1)];
        }
    }
    
    return mutableString;
}

+ (NSString *)replaceUnicode:(NSString *)string
{
    NSString *tempStr1  = [string stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2  = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3  = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData   *tempData  = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

+ (NSDictionary *)superParam:(NSDictionary *)param
{
    NSMutableDictionary *params = [param mutableCopy];
    [params setValue:@"iOS" forKey:@"from"];
    [params setValue:[[ARTUdidUtil LoadUDID] md5String] forKey:@"udid"];
    [params setValue:[UIDevice currentDevice].machineModelName forKey:@"model"];
    [params setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"version"];
    if ([UIDevice currentDevice].ipAddressWIFI.length)
    {
        [params setValue:[UIDevice currentDevice].ipAddressWIFI forKey:@"ip"];
    }
    if ([[ARTUserManager sharedInstance] isLogin])
    {
        [params setValue:[ARTUserManager sharedInstance].userinfo.c forKey:@"c"];
    }
    return params;
}

+ (NSURLSessionDataTask *)requestWithGET:(NSString *)URL
                                   param:(NSDictionary *)param
                              completion:(void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable result, NSError * _Nullable error))completion
{
    param = [[self class] superParam:param];
    NSLog(@"\nRequest URL  : %@?%@",URL,[ARTHttpServers URLParam:param]);
    return [[AFHTTPSessionManager manager] GET:URL parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"\nRequest success : \n%@\n",[ARTHttpServers replaceUnicode:[responseObject description]]);
        if (completion)
        {
            completion(task , responseObject , nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"\nRequest failure : \n%@\n",error);
        if (completion)
        {
            completion(task , nil , error);
        }
    }];
}

+ (NSURLSessionDataTask *)requestWithPOST:(NSString *)URL
                                    param:(NSDictionary *)param
                               completion:(void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable result, NSError * _Nullable error))completion
{
    param = [[self class] superParam:param];
    NSLog(@"\nRequest URL  : %@?%@",URL,[ARTHttpServers URLParam:param]);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    manager.requestSerializer.timeoutInterval = 10;
    return [manager POST:URL parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"\nRequest success : \n%@\n",[ARTHttpServers replaceUnicode:[responseObject description]]);
        if (completion)
        {
            completion(task , responseObject , nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"\nRequest failure : \n%@\n",error);
        if (completion)
        {
            completion(task , nil , error);
        }
    }];
}

+ (NSURLSessionDataTask *)requestWithUpload:(NSString *)URL
                                      param:(NSDictionary *)param
                                      datas:(NSArray <NSData *>* )datas
                                 completion:(void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable result, NSError * _Nullable error))completion
{
    param = [[self class] superParam:param];
    NSLog(@"\nRequest URL  : %@?%@",URL,[ARTHttpServers URLParam:param]);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    return [manager POST:URL parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSData *data in datas)
        {
            [formData appendPartWithFileData:data name:@"file" fileName:@".png" mimeType:@"image/jpeg"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"\nRequest success : \n%@\n",[ARTHttpServers replaceUnicode:[responseObject description]]);
        if (completion)
        {
            completion(task , responseObject , nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"\nRequest failure : \n%@\n",error);
        if (completion)
        {
            completion(task , nil , error);
        }
    }];
}

















@end
