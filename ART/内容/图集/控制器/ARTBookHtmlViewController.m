//
//  ARTBookHtmlViewController.m
//  ART
//
//  Created by huangtie on 16/5/30.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBookHtmlViewController.h"
#import "ARTHtmlView.h"

@interface ARTBookHtmlViewController()

@property (nonatomic , strong) UIScrollView *scrollView;

@property (nonatomic , strong) ARTHtmlView *htmlView;

@property (nonatomic , copy) NSString *htmlText;

@end

@implementation ARTBookHtmlViewController

- (instancetype)initWithHtmlText:(NSString *)htmlText
{
    self = [super init];
    if (self)
    {
        self.htmlText = htmlText;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"图文详情";
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGH, self.view.width, self.view.height - NAVIGATION_HEIGH)];
    [self.view addSubview:self.scrollView];
    
    self.htmlView = [[ARTHtmlView alloc] initWithFrame:CGRectMake(10, 0, self.scrollView.width - 20, self.scrollView.height)];
    self.htmlView.content = self.htmlText;
    WS(weak)
    self.htmlView.loadFinishBlock = ^(CGFloat contrlHeight)
    {
        weak.htmlView.height = contrlHeight;
        weak.scrollView.contentSize = CGSizeMake(weak.scrollView.width, contrlHeight);
    };
    [self.scrollView addSubview:self.htmlView];
}

@end
