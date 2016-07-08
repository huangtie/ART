//
//  ARTBookViewController.m
//  ART
//
//  Created by huangtie on 16/5/18.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBookViewController.h"
#import "ARTBookScreen.h"
#import "ARTRequestUtil.h"
#import "ARTBookGroupCell.h"
#import <UIScrollView+EmptyDataSet.h>
#import "ARTBookCell.h"
#import <MJRefresh.h>
#import "ARTBookDetailViewController.h"

@interface ARTBookViewController ()
<ARTBookScreenDelegate,
UITableViewDelegate,
UITableViewDataSource,
ARTBookGroupCellDelegate,
UICollectionViewDelegateFlowLayout,
UICollectionViewDelegate,
UICollectionViewDataSource,
DZNEmptyDataSetDelegate,
DZNEmptyDataSetSource>

@property (nonatomic , strong) UIView *screenContrl;

@property (nonatomic , strong) ARTBookScreen *VIPScreen;
@property (nonatomic , strong) ARTBookScreen *timeScreen;
@property (nonatomic , strong) ARTBookScreen *freeScreen;

@property (nonatomic , strong) UITableView *groupListView;
@property (nonatomic , strong) UICollectionView *bookCollection;

@property (nonatomic , strong) NSMutableArray <ARTGroupData *> *groups;
@property (nonatomic , strong) NSMutableArray <ARTBookData *> *books;

@property (nonatomic , assign) NSInteger groupIndex;

@property (nonatomic , strong) ARTBookListParam *bookParam;

@end

@implementation ARTBookViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"图集";
    self.navigationBar.hidden = YES;
    
    [self.view addSubview:self.screenContrl];
    
    self.groupListView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.screenContrl.bottom, GROUP_CELL_WIDTH, self.view.height - self.screenContrl.bottom)];
    self.groupListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.groupListView.backgroundColor = [UIColor whiteColor];
    self.groupListView.delegate = self;
    self.groupListView.dataSource = self;
    [self.view addSubview:self.groupListView];
    
    CGSize size = CGSizeMake(self.view.width - self.groupListView.right - 10, self.groupListView.height);
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumInteritemSpacing:0.5];
    [flowLayout setMinimumLineSpacing:1];
    [flowLayout setItemSize:CGSizeMake(size.width / 2 - 2, size.height / 2)];
    self.bookCollection=[[UICollectionView alloc] initWithFrame:CGRectMake(self.groupListView.right, self.screenContrl.bottom, size.width, size.height) collectionViewLayout:flowLayout];
    self.bookCollection.dataSource = self;
    self.bookCollection.delegate = self;
    [self.bookCollection setBackgroundColor:[UIColor whiteColor]];
    [self.bookCollection setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.bookCollection registerNib:[UINib nibWithNibName:@"ARTBookCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"bookcell"];
    self.bookCollection.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.bookCollection];
    self.bookCollection.emptyDataSetDelegate = self;
    self.bookCollection.emptyDataSetSource = self;
    
    WS(weak)
    [self.bookCollection addMJRefreshHeader:^{
        [weak requestWithBooks:YES];
        [weak requestWithGroups];
    }];
    
    [self displayHUD];
    [self requestWithGroups];
    [self requestWithBooks:YES];
    
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
        [weak.bookCollection reloadData];
    };
}

#pragma mark GET_SET
- (UIView *)screenContrl
{
    if (!_screenContrl)
    {
        _screenContrl = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGH, self.view.width, 70)];
        _screenContrl.backgroundColor = [UIColor whiteColor];
        
        CGFloat Spacing = (_screenContrl.width - 3 * 150) / 4;
        CGFloat top = 20;
        self.VIPScreen = [[ARTBookScreen alloc] initWithTitels:@[@"全部",@"会员",@"非会员"]];
        self.VIPScreen.left = Spacing;
        self.VIPScreen.top = top;
        self.VIPScreen.delegate = self;
        [_screenContrl addSubview:self.VIPScreen];
        
        self.timeScreen = [[ARTBookScreen alloc] initWithTitels:@[@"时间排序",@"下载量",@"评论量"]];
        self.timeScreen.left = self.VIPScreen.right + Spacing;
        self.timeScreen.top = top;
        self.timeScreen.delegate = self;
        [_screenContrl addSubview:self.timeScreen];
        
        self.freeScreen = [[ARTBookScreen alloc] initWithTitels:@[@"全部",@"免费",@"收费"]];
        self.freeScreen.left = self.timeScreen.right + Spacing;
        self.freeScreen.top = top;
        self.freeScreen.delegate = self;
        [_screenContrl addSubview:self.freeScreen];
    }
    return _screenContrl;
}

