//
//  ARTTabBarViewController.m
//  ART
//
//  Created by huangtie on 16/5/18.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTTabBarViewController.h"
#import "ARTCustomTabBar.h"
#import "AppDelegate.h"
#import "ARTBaseViewController.h"

@interface ARTTabBarViewController ()<ARTCustomTabBarDelegate>

@property (nonatomic , strong) ARTCustomTabBar *customTabBar;

@end

@implementation ARTTabBarViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tabBar removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.customTabBar.superview)
    {
        UINavigationController *selectVC = self.viewControllers[self.selectedIndex];
        [selectVC.viewControllers.firstObject.view addSubview:self.customTabBar];
    }
}

- (ARTCustomTabBar *)customTabBar
{
    if (!_customTabBar)
    {
        _customTabBar = [[ARTCustomTabBar alloc] init];
        _customTabBar.delegate = self;
    }
    return _customTabBar;
}

#pragma mark DELEGATE
- (void)customTabBarDidTouchSearch
{

}

- (void)customTabBarDidTouchUser
{
    [ARTAlertView alertTitle:@"温馨提示" message:@"确定删除?" doneTitle:@"取消" cancelTitle:@"确定" doneBlock:^{
        
    } cancelBlock:^{
        
    }];
}

- (void)customTabBarDidTouchItems:(ART_TABINDEX)index
{
    self.selectedIndex = index;
    UINavigationController *selectVC = self.viewControllers[self.selectedIndex];
    [selectVC.viewControllers.firstObject.view addSubview:self.customTabBar];
}


@end
