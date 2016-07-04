//
//  ARTHomeViewController.m
//  ART
//
//  Created by huangtie on 16/5/18.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTHomeViewController.h"
#import "ARTBannerView.h"
#import "ARTRequestUtil.h"
#import "ARTBookDetailViewController.h"
#import "ARTHomeNoticeViewController.h"
#import "ARTAuthorViewController.h"
#import <UIScrollView+EmptyDataSet.h>
#import "ARTTabBarViewController.h"
#import "ARTNewsViewController.h"

@interface ARTHomeViewController ()
<ARTBannerViewDataSource,ARTBannerViewDelegate,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,
DZNEmptyDataSetSource>

@property (nonatomic , strong) ARTBannerView *bannerView;

@property (nonatomic , strong) NSArray <ARTNoticeData *> *bannerDatas;

@property (nonatomic , strong) NSArray <ARTBookData *> *bookDatas;

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) UITableViewCell *iconCell;

@property (nonatomic , strong) UIView *bookCell;

@end

@implementation ARTHomeViewController

#define BANNER_HEIGHT 274
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"首页";
    
    self.navigationBar.hidden = YES;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGH, SCREEN_WIDTH, self.view.height - NAVIGATION_HEIGH)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    [self.view addSubview:self.tableView];
    WS(weak)
    [self.tableView addMJRefreshHeader:^{
        [weak requestNotice];
        [weak requestBooks];
    }];
    
    self.bannerView = [[ARTBannerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, BANNER_HEIGHT)];
    self.bannerView.delegate = self;
    self.bannerView.dataSource = self;
    self.bannerView.backgroundColor = UICOLOR_ARGB(0xffe5e5e5);
    self.tableView.tableHeaderView = self.bannerView;
    self.tableView.tableFooterView = self.bookCell;
    
    [self requestNotice];
    [self requestBooks];
    
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
}

#pragma mark LAYOUT
- (void)layoutBookCell
{
    [self.bookCell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGSize itemSize = CGSizeMake(200, 300);
    CGFloat left = 30;
    CGFloat padding = (self.bookCell.width - 2 * left - 3 * itemSize.width) / 2;
    
    for (NSInteger i = 0; i < self.bookDatas.count; i++)
    {
        ARTBookData *data = self.bookDatas[i];
        
        UIView *itemView = [[UIView alloc] init];
        itemView.size = itemSize;
        itemView.left = left + (itemSize.width + padding) * i;
        itemView.top = 20;
        [self.bookCell addSubview:itemView]; 
        
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, itemSize.width, 262)];
        bg.backgroundColor = UICOLOR_ARGB(0xffe5e5e5);
        [itemView addSubview:bg];
        
        UIImageView *picture = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, itemSize.width - 12, bg.height - 12)];
        picture.clipsToBounds = YES;
        picture.contentMode = UIViewContentModeScaleAspectFill;
        [picture sd_setImageWithURL:[NSURL URLWithString:data.bookImage] placeholderImage:IMAGE_PLACEHOLDER_BOOK];
        [bg addSubview:picture];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(picture.left, 0, picture.width, 20)];
        titleLabel.bottom = itemView.height;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = UICOLOR_ARGB(0xff666666);
        titleLabel.font = FONT_WITH_18;
        titleLabel.text = data.bookName;
        [itemView addSubview:titleLabel];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = itemView.bounds;
        [button addTarget:self action:@selector(bookClick:) forControlEvents:UIControlEventTouchUpInside];
        [itemView addSubview:button];
    }
}

#pragma mark GET_SET
- (void)setIsNetworkError:(BOOL)isNetworkError
{
    if (isNetworkError)
    {
        self.tableView.tableHeaderView = nil;
        self.tableView.tableFooterView = nil;
    }
    else
    {
        self.tableView.tableHeaderView = self.bannerView;
        self.tableView.tableFooterView = self.bookCell;
    }
    [self.tableView reloadData];
    [super setIsNetworkError:isNetworkError];
}

