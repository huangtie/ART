//
//  ARTSearchViewController.m
//  ART
//
//  Created by huangtie on 16/6/27.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTSearchViewController.h"
#import "ARTRequestUtil.h"
#import <UIScrollView+EmptyDataSet.h>
#import "ARTBookCell.h"
#import "ARTBookDetailViewController.h"

@interface ARTSearchViewController()
<UICollectionViewDelegateFlowLayout,
UICollectionViewDelegate,
UICollectionViewDataSource,
DZNEmptyDataSetDelegate,
DZNEmptyDataSetSource,
UITextFieldDelegate>

@property (nonatomic , strong) UICollectionView *bookCollection;

@property (nonatomic , strong) NSMutableArray <ARTBookData *> *books;

@property (nonatomic , strong) UITextField *textField;

@property (nonatomic , strong) UIView *headerView;
@end

@implementation ARTSearchViewController

+ (ARTSearchViewController *)launchViewController:(UIViewController *)viewController
{
    ARTSearchViewController *vc = [[ARTSearchViewController alloc] init];
    [viewController.navigationController pushViewController:vc animated:YES];
    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"搜索图集";
    
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
}

#pragma mark GET_SET
- (UIView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bookCollection.width, 70)];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        UIView *bg = [[UIView alloc] init];
        bg.size = CGSizeMake(_headerView.width, 45);
        bg.center = CGPointMake(_headerView.width / 2, _headerView.height / 2);
        bg.backgroundColor = UICOLOR_ARGB(0xfff5f5f5);
        [bg clipRadius:4 borderWidth:0 borderColor:nil];
        [_headerView addSubview:bg];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"book_icon_8"]];
        [imageView sizeToFit];
        imageView.right = bg.width - 15;
        imageView.centerY = bg.height / 2;
        [bg addSubview:imageView];
        
        self.textField = [[UITextField alloc] init];
        self.textField.size = CGSizeMake(600, 35);
        self.textField.left = 15;
        self.textField.centerY = bg.height / 2;
        self.textField.borderStyle = UITextBorderStyleNone;
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textField.font = FONT_WITH_18;
        self.textField.textColor = UICOLOR_ARGB(0xff333333);
        self.textField.returnKeyType = UIReturnKeySearch;
        self.textField.delegate = self;
        self.textField.placeholder = @"请输入搜索关键字";
        [bg addSubview:self.textField];
        
    }
    return _headerView;
}

#pragma mark REQUEST
- (void)requestWithBooks:(BOOL)isRefresh
{
    [self.view endEditing:YES];
    
    ARTBookListParam *param = [[ARTBookListParam alloc] init];
    param.limit = ARTPAGESIZE;
    param.offset = isRefresh ? @"0" : STRING_FORMAT_ADC(@(self.books.count));
    param.key = self.textField.text;
    
    WS(weak)
    [ARTRequestUtil requestBookList:param completion:^(NSURLSessionDataTask *task, NSArray<ARTBookData *> *datas) {
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
    view.size = self.headerView.size;
    view.clipsToBounds = YES;
    [view addSubview:self.headerView];
    return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.width, 70);
}

#pragma mark DELEGAT_DZNEMPTY
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    return [[NSAttributedString alloc] initWithString:@"没有搜索到数据" attributes:@{NSFontAttributeName:FONT_WITH_15}];
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
    return self.textField.text.length && !self.books.count;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    
}

#pragma mark DELEGATE_TEXTFIELD
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self requestWithBooks:YES];
    return NO;
}


@end
