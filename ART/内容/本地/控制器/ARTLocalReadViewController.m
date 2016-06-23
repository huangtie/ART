//
//  ARTLocalReadViewController.m
//  ART
//
//  Created by huangtie on 16/6/8.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTLocalReadViewController.h"
#import "ARTDownLoadManager.h"
#import "ARTLocalPageViewController.h"
#import "ARTDownLoadManager.h"
#import "ARTLocalMinCell.h"

@interface ARTLocalReadViewController()<UIPageViewControllerDataSource,UICollectionViewDelegateFlowLayout,
UICollectionViewDelegate,
UICollectionViewDataSource , ARTLocalMinCellDelegate>

@property (strong , nonatomic) UIPageViewController * pageController;

@property (strong , nonatomic) ARTBookLocalData *localData;

@property (nonatomic , copy) NSString *bookID;

@property (nonatomic , strong) UIView *markView;
@property (nonatomic , strong) UIView *topContrl;
@property (nonatomic , strong) UIView *bottomContrl;

@property (nonatomic , strong) UIButton *backButton;
@property (nonatomic , strong) UILabel *indexLabel;
@property (nonatomic , strong) UICollectionView *collectionView;

@property (nonatomic , assign) NSInteger pageIndex;
@end

@implementation ARTLocalReadViewController

+ (ARTLocalReadViewController *)lunch:(NSString *)bookID viewController:(UIViewController *)vc
{
    ARTLocalReadViewController *readVC = [[ARTLocalReadViewController alloc] init];
    readVC.bookID = bookID;
    [vc.navigationController pushViewController:readVC animated:YES];
    return readVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.hidden = YES;
    self.pageIndex = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrentationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    ARTDownLoadManager *manager = [[ARTDownLoadManager alloc] init];
    WS(weak)
    [manager getBookInformation:self.bookID completion:^(ARTBookLocalData *data) {
        weak.localData = data;
        [weak crareSubviews];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)crareSubviews
{
    NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey: UIPageViewControllerOptionSpineLocationKey];
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options: options];
    self.pageController.dataSource = self;
    self.pageController.view.frame = self.view.bounds;
    NSArray * viewControllers = @[[self viewControllerAtIndex:self.pageIndex]];
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.view addSubview:self.markView];
    
    self.indexLabel.text = [NSString stringWithFormat:@"1/%@",@(self.localData.photoList.count)];
    [self.collectionView reloadData];
    
    WS(weak)
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [weak displayMark];
    }];
    [self.view addGestureRecognizer:tap];
    self.view.userInteractionEnabled = YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSUInteger)indexOfViewController:(ARTLocalPageViewController *)viewController
{
    return  [self.localData.photoList indexOfObject:viewController.photoData];
}

- (ARTLocalPageViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (index >= self.localData.photoList.count)
    {
        return nil;
    }
    self.indexLabel.text = [NSString stringWithFormat:@"%@/%@",@(index + 1),@(self.localData.photoList.count)];
    self.pageIndex = index;
    [self.collectionView reloadData];
    ARTLocalPageViewController *page = [ARTLocalPageViewController lunch:self.localData.photoList[index]];
    return page;
}

#pragma mark LAYOUT
- (void)displayMark
{
    self.topContrl.bottom = 0;
    self.bottomContrl.top = self.markView.height;
    
    self.markView.hidden = NO;
    [UIView animateWithDuration:.3 animations:^{
        self.topContrl.top = 0;
        self.bottomContrl.bottom = self.markView.height;
    }];
}

- (void)hideMark
{
    [UIView animateWithDuration:.3 animations:^{
        self.topContrl.bottom = 0;
        self.bottomContrl.top = self.markView.height;
    } completion:^(BOOL finished) {
        self.markView.hidden = YES;
    }];
}

#pragma mark GET_SET
- (UIView *)markView
{
    if (!_markView)
    {
        _markView = [[UIView alloc] initWithFrame:self.view.bounds];
        _markView.backgroundColor = RGBCOLOR(100, 100, 100, .7);
        [_markView addSubview:self.topContrl];
        
        self.bottomContrl.bottom = _markView.height;
        [_markView addSubview:self.bottomContrl];
        
        WS(weak)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [weak hideMark];
        }];
        [_markView addGestureRecognizer:tap];
    }
    return _markView;
}

