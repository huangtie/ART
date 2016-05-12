//
//  AppDelegate.m
//  ARTCollect
//
//  Created by huangtie on 16/4/21.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "AppDelegate.h"
#import "ARTNetUtil.h"
#import "ARTUserManager.h"
#import "ARTEasemobServer.h"
#import "ARTUMengServer.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //初始化友盟统计
    [ARTUMengServer initUMengSDK];
    
    
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

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
