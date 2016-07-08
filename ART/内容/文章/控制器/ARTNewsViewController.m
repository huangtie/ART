//
//  ARTNewsViewController.m
//  ART
//
//  Created by huangtie on 16/6/28.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTNewsViewController.h"
#import "ARTRequestUtil.h"
#import "ARTNewsCell.h"
#import "ARTNewsDetailViewController.h"

@interface ARTNewsViewController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) NSMutableArray <ARTNewsData *>*newsList;

@end

@implementation ARTNewsViewController

+ (ARTNewsViewController *)launchViewController:(UIViewController *)viewController
{
    ARTNewsViewController *vc = [[ARTNewsViewController alloc] init];
    [viewController.navigationController pushViewController:vc animated:YES];
    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"文章中心";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGH, self.view.width, self.view.height - NAVIGATION_HEIGH) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UICOLOR_ARGB(0xfffafafa);
    [self.view addSubview:self.tableView];
    
    WS(weak)
    [self.tableView addMJRefreshHeader:^{
        [weak requestNewsList:YES];
    }];
    
    [self displayHUD];
    [self requestNewsList:YES];
}

#pragma mark REQUEST
- (void)requestNewsList:(BOOL)isRefresh
{
    ARTCustomParam *param = [[ARTCustomParam alloc] init];
    param.limit = ARTPAGESIZE;
    param.offset = isRefresh ? @"0" : STRING_FORMAT_ADC(@(self.newsList.count));
    
    WS(weak)
    [ARTRequestUtil requestNewsList:param completion:^(NSURLSessionDataTask *task, NSArray<ARTNewsData *> *datas) {
        [weak hideHUD];
        if (isRefresh)
        {
            weak.newsList = [NSMutableArray array];
            [weak.tableView.mj_header endRefreshing];
            if (datas.count >= ARTPAGESIZE.integerValue)
            {
                [weak.tableView addMJRefreshFooter:^{
                    [weak requestNewsList:NO];
                }];
            }
        }
        else
        {
            [weak.tableView.mj_footer endRefreshing];
            if (!datas.count)
            {
                [weak.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [weak.newsList addObjectsFromArray:datas];
        [weak.tableView reloadData];
    } failure:^(ErrorItemd *error) {
        [weak hideHUD];
        if (isRefresh)
        {
            [weak.tableView.mj_header endRefreshing];
        }
        else
        {
            [weak.tableView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark DELEGATE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idetifar = @"newscell";
    ARTNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:idetifar];
    if (!cell)
    {
        cell = [[ARTNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idetifar];
    }
    [cell updateData:self.newsList[indexPath.row] isWhite:indexPath.row % 2 != 0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ARTNewsData *data = self.newsList[indexPath.row];
    [ARTNewsDetailViewController launchViewController:self newsID:data.newsID];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ARTNEWSCELLHEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}








@end
