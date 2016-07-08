//
//  ARTTalkDetailViewController.m
//  ART
//
//  Created by huangtie on 16/7/6.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTTalkDetailViewController.h"
#import "ARTTalkHeadView.h"
#import "ARTRequestUtil.h"
#import "ARTTalkInputView.h"
#import "ARTTalkImageViewController.h"
#import "ARTTalkDetailSection.h"
#import "ARTTalkDetailCell.h"

@interface ARTTalkDetailViewController ()<UITableViewDelegate,UITableViewDataSource,ARTTalkInputViewDelegate,ARTTalkHeadViewDelegate,ARTTalkDetailCellDelegate,ARTTalkDetailSectionDelegate>

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) ARTTalkHeadView *headView;

@property (nonatomic , strong) ARTTalkInputView *inputView;

@property (nonatomic , strong) ARTTalkData *talkData;

@property (nonatomic , strong) NSString *talkID;

@property (nonatomic , strong) NSMutableArray <ARTTalkComData *> *commentList;

@end

@implementation ARTTalkDetailViewController

+ (ARTTalkDetailViewController *)launchViewController:(UIViewController *)viewController
                                         talkID:(NSString *)talkID
{
    ARTTalkDetailViewController *vc = [[ARTTalkDetailViewController alloc] init];
    vc.talkID = talkID;
    [viewController.navigationController pushViewController:vc animated:YES];
    return vc;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"详情";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGH + 0.5, self.view.width, self.view.height - NAVIGATION_HEIGH - self.inputView.height) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UICOLOR_ARGB(0xfffafafa);
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.inputView];
    
    WS(weak)
    [self.tableView addMJRefreshHeader:^{
        [weak requstCommentList:YES];
    }];
    
    [self requestWithDetail];
}

#pragma mark LAYOUT
- (UIView *)sectionView:(ARTTalkComData *)data
{
    UIView *section = [[UIView alloc] init];
    section.backgroundColor = [UIColor clearColor];
    
    return section;
}

#pragma mark GET_SET
- (ARTTalkHeadView *)headView
{
    if (!_headView)
    {
        _headView = [[ARTTalkHeadView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"head"];
        _headView.delegate = self;
    }
    return _headView;
}

- (ARTTalkInputView *)inputView
{
    if (!_inputView)
    {
        _inputView = [[ARTTalkInputView alloc] init];
        _inputView.bottom = self.view.height;
        _inputView.delegate = self;
        
        ARTSendTalkComParam *param = [[ARTSendTalkComParam alloc] init];
        param.talkID = self.talkID;
        _inputView.param = param;
        _inputView.textField.placeholder = @"评论:";
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
        self.inputView.bottom = self.view.height;
    }];
}

