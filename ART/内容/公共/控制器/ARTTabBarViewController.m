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
#import "ARTMemberViewController.h"
#import "ARTSearchViewController.h"

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

- (void)moveTabin:(ART_TABINDEX)index
{
    [self.customTabBar moveTabin:index];
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
    UINavigationController *selectVC = self.viewControllers[self.selectedIndex];
    [ARTSearchViewController launchViewController:selectVC.viewControllers.firstObject];
}

- (void)customTabBarDidTouchUser
{
    UINavigationController *selectVC = self.viewControllers[self.selectedIndex];
    [ARTMemberViewController launchViewController:selectVC.viewControllers.firstObject];
}

- (void)customTabBarDidTouchItems:(ART_TABINDEX)index
{
    self.selectedIndex = index;
    UINavigationController *selectVC = self.viewControllers[self.selectedIndex];
    [selectVC.viewControllers.firstObject.view addSubview:self.customTabBar];
}


@end
