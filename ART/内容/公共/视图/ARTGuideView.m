//
//  ARTGuideView.m
//  ART
//
//  Created by huangtie on 16/7/1.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTGuideView.h"

@interface ARTGuideView()<UIScrollViewDelegate>

@property (nonatomic , strong) UIScrollView *scrollView;

@property (nonatomic , strong) UIPageControl *page;

@property (nonatomic , strong) UIImageView *tipsView;
@end

@implementation ARTGuideView

#define IMAGE_LIST @[@"guide_1",@"guide_2",@"guide_3",@"guide_4"]

+ (void)launchIn:(UIView *)view
{
    ARTGuideView *guideView= [[ARTGuideView alloc] init];
    [view addSubview:guideView];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [UIColor clearColor];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.contentSize = CGSizeMake(2 * self.width, self.height);
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        self.scrollView.bounces = NO;
        [self addSubview:self.scrollView];
        
        self.page = [[UIPageControl alloc] init];
        self.page.numberOfPages = IMAGE_LIST.count;
        self.page.centerX = self.width / 2;
        self.page.bottom = self.height - 100;
        [self addSubview:self.page];
        
        self.tipsView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"font_6"]];
        [self.tipsView sizeToFit];
        self.tipsView.right = self.width - 50;
        self.tipsView.top = 100;
        [self.tipsView.layer addAnimation:[self breatheAnimation] forKey:@"tip"];
        [self addSubview:self.tipsView];
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.width * IMAGE_LIST.count, self.scrollView.height);
        for (NSInteger i = 0; i < IMAGE_LIST.count; i ++)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.scrollView.width, 0, self.scrollView.width, self.scrollView.height)];
            imageView.image = [UIImage imageNamed:IMAGE_LIST[i]];
            [self.scrollView addSubview:imageView];
            
            if (i == IMAGE_LIST.count - 1)
            {
                UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
                [close setBackgroundImage:[UIImage imageNamed:@"font_3"] forState:UIControlStateNormal];
                [close addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
                [close sizeToFit];
                close.centerX = imageView.left + imageView.width / 2;
                close.bottom = imageView.height - 175;
                [self.scrollView addSubview:close];
            }
        }
    }
    return self;
}

- (void)closeAction
{
    [UIView animateWithDuration:.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [self removeFromSuperview];
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.page.currentPage = scrollView.contentOffset.x / (self.width - 10);
    self.tipsView.hidden = self.page.currentPage == IMAGE_LIST.count - 1;
}

- (CABasicAnimation *)breatheAnimation
{
    CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    pulse.duration = .5;
    pulse.repeatCount = MAXFLOAT;
    pulse.autoreverses = YES;
    pulse.fromValue = [NSNumber numberWithFloat:.92];
    pulse.toValue = [NSNumber numberWithFloat:1.08];
    return pulse;
}

@end
