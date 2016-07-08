//
//  ARTAccountListViewController.m
//  ART
//
//  Created by huangtie on 16/7/8.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTAccountListViewController.h"
#import "ARTAccountFollowCell.h"
#import "ARTRequestUtil.h"

@interface ARTAccountListViewController ()<UITableViewDelegate,UITableViewDataSource,ARTAccountFollowCellDelegate>

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) NSMutableArray <ARTUserInfo *> *dataList;

@property (nonatomic , strong) UITextField *textField;

@property (nonatomic , strong) UIView *headerView;

@property (nonatomic , strong) ARTCustomParam *param;
@end

@implementation ARTAccountListViewController

+ (ARTAccountListViewController *)launchViewController:(UIViewController *)viewController
{
    ARTAccountListViewController *vc = [[ARTAccountListViewController alloc] init];
    [viewController.navigationController pushViewController:vc animated:YES];
    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"用户列表";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeText) name:UITextFieldTextDidChangeNotification object:nil];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGH + .5, self.view.width, self.view.height - NAVIGATION_HEIGH) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = UICOLOR_ARGB(0xffe5e5e5);
    self.tableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.tableView];
    
    WS(weak)
    [self.tableView addMJRefreshHeader:^{
        [weak requestWithData:YES];
    }];
    
    [self displayHUD];
    [self requestWithData:YES];
}

#pragma mark GET_SET
- (ARTCustomParam *)param
{
    if (!_param)
    {
        _param = [[ARTCustomParam alloc] init];
        _param.limit = ARTPAGESIZE;
    }
    return _param;
}

- (UIView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        UIView *bg = [[UIView alloc] init];
        bg.size = CGSizeMake(_headerView.width - 60, 55);
        bg.center = CGPointMake(_headerView.width / 2, _headerView.height / 2);
        bg.backgroundColor = UICOLOR_ARGB(0xfff5f5f5);
        [bg clipRadius:4 borderWidth:0 borderColor:nil];
        [_headerView addSubview:bg];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"book_icon_8"]];
        [imageView sizeToFit];
        imageView.right = bg.width - 15;
        imageView.centerY = bg.height / 2;
        [bg addSubview:imageView];
        
        self.textField = [[UITextField alloc] init];
        self.textField.size = CGSizeMake(600, 35);
        self.textField.left = 15;
        self.textField.centerY = bg.height / 2;
        self.textField.borderStyle = UITextBorderStyleNone;
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textField.font = FONT_WITH_18;
        self.textField.textColor = UICOLOR_ARGB(0xff333333);
        self.textField.placeholder = @"请输入搜索关键字";
        [bg addSubview:self.textField];
        
    }
    return _headerView;
}

#pragma mark ACTION
- (void)textFieldDidChangeText
{
    [self requestWithData:YES];
}

#pragma mark REQUEST
- (void)requestWithData:(BOOL)isRefresh
{
    if (isRefresh)
    {
        self.param.offset = @"0";
    }
    else
    {
        self.param.offset = STRING_FORMAT_ADC(@(self.dataList.count));
    }
    self.param.key = self.textField.text;
    WS(weak)
    [ARTRequestUtil requestMemberList:self.param completion:^(NSURLSessionDataTask *task, NSArray<ARTUserInfo *> *datas) {
        [weak hideHUD];
        if (isRefresh)
        {
            weak.dataList = [NSMutableArray array];
        }
        [weak.tableView.mj_header endRefreshing];
        if (datas.count >= ARTPAGESIZE.integerValue)
        {
            [weak.tableView addMJRefreshFooter:^{
                [weak requestWithData:NO];
            }];
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
        [weak hideHUD];
        [weak.view displayTostError:error.errMsg];
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

- (void)requestAddFollow:(NSString *)userID
{
    [self displayHUD];
    
    WS(weak)
    [ARTRequestUtil requestBecomeFans:userID completion:^(NSURLSessionDataTask *task) {
        [weak hideHUD];
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"userID == %@", userID];
        NSArray *result = [weak.dataList filteredArrayUsingPredicate:pre];
        if (result.count)
        {
            ARTUserInfo *info = result.firstObject;
            info.isFans = @"1";
            [weak.tableView reloadData];
        }
        [weak.view displayTostSuccess:@"关注成功"];
    } failure:^(ErrorItemd *error) {
        [weak hideHUD];
        [weak.view displayTostError:error.errMsg];
    }];
}

#pragma mark DELEGATE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"followcell";
    ARTAccountFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell)
    {
        cell = [[ARTAccountFollowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        cell.delegate = self;
    }
    [cell bindingWithData:self.dataList[indexPath.row] type:self.dataList[indexPath.row].isFans.boolValue ? ACCOUNT_CELL_TYPE_TALK : ACCOUNT_CELL_TYPE_FOLLOW];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ARTACCOUNTFOLLOWCELLHEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

#pragma mark DELEGATE_CELL
- (void)accountDidTouchButton:(NSString *)userID
{
    [self requestAddFollow:userID];
}

@end
