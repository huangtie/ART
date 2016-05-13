//
//  ARTEasemobServer.h
//  ART
//
//  Created by huangtie on 16/5/12.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HyphenateFullSDK/EMSDKFull.h>

@interface ARTEasemobServer : NSObject

+ (instancetype)services;

- (void)bindDeviceToken:(NSData *)aDeviceToken;

/*** 登录环信 ***/
- (void)loginEasemob:(NSString *)userID
          completion:(void (^)(EMError *error))completion;

/*** 登出环信 ***/
- (void)logoutEasemob:(void (^)(EMError *error))completion;

@end