- (UITableViewCell *)iconCell
{
    if (!_iconCell)
    {
        _iconCell = [[UITableViewCell alloc] init];
        _iconCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary *dic1 = @{@"title":@"图集",@"image":@"home_icon_1"};
        NSDictionary *dic2 = @{@"title":@"藏家",@"image":@"home_icon_2"};
        NSDictionary *dic3 = @{@"title":@"文章",@"image":@"home_icon_3"};
//        NSDictionary *dic4 = @{@"title":@"拍卖",@"image":@"home_icon_4"};
//        NSDictionary *dic5 = @{@"title":@"关于",@"image":@"home_icon_5"};
//        NSDictionary *dic6 = @{@"title":@"藏友",@"image":@"home_icon_6"};
//        NSDictionary *dic7 = @{@"title":@"更多",@"image":@"home_icon_7"};
        
        NSArray *items = @[@[dic1,dic2,dic3]];
        CGSize size = CGSizeMake(180, 160);
        _iconCell.width = SCREEN_WIDTH;
        _iconCell.height = size.height * items.count;
        
        CGFloat left = 30;
        CGFloat padding = (_iconCell.width - 2 * left - 4 * size.width) / 3;
        for (NSInteger i = 0; i < items.count; i++)
        {
            NSArray *array = items[i];
            for (NSInteger j = 0; j < array.count; j++)
            {
                NSDictionary *dic = array[j];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.size = size;
                button.left = left + (padding + size.width) * j;
                button.top = size.height * i;
                [button setImage:[UIImage imageNamed:dic[@"image"]] forState:UIControlStateNormal];
                [button setTitle:dic[@"title"] forState:UIControlStateNormal];
                [button setTitleColor:UICOLOR_ARGB(0xff666666) forState:UIControlStateNormal];
                button.titleLabel.font = FONT_WITH_15;
                button.titleEdgeInsets = UIEdgeInsetsMake(100, -76, 0, 0);
                button.imageEdgeInsets = UIEdgeInsetsMake(-20, 35, 0, 0);
                [button addTarget:self action:@selector(itemsTouchAction:) forControlEvents:UIControlEventTouchUpInside];
                [_iconCell addSubview:button];
            }
        }
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = UICOLOR_ARGB(0xffe5e5e5);
        line.height = ONE_POINT_LINE_WIDTH;
        line.width = SCREEN_WIDTH;
        line.bottom = _iconCell.height;
        [_iconCell addSubview:line];
    }
    return _iconCell;
}

- (UIView *)bookCell
{
    if (!_bookCell)
    {
        _bookCell = [[UIView alloc] init];
        _bookCell.width = SCREEN_WIDTH;
        _bookCell.height = self.view.height - BANNER_HEIGHT - self.iconCell.height - NAVIGATION_HEIGH;
    }
    return _bookCell;
}

#pragma mark ACTION
- (void)itemsTouchAction:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:@"图集"])
    {
        ARTTabBarViewController *tabViewController = (ARTTabBarViewController *)self.tabBarController;
        [tabViewController moveTabin:ART_TABINDEX_BOOK];
    }
    if ([button.titleLabel.text isEqualToString:@"藏家"])
    {
        [ARTAuthorViewController launchViewController:self];
    }
    if ([button.titleLabel.text isEqualToString:@"文章"])
    {
        [ARTNewsViewController launchViewController:self];
    }
}

- (void)bookClick:(UIButton *)button
{
    NSInteger index = [self.bookCell.subviews indexOfObject:button.superview];
    if (index < self.bookDatas.count && index > -1)
    {
        ARTBookData *data = self.bookDatas[index];
        [ARTBookDetailViewController launchFromController:self bookID:data.bookID];
    }
}

#pragma mark REQUEST
- (void)requestNotice
{
    WS(weak)
    [ARTRequestUtil requestNotices:^(NSURLSessionDataTask *task, NSArray<ARTNoticeData *> *datas) {
        [weak.tableView.mj_header endRefreshing];
        weak.bannerDatas = datas;
        weak.isNetworkError = NO;
        [weak.bannerView reloadData];
        [weak.tableView reloadEmptyDataSet];
    } failure:^(ErrorItemd *error) {
        [weak.tableView.mj_header endRefreshing];
        if (error.code == NET_ERROR_0000)
        {
            weak.isNetworkError = YES;
        }
        [weak.tableView reloadEmptyDataSet];
    }];
}

- (void)requestBooks
{
    ARTBookListParam *param = [[ARTBookListParam alloc] init];
    param.limit = @"3";
    param.offset = @"0";
    WS(weak)
    [ARTRequestUtil requestBookList:param completion:^(NSURLSessionDataTask *task, NSArray<ARTBookData *> *datas) {
        weak.bookDatas = datas;
        [weak layoutBookCell];
    } failure:^(ErrorItemd *error) {
        
    }];
}

#pragma mark DELEGATE_TABLEVIEW
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return !self.isNetworkError;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return self.iconCell;
    }
    return [[UITableViewCell alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return self.iconCell.height;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

#pragma mark DELEGATE_BANNER
- (NSInteger)numberOfItemsInBannerView:(ARTBannerView *)bannerView
{
    return self.bannerDatas.count;
}

- (NSURL *)bannerView:(ARTBannerView *)bannerView imageURLAtIndex:(NSInteger)index
{
    ARTNoticeData *data = self.bannerDatas[index];
    return [NSURL URLWithString:data.noticeImage];
}

- (NSString *)bannerView:(ARTBannerView *)bannerView titleAtIndex:(NSInteger)index
{
    ARTNoticeData *data = self.bannerDatas[index];
    return data.noticeTitle;
}

- (UIImage *)bannerView:(ARTBannerView *)bannerView iconImageAtIndex:(NSInteger)index
{
    return nil;
}

- (void)bannerView:(ARTBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index
{
    [ARTHomeNoticeViewController launchFromController:self data:self.bannerDatas[index]];
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
