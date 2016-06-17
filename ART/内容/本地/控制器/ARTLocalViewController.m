//
//  ARTLocalViewController.m
//  ART
//
//  Created by huangtie on 16/5/18.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTLocalViewController.h"
#import "ARTDownLoadManager.h"
#import <UIScrollView+EmptyDataSet.h>
#import "ARTLocalCell.h"
#import "ARTLocalReadViewController.h"

@interface ARTLocalViewController ()
<UICollectionViewDelegateFlowLayout,
UICollectionViewDelegate,
UICollectionViewDataSource,
DZNEmptyDataSetDelegate,
DZNEmptyDataSetSource>

@property (nonatomic , strong) UICollectionView *collectionView;

@property (nonatomic , strong) UIView *topView;

@property (nonatomic , strong) NSArray <ARTBookLocalData *> *localDatas;
@property (nonatomic , strong) ARTDownLoadManager *loadManager;

@property (nonatomic , assign) BOOL isDelete;

@end

@implementation ARTLocalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"本地";
    self.navigationBar.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:NOTIFICATION_DOWNLOAD_STATUSCHANGE object:nil];
    
    [self.view addSubview:self.topView];
    
    CGSize size = CGSizeMake(self.view.width, self.view.height - NAVIGATION_HEIGH - self.topView.height);
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumInteritemSpacing:0.5];
    [flowLayout setMinimumLineSpacing:1];
    [flowLayout setItemSize:CGSizeMake(size.width / 3 - 2, size.height / 3)];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGH + self.topView.height, size.width, size.height) collectionViewLayout: flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.emptyDataSetDelegate = self;
    self.collectionView.emptyDataSetSource = self;
    [self.collectionView setBackgroundColor:COLOR_YSYC_GRAY];
    [self.collectionView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.collectionView registerClass:[ARTLocalCell class] forCellWithReuseIdentifier:@"localcell"];
    [self.view addSubview:self.collectionView];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark LOAD_DATA
- (void)loadData
{
    WS(weak)
    [self.loadManager getALLBook:^(NSMutableArray<ARTBookLocalData *> *dataList) {
        weak.localDatas = dataList;
        [weak.collectionView reloadData];
    }];
}

#pragma mark GET_SET
- (ARTDownLoadManager *)loadManager
{
    if (!_loadManager)
    {
        _loadManager = [[ARTDownLoadManager alloc] init];
    }
    return _loadManager;
}

- (UIView *)topView
{
    if (!_topView)
    {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGH, SCREEN_WIDTH, 80)];
        _topView.backgroundColor = [UIColor whiteColor];
        
        UIButton *beginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [beginButton setBackgroundImage:[UIImage imageNamed:@"book_icon_3"] forState:UIControlStateNormal];
        [beginButton sizeToFit];
        beginButton.left = 30;
        beginButton.centerY = _topView.height / 2;
        [beginButton addTarget:self action:@selector(beginAction) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:beginButton];
        
        UIButton *endButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [endButton setBackgroundImage:[UIImage imageNamed:@"book_icon_4"] forState:UIControlStateNormal];
        [endButton sizeToFit];
        endButton.left = beginButton.right + 50;
        endButton.centerY = _topView.height / 2;
        [endButton addTarget:self action:@selector(endAction) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:endButton];
        
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"book_icon_5"] forState:UIControlStateNormal];
        [deleteButton sizeToFit];
        deleteButton.right = _topView.width - 25;
        deleteButton.centerY = _topView.height / 2;
        [deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:deleteButton];
    }
    return _topView;
}

#pragma mark ACTION
- (void)beginAction
{
    for (ARTBookLocalData *data in self.localDatas)
    {
        if (![ARTDownLoadManager isDownFinish:data] && ![ARTDownLoadManager isDownLoading:data.bookID])
        {
            [ARTBookDownObject downLoadWithReadData:data];
        }
    }
}

- (void)endAction
{
    for (ARTBookDownObject *object in [ARTDownLoadManager sharedInstance].downQueueList)
    {
        [object downLoadPause];
    }
    [self.collectionView reloadData];
}

- (void)deleteAction
{
    self.isDelete = !self.isDelete;
    [self.collectionView reloadData];
}

#pragma mark DELEGAT_COLLECTION
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.localDatas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ARTLocalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"localcell" forIndexPath:indexPath];
    [cell updateData:self.localDatas[indexPath.row] isDelete:self.isDelete];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isDelete)
    {
        return;
    }
    
    ARTBookLocalData *data = self.localDatas[indexPath.row];
    if ([ARTDownLoadManager isDownFinish:data])
    {
        //已下载完成，直接打开
        [ARTLocalReadViewController lunch:data.bookID viewController:self];
    }
    else
    {
        ARTBookDownObject *object = [[ARTDownLoadManager sharedInstance] isDownLoadIng:data.bookID];
        if (object)
        {
            [object downLoadPause];
        }
        else
        {
            object = [[ARTBookDownObject alloc] initWithReadData:data];
        }
        [self.collectionView reloadData];
    }
}

#pragma mark DELEGAT_DZNEMPTY
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    return [[NSAttributedString alloc] initWithString:@"暂无图集" attributes:@{NSFontAttributeName:FONT_WITH_15}];
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
    return !self.localDatas.count;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    
}

@end
