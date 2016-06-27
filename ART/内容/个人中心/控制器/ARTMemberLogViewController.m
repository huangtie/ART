//
//  ARTMemberLogViewController.m
//  ART
//
//  Created by huangtie on 16/6/27.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTMemberLogViewController.h"
#import "ARTRequestUtil.h"
#import <UIScrollView+EmptyDataSet.h>
#import "ARTMemberLogCell.h"

@interface ARTMemberLogViewController()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,
DZNEmptyDataSetSource>

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) NSMutableArray *dataList;

@end

@implementation ARTMemberLogViewController

+ (ARTMemberLogViewController *)launchViewController:(UIViewController *)viewController
{
    ARTMemberLogViewController *vc = [[ARTMemberLogViewController alloc] init];
    [viewController.navigationController pushViewController:vc animated:YES];
    return vc;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"消费记录";
    
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
        [weak requestLog:YES];
    }];
    
    [weak displayHUD];
    [self requestLog:YES];
}

#pragma mark REQUEST
- (void)requestLog:(BOOL)isRefresh
{
    ARTCustomParam *param = [[ARTCustomParam alloc] init];
    param.limit = ARTPAGESIZE;
    if (isRefresh)
    {
        param.offset = @"0";
    }
    else
    {
        param.offset = STRING_FORMAT_ADC(@(self.dataList.count));
    }
    WS(weak)
    [ARTRequestUtil requestPurchaLog:param completion:^(NSURLSessionDataTask *task, NSArray<ARTPurchasesLogData *> *datas) {
        [weak hideHUD];
        if (isRefresh)
        {
            weak.dataList = [NSMutableArray array];
        }
        [weak.tableView.mj_header endRefreshing];
        if (datas.count >= ARTPAGESIZE.integerValue)
        {
            [weak.tableView addMJRefreshFooter:^{
                [weak requestLog:NO];
            }];
        }
        else
        {
            [weak.tableView.mj_footer endRefreshing];
            if (!datas.count)
            {
                [weak.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [weak.dataList addObjectsFromArray:datas];
        [weak.tableView reloadData];
    } failure:^(ErrorItemd *error) {
        [weak hideHUD];
    }];
}

#pragma mark DELEGATE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"logcell";
    ARTMemberLogCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell)
    {
        cell = [[ARTMemberLogCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    
    [cell updateData:self.dataList[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ARTMEMBERLOGCELLHEIGHT;
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
    return [[NSAttributedString alloc] initWithString:@"暂无记录" attributes:@{NSFontAttributeName:FONT_WITH_15}];
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






@end
