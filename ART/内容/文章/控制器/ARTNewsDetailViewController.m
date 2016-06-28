//
//  ARTNewsDetailViewController.m
//  ART
//
//  Created by huangtie on 16/6/28.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTNewsDetailViewController.h"
#import "ARTHtmlView.h"
#import "ARTRequestUtil.h"

@interface ARTNewsDetailViewController()

@property (nonatomic , copy) NSString *newsID;

@property (nonatomic , strong) UIScrollView *scrollView;

@property (nonatomic , strong) UILabel *titleLabel;

@property (nonatomic , strong) UILabel *timeLable;

@property (nonatomic , strong) UILabel *fromLabel;

@property (nonatomic , strong) ARTHtmlView *htmlView;
@end

@implementation ARTNewsDetailViewController

+ (ARTNewsDetailViewController *)launchViewController:(UIViewController *)viewController
                                               newsID:(NSString *)newsID
{
    ARTNewsDetailViewController *vc = [[ARTNewsDetailViewController alloc] init];
    vc.newsID = newsID;
    [viewController.navigationController pushViewController:vc animated:YES];
    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"文章详情";
    
    [self requestNewsDetail];
}

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGH + 0.5, self.view.width, self.view.height - NAVIGATION_HEIGH)];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.size = CGSizeMake(self.view.width - 100, 60);
        self.titleLabel.top = 30;
        self.titleLabel.centerX = self.view.width / 2;
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.font = FONT_WITH_21;
        self.titleLabel.textColor = UICOLOR_ARGB(0xff333333);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_scrollView addSubview:self.titleLabel];
        
        self.fromLabel = [[UILabel alloc] init];
        self.fromLabel.size = CGSizeMake(300, 20);
        self.fromLabel.left = self.titleLabel.left;
        self.fromLabel.top = self.titleLabel.bottom + 10;
        self.fromLabel.font = FONT_WITH_16;
        self.fromLabel.textColor = UICOLOR_ARGB(0xff666666);
        [_scrollView addSubview:self.fromLabel];
        
        self.timeLable = [[UILabel alloc] init];
        self.timeLable.size = CGSizeMake(200, 20);
        self.timeLable.top = self.titleLabel.bottom + 10;
        self.timeLable.right = self.titleLabel.right;
        self.timeLable.font = FONT_WITH_16;
        self.timeLable.textColor = UICOLOR_ARGB(0xff666666);
        self.timeLable.textAlignment = NSTextAlignmentRight;
        [_scrollView addSubview:self.timeLable];
        
        self.htmlView = [[ARTHtmlView alloc] init];
        self.htmlView.width = self.view.width - 40;
        self.htmlView.height = self.scrollView.height - self.fromLabel.bottom - 20;
        self.htmlView.top = self.fromLabel.bottom + 20;
        self.htmlView.left = 20;
        [_scrollView addSubview:self.htmlView];
    }
    return _scrollView;
}

#pragma mark LAYOUT
- (void)layoutSubviews:(ARTNewsData *)data
{
    self.titleLabel.text = data.newsTitle;
    
    self.timeLable.text = [NSString timeString:data.newsTime dateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    self.fromLabel.text = STRING_FORMAT(@"来源: ", data.newsFrom);
    
    self.htmlView.content = data.newsContent;
    WS(weak)
    self.htmlView.loadFinishBlock = ^(CGFloat contrlHeight)
    {
        weak.htmlView.height = contrlHeight;
        weak.scrollView.contentSize = CGSizeMake(weak.scrollView.width, weak.htmlView.bottom + 20);
    };
}

#pragma mark REQUEST
- (void)requestNewsDetail
{
    [self displayHUD];
    WS(weak)
    [ARTRequestUtil requestNewsDetail:self.newsID completion:^(NSURLSessionDataTask *task, ARTNewsData *data) {
        [weak hideHUD];
        [weak.view addSubview:weak.scrollView];
        [weak layoutSubviews:data];
    } failure:^(ErrorItemd *error) {
        [weak hideHUD];
        [weak.view displayTostError:error.errMsg];
    }];
}























@end
