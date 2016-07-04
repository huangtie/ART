//
//  ARTBaseViewController.h
//  ART
//
//  Created by huangtie on 16/5/12.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYReachability.h>

@interface ARTBaseViewController : UIViewController

@property (nonatomic , strong) YYReachability *reachability;

//是否是无网络状态(YES 是)
@property (nonatomic , assign) BOOL isNetworkError;

//是否能旋转屏幕
@property (nonatomic , assign) BOOL isAutorotate;

/**
 * 自定制导航条
 */
@property (readonly, nonatomic) UINavigationBar *navigationBar;

- (void)_backItemClicked:(id)sender;
- (void)_rightItemClicked:(id)sender;

- (void)displayHUD;
- (void)hideHUD;
- (void)hideHUDnoDelay;

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;

//获得当前可见的viewController
+ (UIViewController *)getVisibleViewController;
@end
