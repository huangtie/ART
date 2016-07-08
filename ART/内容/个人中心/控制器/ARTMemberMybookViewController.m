//
//  ARTMemberMybookViewController.m
//  ART
//
//  Created by huangtie on 16/6/27.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTMemberMybookViewController.h"
#import "ARTRequestUtil.h"
#import <UIScrollView+EmptyDataSet.h>
#import "ARTBookCell.h"
#import "ARTBookDetailViewController.h"

@interface ARTMemberMybookViewController()
<UICollectionViewDelegateFlowLayout,
UICollectionViewDelegate,
UICollectionViewDataSource,
DZNEmptyDataSetDelegate,
DZNEmptyDataSetSource>

@property (nonatomic , strong) UICollectionView *bookCollection;

@property (nonatomic , strong) NSMutableArray <ARTBookData *> *books;

@end

@implementation ARTMemberMybookViewController

+ (ARTMemberMybookViewController *)launchViewController:(UIViewController *)viewController
{
    ARTMemberMybookViewController *vc = [[ARTMemberMybookViewController alloc] init];
    [viewController.navigationController pushViewController:vc animated:YES];
    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的图集";
    
    CGSize size = CGSizeMake(289 * 2 + 100, self.view.height - NAVIGATION_HEIGH);
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumInteritemSpacing:0.5];
    [flowLayout setMinimumLineSpacing:1];
    [flowLayout setItemSize:CGSizeMake(289, 437)];
    self.bookCollection=[[UICollectionView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGH + 0.5, size.width, size.height) collectionViewLayout:flowLayout];
    self.bookCollection.centerX = self.view.width / 2;
    self.bookCollection.dataSource = self;
    self.bookCollection.delegate = self;
    [self.bookCollection setBackgroundColor:[UIColor whiteColor]];
    [self.bookCollection setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.bookCollection registerNib:[UINib nibWithNibName:@"ARTBookCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"bookcell"];
    [self.bookCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    self.bookCollection.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.bookCollection];
    self.bookCollection.emptyDataSetDelegate = self;
    self.bookCollection.emptyDataSetSource = self;
    
    WS(weak)
    [self.bookCollection addMJRefreshHeader:^{
        [weak requestWithBooks:YES];
    }];
    
    [self displayHUD];
    [self requestWithBooks:YES];
}

#pragma mark REQUEST
- (void)requestWithBooks:(BOOL)isRefresh
{
    ARTCustomParam *param = [[ARTCustomParam alloc] init];
    param.limit = ARTPAGESIZE;
    param.offset = isRefresh ? @"0" : STRING_FORMAT_ADC(@(self.books.count));
    
    WS(weak)
    [ARTRequestUtil requestBuyedList:param completion:^(NSURLSessionDataTask *task, NSArray<ARTBookData *> *datas) {
        [weak hideHUD];
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

#pragma mark DELEGATE
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.books.count;
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
    view.size = CGSizeMake(collectionView.width, 70);
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.width, 70);
}

#pragma mark DELEGAT_DZNEMPTY
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    return [[NSAttributedString alloc] initWithString:@"暂无数据" attributes:@{NSFontAttributeName:FONT_WITH_15}];
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
    return self.books && !self.books.count;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    
}


@end
