//
//  ARTEasemobServer.m
//  ART
//
//  Created by huangtie on 16/5/12.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTEasemobServer.h"
#import "NotificationMacros.h"

#define EASEMOB_APPKEY @"yishangyacang#yishangyacang"
#define EASEMOB_APNS @""
#define EASEMOB_ACCOUNT_PWD @"123456"

@interface ARTEasemobServer()<EMClientDelegate,EMChatManagerDelegate>

@end

@implementation ARTEasemobServer

+ (instancetype)services
{
    static ARTEasemobServer *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[ARTEasemobServer alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        EMOptions *options = [EMOptions optionsWithAppkey:EASEMOB_APPKEY];
        options.apnsCertName = EASEMOB_APPKEY;
        [[EMClient sharedClient] initializeSDKWithOptions:options];
        [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
        [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    }
    return self;
}

- (void)bindDeviceToken:(NSData *)aDeviceToken
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient] bindDeviceToken:aDeviceToken];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error)
            {
#ifdef DEBUG
                NSLog(@"环信注册DeviceToken失败:%@",error.errorDescription);
            }
            else
            {
                NSLog(@"环信注册DeviceToken成功");
#endif
            }

        });
    });
}

- (void)loginEasemob:(NSString *)userID
          completion:(void (^)(EMError *error))completion
{
    __weak __typeof(self) weak = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient] loginWithUsername:userID password:EASEMOB_ACCOUNT_PWD];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error)
            {
                if (completion)
                {
                    completion(error);
                }
            }
            else
            {
                if (error.code == EMErrorUserNotFound)
                {
                    [weak registerEasemob:userID completion:^(EMError *error) {
                        if (!error)
                        {
                            [weak loginEasemob:userID completion:^(EMError *error) {
                                if (completion)
                                {
                                    completion(error);
                                }
                            }];
                        }
                    }];
                }
            }
        });
    });
}

- (void)registerEasemob:(NSString *)userID
             completion:(void (^)(EMError *error))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient] registerWithUsername:userID password:EASEMOB_ACCOUNT_PWD];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion)
            {
                completion(error);
            }
        });
    });
}

- (void)logoutEasemob:(void (^)(EMError *error))completion
{
    if (![[EMClient sharedClient] isLoggedIn])
    {
        completion(nil);
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient] logout:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion)
            {
                completion(error);
            }
        });
    });
}

#pragma mark DELEGATE-CLIENT
- (void)didLoginFromOtherDevice
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ACCOUNT_DEVICEOTHOR object:nil];
}

#pragma mark DELEGATE-CHATMANAGER
//会话列表发生变化
- (void)didUpdateConversationList:(NSArray *)aConversationList
{
    
}

//收到消息
- (void)didReceiveMessages:(NSArray *)aMessages
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MESSAGE_RECEIVE object:nil];
}

@end
