//
//  ARTAuthorViewController.m
//  ART
//
//  Created by huangtie on 16/6/28.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTAuthorViewController.h"
#import "ARTRequestUtil.h"
#import <UIScrollView+EmptyDataSet.h>
#import "ARTAuthorDetailViewController.h"
#import "ARTAuthorCell.h"

@interface ARTAuthorViewController()
<UICollectionViewDelegateFlowLayout,
UICollectionViewDelegate,
UICollectionViewDataSource,
DZNEmptyDataSetDelegate,
DZNEmptyDataSetSource>

@property (nonatomic , strong) UICollectionView *collectionView;

@property (nonatomic , strong) NSMutableArray <ARTAuthorData *> *authors;

@end

@implementation ARTAuthorViewController

+ (ARTAuthorViewController *)launchViewController:(UIViewController *)viewController
{
    ARTAuthorViewController *vc = [[ARTAuthorViewController alloc] init];
    [viewController.navigationController pushViewController:vc animated:YES];
    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"藏家列表";
    
    CGSize size = CGSizeMake(self.view.width - 40, self.view.height - NAVIGATION_HEIGH);
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumInteritemSpacing:0.5];
    [flowLayout setMinimumLineSpacing:1];
    [flowLayout setItemSize:CGSizeMake(size.width / 3 - 2, size.height / 3)];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGH + 0.5, size.width, size.height) collectionViewLayout:flowLayout];
    self.collectionView.centerX = self.view.width / 2;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.collectionView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.collectionView registerClass:[ARTAuthorCell class] forCellWithReuseIdentifier:@"authorcell"];
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];
    self.collectionView.emptyDataSetDelegate = self;
    self.collectionView.emptyDataSetSource = self;
    
    WS(weak)
    [self.collectionView addMJRefreshHeader:^{
        [weak requestWithAuthors:YES];
    }];
    
    [self displayHUD];
    [self requestWithAuthors:YES];
}

#pragma mark REQUEST
- (void)requestWithAuthors:(BOOL)isRefresh
{
    ARTCustomParam *param = [[ARTCustomParam alloc] init];
    param.limit = ARTPAGESIZE;
    param.offset = isRefresh ? @"0" : STRING_FORMAT_ADC(@(self.authors.count));
    
    WS(weak)
    [ARTRequestUtil requestAuthorList:param completion:^(NSURLSessionDataTask *task, NSArray<ARTAuthorData *> *datas) {
        [weak hideHUD];
        if (isRefresh)
        {
            weak.authors = [NSMutableArray array];
            [weak.collectionView.mj_header endRefreshing];
            if (datas.count >= ARTPAGESIZE.integerValue)
            {
                [weak.collectionView addMJRefreshFooter:^{
                    [weak requestWithAuthors:NO];
                }];
            }
        }
        else
        {
            [weak.collectionView.mj_footer endRefreshing];
            if (!datas.count)
            {
                [weak.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [weak.authors addObjectsFromArray:datas];
        [weak.collectionView reloadData];
    } failure:^(ErrorItemd *error) {
        [weak hideHUD];
    }];
}

#pragma mark DELEGATE
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.authors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ARTAuthorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"authorcell" forIndexPath:indexPath];
    [cell bindingWithData:self.authors[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ARTAuthorData *data = self.authors[indexPath.row];
    ARTAuthorDetailViewController *detailVC = [[ARTAuthorDetailViewController alloc] initWithAuthorID:data.authorID];
    [self.navigationController pushViewController:detailVC animated:YES];
}















@end
