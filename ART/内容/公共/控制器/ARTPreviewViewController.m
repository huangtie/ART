//
//  ARTPreviewViewController.m
//  ART
//
//  Created by huangtie on 16/6/7.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTPreviewViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ARTPreviewImageView()<UIScrollViewDelegate>

@property (nonatomic , strong) UIImageView *imageView;

@end

@implementation ARTPreviewImageView

- (instancetype)initWithFrame:(CGRect)frame asset:(ALAsset *)asset
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.contentInset = UIEdgeInsetsZero;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
        self.zoomScale = 1.0;
        self.minimumZoomScale = 1.0;
        self.maximumZoomScale = 4.0;
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        UIImage *fullScreenImage = [UIImage imageWithCGImage:[asset.defaultRepresentation fullResolutionImage] scale:[asset.defaultRepresentation scale] orientation:(UIImageOrientation)[asset.defaultRepresentation orientation]];
        UIImage *image = [fullScreenImage imageOfOrientationUp];
        self.imageView.image = image;
        [self addSubview:self.imageView];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap)];
        doubleTap.numberOfTapsRequired = 2;
        [self.imageView addGestureRecognizer:doubleTap];
        self.imageView.userInteractionEnabled = YES;
    }
    return self;
}

- (void)handleDoubleTap
{
    if (self.zoomScale > 1)
    {
        [self setZoomScale:1 animated:YES];
    }
    else
    {
        [self setZoomScale:4 animated:YES];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end

@interface ARTPreviewViewController ()<UIScrollViewDelegate>

@property (nonatomic , strong) UIView *topView;
@property (nonatomic , strong) UIView *bottomView;
@property (nonatomic , strong) UIButton *chooseButton;
@property (nonatomic , strong) UILabel *indexLabel;
@property (nonatomic, strong) UILabel *circle;

@property (nonatomic , strong) NSArray *assetsOld;
@property (nonatomic , strong) NSMutableArray *assetsNew;

@property (nonatomic , strong) UIScrollView *scroollView;

@property (nonatomic , assign) NSInteger visibleIndex;

@end

@implementation ARTPreviewViewController

- (instancetype)initWithAssets:(NSArray *)assets index:(NSInteger)index
{
    self = [super init];
    if (self)
    {
        self.visibleIndex = index;
        self.assetsOld = assets;
        self.assetsNew = [assets mutableCopy];
    }
    return self;
}

- (void)dealloc
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.hidden = YES;
    
    self.scroollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scroollView.backgroundColor = [UIColor blackColor];
    self.scroollView.pagingEnabled = YES;
    self.scroollView.delegate = self;
    [self.view addSubview:self.scroollView];
    
    WS(weak)
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        weak.topView.hidden = !weak.topView.hidden;
        weak.bottomView.hidden = weak.topView.hidden;
    }];
    [self.scroollView addGestureRecognizer:tap];
    self.scroollView.userInteractionEnabled = YES;
    
    for (NSInteger i = 0; i < self.assetsOld.count; i++)
    {
        ARTPreviewImageView *view = [[ARTPreviewImageView alloc] initWithFrame:self.scroollView.bounds asset:self.assetsOld[i]];
        view.left = i * view.width;
        [self.scroollView addSubview:view];
    }
    self.scroollView.contentSize = CGSizeMake(self.scroollView.width * self.assetsOld.count, self.scroollView.height);
    [self.view addSubview:self.topView];
    [self.view addSubview:self.bottomView];
    
    [self.scroollView setContentOffset:CGPointMake(self.visibleIndex * self.scroollView.width, 0)];
    [self layouyTitleAndItemd];
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

#pragma mark LAYOUT
- (void)layouyTitleAndItemd
{
    self.indexLabel.text = [NSString stringWithFormat:@"%@/%@",@(self.visibleIndex + 1),@(self.assetsOld.count)];
    self.chooseButton.selected = [self.assetsNew containsObject:self.assetsOld[self.visibleIndex]];
    self.circle.text = STRING_FORMAT_ADC(@(self.assetsNew.count));
}

#pragma mark GET_SET
- (UILabel *)indexLabel
{
    if (!_indexLabel)
    {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.font = FONT_WITH_20;
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.size = CGSizeMake(100, 20);
        _indexLabel.center = CGPointMake(self.topView.width / 2, self.topView.height / 2);
        _indexLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _indexLabel;
}

- (UIView *)topView
{
    if (!_topView)
    {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        _topView.backgroundColor = RGBCOLOR(100, 100, 100, .5);
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancel.titleLabel.font = FONT_WITH_18;
        [cancel sizeToFit];
        [cancel addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        cancel.left = 15;
        cancel.centerY = _topView.height / 2;
        [_topView addSubview:cancel];
        
        self.chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.chooseButton setBackgroundImage:[UIImage imageNamed:@"talk_icon_9"] forState:UIControlStateNormal];
        [self.chooseButton setBackgroundImage:[UIImage imageNamed:@"talk_icon_10"] forState:UIControlStateSelected];
        self.chooseButton.size = CGSizeMake(40, 40);
        [self.chooseButton addTarget:self action:@selector(chooseAction) forControlEvents:UIControlEventTouchUpInside];
        self.chooseButton.centerY = _topView.height / 2;
        self.chooseButton.right = _topView.width - 15;
        [_topView addSubview:self.chooseButton];
        
        [_topView addSubview:self.indexLabel];
    }
    return _topView;
}

- (UIView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
        _bottomView.bottom = self.view.height;
        _bottomView.backgroundColor = RGBCOLOR(100, 100, 100, .5);
        
        UIButton *finish = [UIButton buttonWithType:UIButtonTypeCustom];
        [finish setTitle:@"完成" forState:UIControlStateNormal];
        [finish setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        finish.titleLabel.font = FONT_WITH_20;
        [finish sizeToFit];
        [finish addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
        finish.right = _bottomView.width - 15;
        finish.centerY = _bottomView.height / 2;
        [_bottomView addSubview:finish];
        
        CGFloat side = 20;
        self.circle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, side, side)];
        self.circle.backgroundColor = UICOLOR_ARGB(0xff09bb07);
        self.circle.textColor = [UIColor whiteColor];
        [self.circle circleBorderWidth:0 borderColor:nil];
        self.circle.textAlignment = NSTextAlignmentCenter;
        self.circle.right = finish.left - 10;
        self.circle.centerY = _bottomView.height / 2 + 1;
        [_bottomView addSubview:self.circle];
    }
    return _bottomView;
}

#pragma mark ACTION
- (void)cancelAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)finishAction
{
    if (!self.assetsNew.count)
    {
        return;
    }
    
    if (self.chooseBlock)
    {
        self.chooseBlock(self.assetsNew);
    }
    
    UIViewController *vc = self.navigationController.viewControllers.firstObject;
    if ([vc isKindOfClass:[ARTAssetsViewController class]])
    {
        [vc dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)chooseAction
{
    ALAsset *asset = self.assetsOld[self.visibleIndex];
    BOOL ishave = [self.assetsNew containsObject:asset];
    if (ishave)
    {
        [self.assetsNew removeObject:asset];
    }
    else
    {
        [self.assetsNew addObject:asset];
    }
    [self layouyTitleAndItemd];
}

#pragma mark DELEGATE
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = (NSInteger)(scrollView.contentOffset.x / (scrollView.width - 10));
    
    self.visibleIndex = index;
    [self layouyTitleAndItemd];
}

@end
