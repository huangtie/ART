//
//  ARTTalkViewController.m
//  ART
//
//  Created by huangtie on 16/7/4.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTTalkViewController.h"
#import "ARTTalkSendViewController.h"
#import "ARTTalkHeadView.h"
#import "ARTRequestUtil.h"
#import "ARTTalkFooterView.h"
#import "ARTTalkInputView.h"
#import "ARTTalkImageViewController.h"
#import "ARTTalkDetailViewController.h"
#import "ARTTalkWallpaper.h"

@interface ARTTalkViewController ()<UITableViewDelegate,UITableViewDataSource,ARTTalkFooterViewDelegate,ARTTalkInputViewDelegate,ARTTalkHeadViewDelegate>

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) UISegmentedControl *segmented;

@property (nonatomic , strong) NSMutableArray <ARTTalkData *> *dataList;

@property (nonatomic , strong) ARTTalkListParam *param;

@property (nonatomic , strong) ARTTalkInputView *inputView;

@property (nonatomic , strong) ARTTalkWallpaper *wallpaper;

@end

@implementation ARTTalkViewController

+ (ARTTalkViewController *)launchViewController:(UIViewController *)viewController
{
    ARTTalkViewController *vc = [[ARTTalkViewController alloc] init];
    [viewController.navigationController pushViewController:vc animated:YES];
    return vc;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOrLogout) name:NOTIFICATION_ACCOUNT_LOGINSUCCSES object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOrLogout) name:NOTIFICATION_ACCOUNT_DIDLOGOUT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(talkDidSend) name:NOTIFICATION_TALK_DIDSEND object:nil];
    
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitle:@"发表状态" forState:UIControlStateNormal];
    [sendButton setTitleColor:COLOR_YSYC_ORANGE forState:UIControlStateNormal];
    sendButton.titleLabel.font = FONT_WITH_18;
    [sendButton addTarget:self action:@selector(_rightItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    
    self.segmented = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 290, 35)];
    [self.segmented insertSegmentWithTitle:@"公共动态" atIndex:0 animated:NO];
    [self.segmented insertSegmentWithTitle:@"关注动态" atIndex:1 animated:NO];
    self.segmented.selectedSegmentIndex = 0;
    [self.segmented setTitleTextAttributes:@{NSFontAttributeName:FONT_WITH_17,NSForegroundColorAttributeName:UICOLOR_ARGB(0xff333333)} forState:UIControlStateNormal];
    [self.segmented setTitleTextAttributes:@{NSFontAttributeName:FONT_WITH_17,NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    self.segmented.tintColor = COLOR_YSYC_ORANGE;
    [self.segmented addTarget:self action:@selector(segmentedDidChange) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segmented;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.tableHeaderView = self.wallpaper;
    [self.view addSubview:self.tableView];
    
    WS(weak)
    self.wallpaper.refreshBlock = ^()
    {
        [weak requestDataList:YES];
    };
    [self.wallpaper beginAnimotion];
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

#pragma mark GET_SET
- (ARTTalkWallpaper *)wallpaper
{
    if (!_wallpaper)
    {
        _wallpaper = [[ARTTalkWallpaper alloc] init];
        if ([[ARTUserManager sharedInstance] isLogin])
        {
            [_wallpaper upDateData:[ARTUserManager sharedInstance].userinfo.userInfo];
        }
    }
    return _wallpaper;
}

- (ARTTalkListParam *)param
{
    if (!_param)
    {
        _param = [[ARTTalkListParam alloc] init];
        _param.limit = ARTPAGESIZE;
        _param.talkAllLook = @"1";
    }
    return _param;
}

- (ARTTalkInputView *)inputView
{
    if (!_inputView)
    {
        _inputView = [[ARTTalkInputView alloc] init];
        _inputView.top = self.view.height;
        _inputView.delegate = self;
        [self.view addSubview:_inputView];
    }
    return _inputView;
}

#pragma mark ACTION
- (void)_rightItemClicked:(id)sender
{
    WS(weak)
    [[ARTUserManager sharedInstance] isLogin:self logined:^(ARTUserData *userInfo) {
        [ARTTalkSendViewController launchViewController:weak];
    }];
    
}

- (void)segmentedDidChange
{
    NSInteger index = self.segmented.selectedSegmentIndex;
    if (index == 1)
    {
        WS(weak)
        [[ARTUserManager sharedInstance] isLogin:self logined:^(ARTUserData *userInfo) {
            weak.param.talkAllLook = @"0";
            weak.param.userID = [ARTUserManager sharedInstance].userinfo.userInfo.userID;
            [weak.wallpaper beginAnimotion];
        }];
    }
    else
    {
        self.param.talkAllLook = @"1";
        [self.wallpaper beginAnimotion];
    }
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:.3 animations:^{
        self.inputView.bottom = self.view.height - rect.size.height;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:.3 animations:^{
        self.inputView.top = self.view.height;
    }];
}

- (void)loginOrLogout
{
    if ([[ARTUserManager sharedInstance] isLogin])
    {
        [self.wallpaper upDateData:[ARTUserManager sharedInstance].userinfo.userInfo];
    }
    else
    {
        [self.wallpaper upDateData:nil];
    }
}

- (void)talkDidSend
{
    [self.wallpaper beginAnimotion];
}

#pragma mark REQUEST
- (void)requestDataList:(BOOL)isRefresh
{
    self.param.offset = isRefresh ? @"0" : STRING_FORMAT_ADC(@(self.dataList.count));
    self.param.userID = @"";
    WS(weak)
    [ARTRequestUtil requestTalkList:self.param completion:^(NSURLSessionDataTask *task, NSArray<ARTTalkData *> *datas) {
        if (isRefresh)
        {
            weak.dataList = [NSMutableArray array];
            [weak.wallpaper endLoad];
            if (datas.count >= ARTPAGESIZE.integerValue)
            {
                [weak.tableView addMJRefreshFooter:^{
                    [weak requestDataList:NO];
                }];
            }
        }
        else
        {
            [weak.tableView.mj_footer endRefreshing];
            if (!datas.count)
            {
                [weak.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [weak.dataList addObjectsFromArray:datas];
        [weak.tableView reloadData];
    } failure:^(ErrorItemd *error) {
        if (isRefresh)
        {
            [weak.wallpaper endLoad];
        }
        else
        {
            [weak.tableView.mj_footer endRefreshing];
        }
    }];
}

- (void)requestSendComment:(ARTSendTalkComParam *)param
{
    [self.view endEditing:YES];
    WS(weak)
    [ARTRequestUtil requestSendTalkCom:param completion:^(NSURLSessionDataTask *task) {
        [weak.view displayTostSuccess:@"评论成功"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"talkID == %@", param.talkID];
        NSArray *results = [weak.dataList filteredArrayUsingPredicate:predicate];
        if (results.count)
        {
            ARTTalkData *data = results.firstObject;
            if (!param.replayID.length)
            {
                ARTTalkComData *comData = [[ARTTalkComData alloc] init];
                comData.comNick = [ARTUserManager sharedInstance].userinfo.userInfo.userNick;
                comData.comText = param.text;
                NSMutableArray *array = [NSMutableArray array];
                [array addObject:comData];
                [array addObjectsFromArray:data.comList];
                data.comList = array;
            }
            else
            {
                NSPredicate *preReplay = [NSPredicate predicateWithFormat:@"comID == %@", param.replayID];
                NSArray *resultReplay = [data.comList filteredArrayUsingPredicate:preReplay];
                if (resultReplay.count)
                {
                    ARTTalkComData *comData = resultReplay.firstObject;
                    ARTTalkReplayData *repalyData = [[ARTTalkReplayData alloc] init];
                    repalyData.replayNick = [ARTUserManager sharedInstance].userinfo.userInfo.userNick;
                    repalyData.acceptNick = param.replayNick;
                    repalyData.replayText = param.text;
                    NSMutableArray *array = [NSMutableArray array];
                    [array addObject:repalyData];
                    [array addObjectsFromArray:comData.replays];
                    comData.replays = array;
                }
            }
            [weak.tableView reloadData];
        }
    } failure:^(ErrorItemd *error) {
        [weak.view displayTostError:error.errMsg];
    }];
}

- (void)requestZan:(NSString *)talkID
{
    WS(weak)
    [ARTRequestUtil requestZanTalk:talkID completion:^(NSURLSessionDataTask *task) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"talkID == %@", talkID];
        NSArray *results = [weak.dataList filteredArrayUsingPredicate:predicate];
        if (results.count)
        {
            ARTTalkData *data = results.firstObject;
            
            NSPredicate *zanPre = [NSPredicate predicateWithFormat:@"userID == %@", [ARTUserManager sharedInstance].userinfo.userInfo.userID];
            NSArray *zanResult = [data.zanList filteredArrayUsingPredicate:zanPre];
            if (zanResult.count)
            {
                [weak.view displayTostError:@"重复点赞"];
                return;
            }
            
            ARTUserInfo *info = [[ARTUserInfo alloc] init];
            info.userNick = [ARTUserManager sharedInstance].userinfo.userInfo.userNick;
            info.userID = [ARTUserManager sharedInstance].userinfo.userInfo.userID;
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:info];
            [array addObjectsFromArray:data.zanList];
            data.zanList = array;
            data.zanCount = STRING_FORMAT_ADC(@(data.zanCount.integerValue + 1));
            
            [weak.tableView reloadData];
        }
    } failure:^(ErrorItemd *error) {
        [weak.view displayTostError:error.errMsg];
    }];
}

#pragma mark DELEGATE
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idetifer = @"talkcell";
    ARTTalkHeadView *cell = [tableView dequeueReusableCellWithIdentifier:idetifer];
    if (!cell)
    {
        cell = [[ARTTalkHeadView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idetifer];
        cell.delegate = self;
    }
    [cell bindingWithData:self.dataList[indexPath.section] index:indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ARTTalkHeadView viewHeight:self.dataList[indexPath.section]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [ARTTalkFooterView viewHeight:self.dataList[section]];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    ARTTalkFooterView *footer = [ARTTalkFooterView crate:self.dataList[section] index:section];
    footer.delegate = self;
    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [ARTTalkDetailViewController launchViewController:self talkID:self.dataList[indexPath.section].talkID];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.wallpaper upDateScale:scrollView.contentOffset.y];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(self.wallpaper.loadImageView.superview == self.view)
    {
        [self.wallpaper beginAnimotion];
    }
}

#pragma mark DELEGATE_COMMENT
- (void)commentReplayMember:(ARTSendTalkComParam *)param
{
    WS(weak)
    [[ARTUserManager sharedInstance] isLogin:self logined:^(ARTUserData *userInfo) {
        [weak.inputView beginInput:param];
    }];
}

- (void)commentDidClickMore:(NSString *)talkID
{
    [ARTTalkDetailViewController launchViewController:self talkID:talkID];
}

#pragma mark DELEGATE_INPUT
- (void)inputDidTouchSend:(ARTSendTalkComParam *)param
{
    [self requestSendComment:param];
}

#pragma mark DELEGATE_CELL
- (void)headDidTouchComment:(ARTTalkData *)data
{
    WS(weak)
    [[ARTUserManager sharedInstance] isLogin:self logined:^(ARTUserData *userInfo) {
        ARTSendTalkComParam *param = [[ARTSendTalkComParam alloc] init];
        param.talkID = data.talkID;
        [weak.inputView beginInput:param];
    }];
}

- (void)headDidTouchZan:(ARTTalkData *)data
{
    WS(weak)
    [[ARTUserManager sharedInstance] isLogin:self logined:^(ARTUserData *userInfo) {
        [weak requestZan:data.talkID];
    }];
}

- (void)headDidTouchDelete:(ARTTalkData *)data
{

}

- (void)headDidTouchImage:(ARTTalkData *)data index:(NSInteger)index
{
    [ARTTalkImageViewController launchViewController:self URLS:data.talkImages index:index];
}






@end
