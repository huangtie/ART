//
//  AppDelegate.m
//  ARTCollect
//
//  Created by huangtie on 16/4/21.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "AppDelegate.h"
#import "ARTRequestUtil.h"
#import "ARTUserManager.h"
#import "ARTEasemobServer.h"
#import "ARTUMengUtil.h"
#import "ARTShareUtil.h"
#import "ARTGTPushUtil.h"

@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //初始化友盟统计
    [ARTUMengUtil initUMengSDK];
    
    //初始化分享
    [ARTShareUtil initShareSDK];
    
    //初始化个推
    [ARTGTPushUtil sharedInstance];
    
//    ARTLoginParam *param = [[ARTLoginParam alloc] init];
//    param.userName = @"223";
//    param.userPassword = @"1";
//    param.userType = @"1";
    
//    ARTRegisterParam *param = [[ARTRegisterParam alloc] init];
//    param.userName = @"66666";
//    param.userPassword = @"1";
//    param.userNick = @"喝喝";
//    [ARTNetUtil requestLogin:param completion:^(NSURLSessionDataTask *task, ARTUserData *data) {
//        [ARTUserManager sharedInstance].userinfo = data;
//        ARTSendTalkParam * talkParam = [[ARTSendTalkParam alloc] init];
//        talkParam.talkText = @"测试发表";
//        talkParam.talkAllLook = @"0";
//        talkParam.talkImages = [@[UIImageJPEGRepresentation([UIImage imageNamed:@"2323.jpg"], .5),UIImageJPEGRepresentation([UIImage imageNamed:@"11.png"], .5),UIImageJPEGRepresentation([UIImage imageNamed:@"22.png"], .5)] mutableCopy];
//        [ARTNetUtil requestSendTalk:talkParam completion:^(NSURLSessionDataTask *task) {
//            
//        } failure:^(ErrorItemd *error) {
//            
//        }];
//    } failure:^(ErrorItemd *error) {
//        
//    }];
    
//    [ARTNetUtil requestRegister:param completion:^(NSURLSessionDataTask *task, ARTUserData *data) {
//        
//    } failure:^(ErrorItemd *error) {
//        
//    }];
    
//    [ARTNetUtil requestUserinfo:@"17" completion:^(NSURLSessionDataTask *task, ARTUserData *data) {
//        
//    } failure:^(ErrorItemd *error) {
//        
//    }];
//    ARTCommentListParam *param = [[ARTCommentListParam alloc] init];
//    param.bookID = @"13";
//    [ARTNetUtil requestCommentList:param completion:^(NSURLSessionDataTask *task, NSArray<ARTCommentData *> *datas) {
//        
//    } failure:^(ErrorItemd *error) {
//        
//    }];
    
//    [ARTNetUtil requestPurchasesList:^(NSURLSessionDataTask *task, NSArray<ARTPurchasesData *> *datas) {
//        
//    } failure:^(ErrorItemd *error) {
//        
//    }];
    
//    [ARTNetUtil requestTalkDetail:@"7" completion:^(NSURLSessionDataTask *task, ARTTalkData *data) {
//        
//    } failure:^(ErrorItemd *error) {
//        
//    }];

    [[ARTEasemobServer services] loginEasemob:@"test" completion:^(EMError *error) {
        
    }];
    
    self.window.rootViewController = [[UIViewController alloc] init];

    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:nil];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:nil];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
#ifdef DEBUG
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
#endif
    
    //向环信注册deviceToken
    [[ARTEasemobServer services] bindDeviceToken:deviceToken];
    
    //向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    /// Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}


- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

@end
