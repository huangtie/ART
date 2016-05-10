//
//  ARTHttpServers.h
//  ART
//
//  Created by huangtie on 16/4/28.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface ARTHttpServers : NSObject

+ (instancetype)services;

+ (NSURLSessionDataTask *)requestWithGET:(NSString *)URL
                                    param:(NSDictionary *)param
                               completion:(void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable result, NSError * _Nullable error))completion;

+ (NSURLSessionDataTask *)requestWithPOST:(NSString *)URL
                                    param:(NSDictionary *)param
                               completion:(void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable result, NSError * _Nullable error))completion;

+ (NSURLSessionDataTask *)requestWithUpload:(NSString *)URL
                                      param:(NSDictionary *)param
                                      datas:(NSArray <NSData *>* )datas
                                 completion:(void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable result, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END