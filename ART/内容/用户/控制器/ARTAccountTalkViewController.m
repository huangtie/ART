//
//  ARTAccountTalkViewController.m
//  ART
//
//  Created by huangtie on 16/7/11.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTAccountTalkViewController.h"
#import "ARTTalkHeadView.h"
#import "ARTRequestUtil.h"
#import "ARTTalkFooterView.h"
#import "ARTTalkInputView.h"
#import "ARTTalkImageViewController.h"
#import "ARTTalkDetailViewController.h"
#import <UIScrollView+EmptyDataSet.h>

@interface ARTAccountTalkViewController ()<UITableViewDelegate,UITableViewDataSource,ARTTalkFooterViewDelegate,ARTTalkInputViewDelegate,ARTTalkHeadViewDelegate,DZNEmptyDataSetDelegate,
DZNEmptyDataSetSource>

@property (nonatomic , copy) NSString *userID;

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) NSMutableArray <ARTTalkData *> *dataList;

@property (nonatomic , strong) ARTTalkListParam *param;

@property (nonatomic , strong) ARTTalkInputView *inputView;

@end

@implementation ARTAccountTalkViewController

- (instancetype)initWithUserID:(NSString *)userID
{
    self = [super init];
    if (self)
    {
        self.userID = userID;
        self.title = @"TA的动态";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UICOLOR_ARGB(0xfffafafa);
    
    self.navigationBar.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UICOLOR_ARGB(0xfffafafa);
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self.view addSubview:self.tableView];
    
    [self requestDataList:YES completion:nil];
}

#pragma mark GET_SET
- (ARTTalkListParam *)param
{
    if (!_param)
    {
        _param = [[ARTTalkListParam alloc] init];
        _param.limit = ARTPAGESIZE;
        _param.talkAllLook = @"1";
        _param.userID = self.userID;
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


#pragma mark REQUEST
- (void)requestDataList:(BOOL)isRefresh completion:(void (^)())completion
{
    self.param.offset = isRefresh ? @"0" : STRING_FORMAT_ADC(@(self.dataList.count));
    WS(weak)
    [ARTRequestUtil requestTalkList:self.param completion:^(NSURLSessionDataTask *task, NSArray<ARTTalkData *> *datas) {
        if (completion)
        {
            completion();
        }
        if (isRefresh)
        {
            weak.dataList = [NSMutableArray array];
            if (datas.count >= ARTPAGESIZE.integerValue)
            {
                [weak.tableView addMJRefreshFooter:^{
                    [weak requestDataList:NO completion:nil];
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
    return self.dataList.count ? 1 : 0;
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

#pragma mark DELEGAT_DZNEMPTY
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    return [[NSAttributedString alloc] initWithString:@"TA没有发表的状态" attributes:@{NSFontAttributeName:FONT_WITH_18}];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return IMAGE_EMPTY_ONE;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return self.dataList && !self.dataList.count;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return 300;
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
