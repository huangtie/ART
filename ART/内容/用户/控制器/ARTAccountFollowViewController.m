//
//  ARTAccountFollowViewController.m
//  ART
//
//  Created by huangtie on 16/7/8.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTAccountFollowViewController.h"
#import <UIScrollView+EmptyDataSet.h>
#import "ARTAccountFollowCell.h"
#import "ARTRequestUtil.h"
#import "ARTAccountListViewController.h"

@interface ARTAccountFollowViewController ()<DZNEmptyDataSetDelegate,
DZNEmptyDataSetSource,UITableViewDataSource,UITableViewDelegate,ARTAccountFollowCellDelegate>

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) NSMutableArray <ARTUserInfo *> *dataList;
@end

@implementation ARTAccountFollowViewController

+ (ARTAccountFollowViewController *)launchViewController:(UIViewController *)viewController
{
    ARTAccountFollowViewController *vc = [[ARTAccountFollowViewController alloc] init];
    [viewController.navigationController pushViewController:vc animated:YES];
    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的关注";
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitle:@"添加关注" forState:UIControlStateNormal];
    [sendButton setTitleColor:COLOR_YSYC_ORANGE forState:UIControlStateNormal];
    sendButton.titleLabel.font = FONT_WITH_18;
    [sendButton addTarget:self action:@selector(_rightItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGH, self.view.width, self.view.height - NAVIGATION_HEIGH) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = UICOLOR_ARGB(0xffe5e5e5);
    [self.view addSubview:self.tableView];
    
    WS(weak)
    [self.tableView addMJRefreshHeader:^{
        [weak requestFollowList];
    }];
    
    [self displayHUD];
    [self requestFollowList];
}

#pragma mark ACTION
- (void)_rightItemClicked:(id)sender
{
    [ARTAccountListViewController launchViewController:self];
}

#pragma mark REQUEST
- (void)requestFollowList
{
    WS(weak)
    [ARTRequestUtil requestMyFans:^(NSURLSessionDataTask *task, NSArray<ARTUserInfo *> *datas) {
        [weak hideHUD];
        [weak.tableView.mj_header endRefreshing];
        weak.dataList = [NSMutableArray array];
        [weak.dataList addObjectsFromArray:datas];
        [weak.tableView reloadData];
    } failure:^(ErrorItemd *error) {
        [weak hideHUD];
        [weak.tableView.mj_header endRefreshing];
        [weak.view displayTostError:error.errMsg];
    }];
}

#pragma mark DELEGATE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"followcell";
    ARTAccountFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell)
    {
        cell = [[ARTAccountFollowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        cell.delegate = self;
    }
    [cell bindingWithData:self.dataList[indexPath.row] type:ACCOUNT_CELL_TYPE_TALK];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ARTACCOUNTFOLLOWCELLHEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    return [[NSAttributedString alloc] initWithString:@"暂无关注的人,点击右上角选择关注" attributes:@{NSFontAttributeName:FONT_WITH_15}];
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
    return self.dataList && !self.dataList.count;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    
}

#pragma mark DELEGAT_CELL
- (void)accountDidTouchButton:(NSString *)userID
{
    
}

@end
