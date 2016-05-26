//
//  ARTBaseViewController.m
//  ART
//
//  Created by huangtie on 16/5/12.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBaseViewController.h"
#import "ARTUMengUtil.h"
#import <UINavigationController+FDFullscreenPopGesture.h>

@interface ARTBaseViewController()
{
    /**
     * 对外声明readonly来表示只读，但是实际在内部使用弱引用和dynamic建立了强引用关系
     */
    __weak UINavigationBar *_navigationBar;
}

@end

@implementation ARTBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 背景色
    self.view.backgroundColor = COLOR_VIEWBG_WHITE;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 每个UIViewController都隐藏导航栏
    self.fd_prefersNavigationBarHidden = YES;
    
    // 每个UIViewController保持自己的导航栏，与其他界面无关
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, NAVIGATION_HEIGH)];
    navigationBar.backgroundColor = COLOR_DAOHANG_WHITE;
    navigationBar.barTintColor = COLOR_DAOHANG_WHITE;
    navigationBar.tintColor = UICOLOR_ARGB(0xff333333);
    navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:UICOLOR_ARGB(0xff333333),NSFontAttributeName:FONT_WITH_15};
    [self.view addSubview:navigationBar];
    self.navigationBar = navigationBar;
    self.navigationBar.items = @[self.navigationItem];
    
    NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
    if (index != NSNotFound && index != 0)
    {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithBack:self action:@selector(_backItemClicked:)];
    }
}

- (UINavigationBar *)navigationBar
{
    return _navigationBar;
}

- (void)setNavigationBar:(UINavigationBar *)navigationBar
{
    if (![_navigationBar isEqual:navigationBar]) {
        _navigationBar = navigationBar;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //友盟统计
    [MobClick beginLogPageView:self.title];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //友盟统计
    [MobClick endLogPageView:self.title];
}

#pragma mark ACTION
- (void)_backItemClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)_rightItemClicked:(id)sender
{
    
}

@end
