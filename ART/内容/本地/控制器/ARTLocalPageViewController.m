//
//  ARTLocalPageViewController.m
//  ART
//
//  Created by huangtie on 16/6/8.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTLocalPageViewController.h"

@interface ARTLocalPageViewController()<UIScrollViewDelegate>

@property (nonatomic , strong) UIImageView *imageView;

@property (nonatomic , strong) UIScrollView *scrollView;

@end

@implementation ARTLocalPageViewController

+ (ARTLocalPageViewController *)lunch:(ARTBookPhotoData *)photoData
{
    ARTLocalPageViewController *pageVC = [[ARTLocalPageViewController alloc] init];
    pageVC.photoData = photoData;
    return pageVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrentationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    self.scrollView.maximumZoomScale = 8;
    self.scrollView.minimumZoomScale = 1;
    [self.view addSubview:self.scrollView];
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.scrollView.bounds];
    self.imageView.clipsToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    if ([[NSFileManager defaultManager] fileExistsAtPath:FILE_PATH_PIC(self.photoData.saveURL)])
    {
        self.imageView.image = [UIImage imageWithContentsOfFile:FILE_PATH_PIC(self.photoData.saveURL)];
    }
    [self.scrollView addSubview:self.imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTouchAction)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:tap];
    self.scrollView.userInteractionEnabled = YES;
    
    [self deviceOrentationDidChange:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark ACTION
- (void)doubleTouchAction
{
    if (self.scrollView.zoomScale > 1)
    {
        //原始大小
        [self.scrollView setZoomScale:1 animated:YES];
    }
    else
    {
        //放大3倍
        [self.scrollView setZoomScale:8 animated:YES];
    }
}

- (void)deviceOrentationDidChange:(NSNotification *)notification
{
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown)
    {
        self.view.width = 768;
        self.view.height = 1024;
    }
    else
    {
        self.view.width = 1024;
        self.view.height = 768;
    }

    self.view.left = 0;
    self.view.top = 0;
    self.scrollView.size = self.view.size;
    self.scrollView.center = CGPointMake(self.view.width / 2, self.view.height / 2);
    self.imageView.size = self.scrollView.size;
}

#pragma mark DELEGATE
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return  self.imageView;
}

@end
