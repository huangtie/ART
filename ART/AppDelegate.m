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

#import "ARTHomeViewController.h"
#import "ARTBookViewController.h"
#import "ARTLocalViewController.h"
#import "ARTSocialViewController.h"
#import "ARTAuctionViewController.h"
#import "ARTTabBarViewController.h"

#import "ARTBookDetailViewController.h"
#import "ARTNewsDetailViewController.h"

#import "ARTLaunchScreen.h"
#import "ARTGuideView.h"

@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //初始化友盟统计
    [ARTUMengUtil initUMengSDK];
    
    //初始化分享
    [ARTShareUtil initShareSDK];
    
    self.window = [[UIWindow alloc] initWithFrame: [UIScreen mainScreen].bounds];
    ARTHomeViewController *homeVC = [[ARTHomeViewController alloc] init];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    ARTBookViewController *bookVC = [[ARTBookViewController alloc] init];
    UINavigationController *bookNav = [[UINavigationController alloc] initWithRootViewController:bookVC];
    ARTLocalViewController *localVC = [[ARTLocalViewController alloc] init];
    UINavigationController *localNav = [[UINavigationController alloc] initWithRootViewController:localVC];
    ARTSocialViewController *socialVC = [[ARTSocialViewController alloc] init];
    UINavigationController *socialNav = [[UINavigationController alloc] initWithRootViewController:socialVC];
    ARTAuctionViewController *auctionVC = [[ARTAuctionViewController alloc] init];
    UINavigationController *auctionNav = [[UINavigationController alloc] initWithRootViewController:auctionVC];
    
    ARTTabBarViewController *tabVC = [[ARTTabBarViewController alloc] init];
    tabVC.viewControllers = @[homeNav,bookNav,localNav,socialNav,auctionNav];
    self.window.rootViewController = tabVC;
    YYReachability *bility = [YYReachability reachability];
    if (bility.status == YYReachabilityStatusNone)
    {
        [tabVC moveTabin:ART_TABINDEX_LOCAL];
    }
    
    [self.window makeKeyAndVisible];
    if(!FIRST_OUT_APP)
    {
        [ARTGuideView launchIn:self.window];
        
    }
    [ARTLaunchScreen launchIn:self.window completion:^{
        if (!FIRST_OUT_APP)
        {
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        }
        FIRST_IN_APP(YES);
        //初始化个推
        [ARTGTPushUtil sharedInstance];
    }];
    
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

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    if([UIApplication sharedApplication].applicationState == UIApplicationStateInactive)
    {
        NSDictionary *aps = userInfo[@"aps"];
        NSString *category = aps[@"category"];
        if (category.length)
        {
            NSArray *array = [category componentsSeparatedByString:@"&&"];
            if (array.count > 1)
            {
                NSString *type = array.firstObject;
                NSString *code = array.lastObject;
                
                switch (type.integerValue)
                {
                    case 1:
                    {
                        [ARTBookDetailViewController launchFromController:[ARTBaseViewController getVisibleViewController] bookID:code];
                    }
                        break;
                    case 2:
                    {
                        [ARTNewsDetailViewController launchViewController:[ARTBaseViewController getVisibleViewController] newsID:code];
                    }
                        break;
                    case 3:
                    {
                        
                    }
                        break;
                    default:
                        break;
                }
            }
        }
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}


- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{

}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{

}

+ (AppDelegate *)delegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

@end
