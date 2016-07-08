//
//  ARTTalkImageViewController.m
//  ART
//
//  Created by huangtie on 16/7/6.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTTalkImageViewController.h"

@interface ARTTalkImageView()<UIScrollViewDelegate,UIActionSheetDelegate>

@property (nonatomic , strong) UIImageView *imageView;

@end

@implementation ARTTalkImageView

- (instancetype)initWithFrame:(CGRect)frame URL:(NSString *)URLString
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
        [self.imageView setImageWithURL:[NSURL URLWithString:URLString] placeholder:IMAGE_PLACEHOLDER_BOOK];
        [self addSubview:self.imageView];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap)];
        doubleTap.numberOfTapsRequired = 2;
        [self.imageView addGestureRecognizer:doubleTap];
        
        UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        [self.imageView addGestureRecognizer:tap];
        
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

- (void)longPressAction:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateBegan)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存到相册" otherButtonTitles:nil, nil];
        [actionSheet showInView:self];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        UIImageWriteToSavedPhotosAlbum(self.imageView.image, nil, @selector(savePhotosCompletion), nil);
    }
}

- (void)savePhotosCompletion
{

}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end

@interface ARTTalkImageViewController ()<UIScrollViewDelegate>

@property (nonatomic , strong) UIScrollView *scroollView;

@property (nonatomic , strong) UIView *topView;
@property (nonatomic , strong) UILabel *indexLabel;

@property (nonatomic , assign) NSInteger visibleIndex;

@property (nonatomic , strong) NSArray <NSString *> *URLS;

@end

@implementation ARTTalkImageViewController

+ (ARTTalkImageViewController *)launchViewController:(UIViewController *)viewController
                                                URLS:(NSArray <NSString *> *)URLS
                                               index:(NSInteger)index
{
    ARTTalkImageViewController *vc = [[ARTTalkImageViewController alloc] init];
    vc.URLS = URLS;
    vc.visibleIndex = index;
    [viewController.navigationController pushViewController:vc animated:YES];
    return vc;
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
    }];
    [self.scroollView addGestureRecognizer:tap];
    self.scroollView.userInteractionEnabled = YES;
    
    for (NSInteger i = 0; i < self.URLS.count; i++)
    {
        ARTTalkImageView *view = [[ARTTalkImageView alloc] initWithFrame:self.scroollView.bounds URL:self.URLS[i]];
        view.left = i * view.width;
        [self.scroollView addSubview:view];
    }
    self.scroollView.contentSize = CGSizeMake(self.scroollView.width * self.URLS.count, self.scroollView.height);
    [self.view addSubview:self.topView];
    
    [self.scroollView setContentOffset:CGPointMake(self.visibleIndex * self.scroollView.width, 0)];
    self.indexLabel.text = [NSString stringWithFormat:@"%@/%@",@(self.visibleIndex + 1),@(self.URLS.count)];
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
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_HEIGH)];
        _topView.backgroundColor = RGBCOLOR(100, 100, 100, .5);
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancel setTitle:@"返回" forState:UIControlStateNormal];
        [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancel.titleLabel.font = FONT_WITH_18;
        [cancel addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        cancel.left = 15;
        cancel.height = 50;
        cancel.width = 80;
        cancel.centerY = _topView.height / 2;
        [_topView addSubview:cancel];
        
        [_topView addSubview:self.indexLabel];
    }
    return _topView;
}

#pragma mark ACTION
- (void)cancelAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark DELEGATE
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = (NSInteger)(scrollView.contentOffset.x / (scrollView.width - 10));
    
    self.visibleIndex = index;
    self.indexLabel.text = [NSString stringWithFormat:@"%@/%@",@(self.visibleIndex + 1),@(self.URLS.count)];
}

@end