- (NSMutableArray *)groups
{
    if (!_groups)
    {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

- (ARTBookListParam *)bookParam
{
    if (!_bookParam)
    {
        _bookParam = [[ARTBookListParam alloc] init];
        _bookParam.limit = ARTPAGESIZE;
    }
    return _bookParam;
}

#pragma mark REQUEST
- (void)requestWithGroups
{
    WS(weak)
    [ARTRequestUtil requestGroups:^(NSURLSessionDataTask *task, NSArray<ARTGroupData *> *datas) {
        [weak.groups removeAllObjects];
        ARTGroupData *deData = [[ARTGroupData alloc] init];
        deData.groupName = @"全部";
        deData.groupID = @"";
        [weak.groups addObject:deData];
        [weak.groups addObjectsFromArray:datas];
        [weak.groupListView reloadData];
    } failure:^(ErrorItemd *error) {
        
    }];
}

- (void)requestWithBooks:(BOOL)isRefresh
{
    self.bookParam.offset = isRefresh ? @"0" : STRING_FORMAT_ADC(@(self.books.count));
    
    WS(weak)
    [ARTRequestUtil requestBookList:self.bookParam completion:^(NSURLSessionDataTask *task, NSArray<ARTBookData *> *datas) {
        [weak hideHUD];
        weak.isNetworkError = NO;
        if (isRefresh)
        {
            weak.books = [NSMutableArray array];
            [weak.bookCollection.mj_header endRefreshing];
            if (datas.count >= ARTPAGESIZE.integerValue)
            {
                [weak.bookCollection addMJRefreshFooter:^{
                    [weak requestWithBooks:NO];
                }];
            }
        }
        else
        {
            [weak.bookCollection.mj_footer endRefreshing];
            if (!datas.count)
            {
                [weak.bookCollection.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [weak.books addObjectsFromArray:datas];
        [weak.bookCollection reloadData];
    } failure:^(ErrorItemd *error) {
        [weak hideHUD];
        if (error.code == NET_ERROR_0000)
        {
            weak.isNetworkError = YES;
            [weak.bookCollection reloadData];
        }
        if (isRefresh)
        {
            [weak.bookCollection.mj_header endRefreshing];
        }
        else
        {
            [weak.bookCollection.mj_footer endRefreshing];
        }
    }];
}

#pragma mark DELEGATE_TABLE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ARTBookGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:GROUP_CELL_IDENTIFAR];
    if (!cell)
    {
        cell = [[ARTBookGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GROUP_CELL_IDENTIFAR];
        cell.delegate = self;
    }
    
    [cell bindingWithData:self.groups[indexPath.row] isSelect:indexPath.row == self.groupIndex];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return GROUP_CELL_HEIGHT;
}

#pragma mark DELEGAT_COLLECTION
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.isNetworkError ? 0 : self.books.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ARTBookCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bookcell" forIndexPath:indexPath];
    
    [cell bindingWithData:self.books[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ARTBookData *data = self.books[indexPath.row];
    [ARTBookDetailViewController launchFromController:self bookID:data.bookID];
}

#pragma mark DELEGAT_DZNEMPTY
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.isNetworkError)
    {
        return [[NSAttributedString alloc] initWithString:@"当前无网络连接" attributes:@{NSFontAttributeName:FONT_WITH_18}];
    }
    else
    {
        return [[NSAttributedString alloc] initWithString:@"暂无相关图集" attributes:@{NSFontAttributeName:FONT_WITH_18}];
    }
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
    return (self.books && !self.books.count) || self.isNetworkError;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    
}

#pragma mark DELEGAT_CELL
- (void)bookGroupCellDidSelect:(ARTGroupData *)groupData
{
    self.groupIndex = [self.groups indexOfObject:groupData];
    [self.groupListView reloadData];
    self.bookParam.bookGroup = groupData.groupID;
    [self requestWithBooks:YES];
}

#pragma mark DELEGATE_SCREEN
- (void)screenDidScreen:(ARTBookScreen *)screenView index:(NSInteger)index
{
    if (screenView == self.VIPScreen)
    {
        if (index > 0)
        {
            self.bookParam.bookVIP = STRING_FORMAT_ADC(@(index == 1 ? 1 : 0));
        }
    }
    if(screenView == self.timeScreen)
    {
        if (index > 0)
        {
            self.bookParam.bookOrder = STRING_FORMAT_ADC(@(index == 1 ? 1 : 2));
        }
    }
    if (screenView == self.freeScreen)
    {
        if (index > 0)
        {
            self.bookParam.bookFree = STRING_FORMAT_ADC(@(index == 1 ? 0 : 1));
        }
    }
    
    [self requestWithBooks:YES];
}

@end
