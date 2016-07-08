//
//  ARTSocialViewController.m
//  ART
//
//  Created by huangtie on 16/5/18.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTSocialViewController.h"
#import "ARTSocialCell.h"
#import "ARTTalkViewController.h"
#import "ARTLocalPageViewController.h"
#import "ARTNewsViewController.h"
#import <UIScrollView+EmptyDataSet.h>
#import "ARTAccountFollowViewController.h"

@interface ARTSocialViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,
DZNEmptyDataSetSource>

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) NSArray *icons;

@property (nonatomic , strong) NSArray *titles;

@end

@implementation ARTSocialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"圈子";
    
    self.navigationBar.hidden = YES;
    
//    self.icons = @[@"talk_icon_chat",@"talk_icon_friend",@"talk_icon_shuo",@"talk_icon_news"];
//    self.titles = @[@"我的私信",@"我的关注",@"动态",@"文章中心"];
    self.icons = @[@"talk_icon_friend",@"talk_icon_shuo",@"talk_icon_news"];
    self.titles = @[@"我的关注",@"动态",@"文章中心"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGH + 0.5, self.view.width, self.view.height - NAVIGATION_HEIGH)];
    self.tableView.backgroundColor = COLOR_YSYC_GRAY;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    [self.view addSubview:self.tableView];
    
    WS(weak)
    self.reachability = [YYReachability reachability];
    self.reachability.notifyBlock = ^(YYReachability *reachability)
    {
        if (reachability.status == YYReachabilityStatusNone)
        {
            weak.isNetworkError = YES;
        }
        else
        {
            weak.isNetworkError = NO;
        }
        [weak.tableView reloadData];
    };
    if (self.reachability.status == YYReachabilityStatusNone)
    {
        self.isNetworkError = YES;
        [self.tableView reloadData];
    }
}

#pragma mark DELEGATE_TABLEVIEW
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.isNetworkError ? 0 : self.icons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *itentifar = @"scocialcell";
    ARTSocialCell *cell = [tableView dequeueReusableCellWithIdentifier:itentifar];
    if (!cell)
    {
        cell = [[ARTSocialCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itentifar];
    }
    
    [cell updateData:self.icons[indexPath.row] titleName:self.titles[indexPath.row] isWhite:indexPath.row % 2 != 0];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ARTSocialCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 3)
    {
        ARTLocalPageViewController *vc = [[ARTLocalPageViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.row == 0)
    {
        WS(weak)
        [[ARTUserManager sharedInstance] isLogin:self logined:^(ARTUserData *userInfo) {
            [ARTAccountFollowViewController launchViewController:weak];
        }];
    }
    
    if (indexPath.row == 1)
    {
        [ARTTalkViewController launchViewController:self];
    }
    
    if (indexPath.row == 2)
    {
        [ARTNewsViewController launchViewController:self];
    }
}

#pragma mark DELEGAT_DZNEMPTY
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    return [[NSAttributedString alloc] initWithString:@"当前无网络连接" attributes:@{NSFontAttributeName:FONT_WITH_18}];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return IMAGE_EMPTY_ONE;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return self.isNetworkError;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    
}


@end
