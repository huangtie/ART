//
//  ARTTabBarViewController.m
//  ART
//
//  Created by huangtie on 16/5/18.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTTabBarViewController.h"
#import "ARTCustomTabBar.h"

@interface ARTTabBarViewController ()<ARTCustomTabBarDelegate>

@property (nonatomic , strong) ARTCustomTabBar *customTabBar;

@end

@implementation ARTTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tabBar removeFromSuperview];
    [self.view addSubview:self.customTabBar];
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

}

- (void)customTabBarDidTouchItems:(ART_TABINDEX)index
{
    self.selectedIndex = index;
}


@end
