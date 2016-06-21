//
//  ARTHomeNoticeViewController.m
//  ART
//
//  Created by huangtie on 16/6/21.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTHomeNoticeViewController.h"
#import "ARTHtmlView.h"

@interface ARTHomeNoticeViewController()<UIWebViewDelegate>

@property (nonatomic , strong) ARTNoticeData *noticeData;

@property (nonatomic , strong) UIWebView *webView;

@property (nonatomic , strong) ARTHtmlView *htmlView;

@property (nonatomic , strong) NSURLRequest *request;

@end

@implementation ARTHomeNoticeViewController

+ (ARTHomeNoticeViewController *)launchFromController:(ARTBaseViewController *)controller
                                                 data:(ARTNoticeData *)noticeData
{
    ARTHomeNoticeViewController *noticeVC = [[ARTHomeNoticeViewController alloc] init];
    noticeVC.noticeData = noticeData;
    [controller.navigationController pushViewController:noticeVC animated:YES];
    return noticeVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.noticeData.noticeCode.boolValue)
    {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGH, self.view.width, self.view.height - NAVIGATION_HEIGH)];
        [self.view addSubview:scrollView];
        
        self.htmlView = [[ARTHtmlView alloc] initWithFrame:scrollView.bounds];
        self.htmlView.content = self.noticeData.noticeContent;
        WS(weak)
        self.htmlView.loadFinishBlock = ^(CGFloat contrlHeight)
        {
            weak.htmlView.height = contrlHeight;
            scrollView.contentSize = CGSizeMake(scrollView.width, contrlHeight);
        };
        [scrollView addSubview:self.htmlView];
    }
    else
    {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGH, self.view.width, self.view.height - NAVIGATION_HEIGH)];
        self.request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.noticeData.noticeURL]];
        self.webView.scalesPageToFit = YES;
        self.webView.delegate = self;
        [self.view addSubview:self.webView];
        [self.webView loadRequest:self.request];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

}










@end