- (UIView *)topContrl
{
    if (!_topContrl)
    {
        _topContrl = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, NAVIGATION_HEIGH)];
        _topContrl.backgroundColor = RGBCOLOR(33, 33, 33, .5);
        
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
        [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.backButton.titleLabel.font = FONT_WITH_20;
        [self.backButton sizeToFit];
        self.backButton.left = 20;
        self.backButton.height = 50;
        self.backButton.centerY = _topContrl.height / 2;
        [self.backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [_topContrl addSubview:self.backButton];
        
        self.indexLabel = [[UILabel alloc] init];
        self.indexLabel.size = CGSizeMake(100, 20);
        self.indexLabel.center = CGPointMake(_topContrl.width / 2, _topContrl.height / 2);
        self.indexLabel.font = FONT_WITH_18;
        self.indexLabel.textColor = [UIColor whiteColor];
        self.indexLabel.textAlignment = NSTextAlignmentCenter;
        [_topContrl addSubview:self.indexLabel];
    }
    return _topContrl;
}

- (UIView *)bottomContrl
{
    if (!_bottomContrl)
    {
        _bottomContrl = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 500)];
        _bottomContrl.backgroundColor = RGBCOLOR(33, 33, 33, .5);
        
        CGSize size = CGSizeMake(_bottomContrl.width, _bottomContrl.height);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        [flowLayout setMinimumInteritemSpacing:0.5];
        [flowLayout setMinimumLineSpacing:1];
        [flowLayout setItemSize:CGSizeMake(size.width / 3 - 2, size.height / 2)];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) collectionViewLayout: flowLayout];
        self.collectionView.centerX = _bottomContrl.width / 2;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        [self.collectionView setBackgroundColor:[UIColor clearColor]];
        [self.collectionView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [self.collectionView registerClass:[ARTLocalMinCell class] forCellWithReuseIdentifier:@"localMinCell"];
        [_bottomContrl addSubview:self.collectionView];
        self.collectionView.userInteractionEnabled = YES;
    }
    return _bottomContrl;
}

#pragma mark ACTION
- (void)backAction
{
    [self _backItemClicked:nil];
}

- (void)deviceOrentationDidChange:(NSNotification *)notification
{
    self.markView.transform = CGAffineTransformIdentity;
    CGAffineTransform transform;
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft)
    {
        transform = CGAffineTransformMakeRotation(M_PI * 1.5);
    }
    else if([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight)
    {
        transform = CGAffineTransformMakeRotation(M_PI / 2);
    }
    else if([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown)
    {
        transform = CGAffineTransformMakeRotation(- M_PI);
    }
    else
    {
        transform = CGAffineTransformIdentity;
    }
    
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown)
    {
        self.markView.width = 768;
        self.markView.height = 1024;
    }
    else
    {
        self.markView.width = 1024;
        self.markView.height = 768;
    }
    self.topContrl.width = self.markView.width;
    self.bottomContrl.width = self.markView.width;
    self.bottomContrl.bottom = self.markView.height;
    self.indexLabel.centerX = self.topContrl.width / 2;
    self.collectionView.centerX = self.bottomContrl.width / 2;
    self.markView.center = self.view.center;
    
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    self.markView.transform = transform;
    [UIView commitAnimations];
}

#pragma mark DELEGATE
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    ARTLocalPageViewController *pageVC = (ARTLocalPageViewController *)viewController;
    NSInteger index = [self indexOfViewController: pageVC];
    index += 1;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self indexOfViewController:(ARTLocalPageViewController *)viewController];
    index -= 1;
    return [self viewControllerAtIndex:index];
}

#pragma mark DELEGAT_COLLECTION
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.localData.photoList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ARTLocalMinCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"localMinCell" forIndexPath:indexPath];
    cell.delegate = self;
    ARTBookPhotoData *data = self.localData.photoList[indexPath.row];
    [cell update:data isSelect:self.pageIndex == indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)cellDidSelect:(ARTBookPhotoData *)data
{
    self.pageIndex = [self.localData.photoList indexOfObject:data];
    [self.collectionView reloadData];
    [self.pageController setViewControllers:@[[self viewControllerAtIndex:self.pageIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

@end
