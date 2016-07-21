//
//  ARTAccountViewController.m
//  ART
//
//  Created by huangtie on 16/7/11.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTAccountViewController.h"
#import "QHPageContainer.h"
#import "QHPageContainerControllerProtocol.h"
#import "ARTTalkWallpaper.h"
#import "ARTAccountDetailViewController.h"
#import "ARTAccountTalkViewController.h"

@interface ARTAccountViewController ()<QHPageContainerDelegate>

@property (nonatomic , copy) NSString *userID;

@property (nonatomic , strong) ARTUserInfo *info;

@property (nonatomic, strong) QHPageContainer *pageContainer;

@property (nonatomic, strong) NSArray<UIViewController <QHPageContainerControllerProtocol> *> *viewControllers;

@property (nonatomic, strong) ARTTalkWallpaper *wallPaper;

@property (nonatomic, strong) ARTAccountDetailViewController *detailVC;

@property (nonatomic, strong) ARTAccountTalkViewController *talkVC;
@end

@implementation ARTAccountViewController

+ (ARTAccountViewController *)launchViewController:(UIViewController *)viewController
                                            userID:(NSString *)userID
                                              info:(ARTUserInfo *)info
{
    ARTAccountViewController *vc = [[ARTAccountViewController alloc] init];
    vc.userID = userID;
    vc.info = info;
    [viewController.navigationController pushViewController:vc animated:YES];
    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.detailVC = [[ARTAccountDetailViewController alloc] initWithUserID:self.userID];
    self.talkVC = [[ARTAccountTalkViewController alloc] initWithUserID:self.userID];
    self.viewControllers = @[self.detailVC, self.talkVC];
    
    NSMutableArray <NSString *> *tabTitles = [NSMutableArray array];
    [_viewControllers enumerateObjectsUsingBlock:^(UIViewController<QHPageContainerControllerProtocol> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addChildViewController:obj];
        [tabTitles addObject:obj.title];
    }];
    
    self.pageContainer = [[QHPageContainer alloc] initWithFrame:self.view.bounds andBackImageName:@"" andFrontView:self.wallPaper];
    [self.pageContainer setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    self.pageContainer.delegate = self;
    [self.pageContainer setAnchorHeight:0];
    [self.pageContainer updateContentWithTitles:[tabTitles copy]];
    [self.pageContainer updateContentWithControllers:_viewControllers];
    [self.view addSubview:self.pageContainer];
    
    [self layoutHead];
    
    WS(weak)
    self.wallPaper.refreshBlock = ^()
    {
        if ([weak.pageContainer getCurrentPageIndex] == 0)
        {
            [weak.detailVC requestWithInfo:^(ARTUserInfo *info) {
                weak.info = info;
                [weak layoutHead];
                [weak.wallPaper endLoad];
            }];
        }
        if ([weak.pageContainer getCurrentPageIndex] == 1)
        {
            [weak.talkVC requestDataList:YES completion:^{
                [weak.wallPaper endLoad];
            }];
        }
    };
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.view addSubview:self.navigationBar];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view addSubview:self.navigationBar];
}

#pragma mark LAYOUT
- (void)layoutHead
{
    [self.wallPaper upDateData:self.info];
}

#pragma mark GET_SET
- (ARTTalkWallpaper *)wallPaper
{
    if (!_wallPaper)
    {
        _wallPaper = [[ARTTalkWallpaper alloc] init];
    }
    return _wallPaper;
}

#pragma mark DELEGATE_PAGECONTAINER
- (void)pageContainer:(QHPageContainer *)container verticalScroll:(CGFloat)offset
{
    [self.wallPaper upDateScale:offset];
}

- (void)pageContainer:(QHPageContainer *)container willDecelerate:(BOOL)decelerate
{
    if(self.wallPaper.loadImageView.superview == self.view)
    {
        [self.wallPaper beginAnimotion];
    }
}

- (void)pageContainer:(QHPageContainer *)container selectIndex:(NSInteger)index
{
    if ([_viewControllers[index] respondsToSelector:@selector(viewcontroller:didSelectedIndex:)])
    {
        [_viewControllers[index] viewcontroller:self didSelectedIndex:index];
    }
}


@end