#pragma mark REQUEST
- (void)requstCommentList:(BOOL)isRefresh
{
    ARTCustomParam *param = [[ARTCustomParam alloc] init];
    param.talkID = self.talkID;
    param.limit = ARTPAGESIZE;
    param.offset = isRefresh ? @"0" : STRING_FORMAT_ADC(@(self.commentList.count));
    WS(weak)
    [ARTRequestUtil requestTalkComList:param completion:^(NSURLSessionDataTask *task, NSArray<ARTTalkComData *> *datas) {
        if (isRefresh)
        {
            weak.commentList = [NSMutableArray array];
            [weak.tableView.mj_header endRefreshing];
            if (datas.count >= ARTPAGESIZE.integerValue)
            {
                [weak.tableView addMJRefreshFooter:^{
                    [weak requstCommentList:NO];
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
        [weak.commentList addObjectsFromArray:datas];
        [weak.tableView reloadData];
    } failure:^(ErrorItemd *error) {
        if (isRefresh)
        {
            [weak.tableView.mj_header endRefreshing];
        }
        else
        {
            [weak.tableView.mj_footer endRefreshing];
        }
    }];
}

- (void)requestWithDetail
{
    WS(weak)
    [ARTRequestUtil requestTalkDetail:self.talkID completion:^(NSURLSessionDataTask *task, ARTTalkData *data) {
        [weak requstCommentList:YES];
        [weak hideHUD];
        weak.talkData = data;
        [weak.headView bindingWithData:data index:0];
        weak.tableView.tableHeaderView = weak.headView;
        [weak.tableView reloadData];
    } failure:^(ErrorItemd *error) {
        [weak hideHUD];
    }];
}

- (void)requestZan:(NSString *)talkID
{
    WS(weak)
    [ARTRequestUtil requestZanTalk:talkID completion:^(NSURLSessionDataTask *task) {
        
        NSPredicate *zanPre = [NSPredicate predicateWithFormat:@"userID == %@", [ARTUserManager sharedInstance].userinfo.userInfo.userID];
        NSArray *zanResult = [weak.talkData.zanList filteredArrayUsingPredicate:zanPre];
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
        [array addObjectsFromArray:weak.talkData.zanList];
        weak.talkData.zanList = array;
        weak.talkData.zanCount = STRING_FORMAT_ADC(@(weak.talkData.zanCount.integerValue + 1));
        [weak.headView bindingWithData:weak.talkData index:0];
        weak.tableView.tableHeaderView = weak.headView;
        [weak.tableView reloadData];
    } failure:^(ErrorItemd *error) {
        [weak.view displayTostError:error.errMsg];
    }];
}

- (void)requestSendComment:(ARTSendTalkComParam *)param
{
    [self.view endEditing:YES];
    WS(weak)
    [ARTRequestUtil requestSendTalkCom:param completion:^(NSURLSessionDataTask *task) {
        [weak.view displayTostSuccess:@"评论成功"];
        weak.inputView.textField.text = @"";
        [weak requstCommentList:YES];
    } failure:^(ErrorItemd *error) {
        [weak.view displayTostError:error.errMsg];
    }];
}

#pragma mark DELEGATE_TABLE
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.commentList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentList[section].replays.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idetifar = @"detailcell";
    ARTTalkDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:idetifar];
    if (!cell)
    {
        cell = [[ARTTalkDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idetifar];
        cell.delegate = self;
    }
    [cell bindingWithData:self.commentList[indexPath.section].replays[indexPath.row] comID:self.commentList[indexPath.section].comID];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ARTTalkDetailCell cellHeight:self.commentList[indexPath.section].replays[indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [ARTTalkDetailSection viewHeight:self.commentList[section]];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ARTTalkDetailSection *sectionView = [ARTTalkDetailSection crate:self.commentList[section]];
    sectionView.delegate = self;
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

#pragma mark DELEGATE_HEADER
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
    [self requestZan:self.talkID];
}

- (void)headDidTouchDelete:(ARTTalkData *)data
{

}

- (void)headDidTouchImage:(ARTTalkData *)data index:(NSInteger)index
{
    [ARTTalkImageViewController launchViewController:self URLS:data.talkImages index:index];
}

#pragma mark DELEGATE_INPUT
- (void)inputDidTouchSend:(ARTSendTalkComParam *)param
{
    [self requestSendComment:param];
}

#pragma mark DELEGATE_CELL
- (void)replayCellWillReplay:(ARTSendTalkComParam *)param
{
    WS(weak)
    [[ARTUserManager sharedInstance] isLogin:self logined:^(ARTUserData *userInfo) {
        param.talkID = weak.talkID;
        [weak.inputView beginInput:param];
    }];
}

#pragma mark DELEGATE_SECTION
- (void)sectionWillReplay:(ARTSendTalkComParam *)param
{
    WS(weak)
    [[ARTUserManager sharedInstance] isLogin:self logined:^(ARTUserData *userInfo) {
        param.talkID = weak.talkID;
        [weak.inputView beginInput:param];
    }];
}











@end
