//
//  ARTAccountDetailViewController.m
//  ART
//
//  Created by huangtie on 16/7/11.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTAccountDetailViewController.h"
#import "ARTAccountDetailCell.h"
#import "ARTRequestUtil.h"
#import "ARTConversationViewController.h"

@interface ARTAccountDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , copy) NSString *userID;

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) NSArray <ARTAccountDetailCell *>*cellList;

@property (nonatomic , strong) ARTAccountDetailCell *idCell;

@property (nonatomic , strong) ARTAccountDetailCell *localCell;

@property (nonatomic , strong) ARTAccountDetailCell *phoneCell;

@property (nonatomic , strong) ARTAccountDetailCell *emailCell;

@property (nonatomic , strong) ARTAccountDetailCell *signCell;

@property (nonatomic , strong) UIView *footerView;

@property (nonatomic , strong) ARTUserInfo *info;
@end

@implementation ARTAccountDetailViewController

- (instancetype)initWithUserID:(NSString *)userID
{
    self = [super init];
    if (self)
    {
        self.userID = userID;
        self.title = @"基本资料";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.hidden = YES;
    
    self.cellList = @[self.idCell,self.localCell,self.phoneCell,self.emailCell,self.signCell];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    [self requestWithInfo:nil];
}

#pragma mark LAYOUT
- (void)layoutWithInfo:(ARTUserInfo *)info
{
    self.info = info;
    
    //用户标识
    self.idCell.contentLabel.text = [NSString stringWithFormat:@"No-%@",info.userID];
    
    //所属地区
    self.localCell.contentLabel.text = [NSString stringWithFormat:@"%@ %@ %@",info.userCity.nameSheng,info.userCity.nameShi,info.userCity.nameQu];
    
    //手机号&邮箱
    if (info.userLook.boolValue)
    {
        self.phoneCell.contentLabel.text = @"未公开";
        self.emailCell.contentLabel.text = @"未公开";
    }
    else
    {
        self.phoneCell.contentLabel.text = info.userPhone;
        self.emailCell.contentLabel.text = info.userEmail;
    }
    
    //个性签名
    NSString *sign = info.userSign;
    self.signCell.contentLabel.text = sign;
    self.signCell.contentLabel.numberOfLines = 0;
    if (!sign.length)
    {
        self.signCell.contentLabel.height = 30;
    }
    else
    {
        CGFloat height = [sign heightForFont:self.signCell.contentLabel.font width:self.signCell.contentLabel.width];
        if (height > 30)
        {
            self.signCell.contentLabel.height = height;
        }
        else
        {
            self.signCell.height = 30;
        }
    }
    self.signCell.height = self.signCell.contentLabel.height + 40;
    self.signCell.contentLabel.centerY = self.signCell.height / 2;

    [self.tableView reloadData];
}

#pragma mark GET_SET
- (ARTAccountDetailCell *)idCell
{
    if (!_idCell)
    {
        _idCell = [[ARTAccountDetailCell alloc] init];
        _idCell.nameLabel.text = @"用户标识: ";
    }
    return _idCell;
}

- (ARTAccountDetailCell *)localCell
{
    if (!_localCell)
    {
        _localCell = [[ARTAccountDetailCell alloc] init];
        _localCell.nameLabel.text = @"所属地区: ";
    }
    return _localCell;
}

- (ARTAccountDetailCell *)phoneCell
{
    if (!_phoneCell)
    {
        _phoneCell = [[ARTAccountDetailCell alloc] init];
        _phoneCell.nameLabel.text = @"手机号码: ";
    }
    return _phoneCell;
}

- (ARTAccountDetailCell *)emailCell
{
    if (!_emailCell)
    {
        _emailCell = [[ARTAccountDetailCell alloc] init];
        _emailCell.nameLabel.text = @"电子邮箱: ";
    }
    return _emailCell;
}

- (ARTAccountDetailCell *)signCell
{
    if (!_signCell)
    {
        _signCell = [[ARTAccountDetailCell alloc] init];
        _signCell.nameLabel.text = @"个性签名: ";
    }
    return _signCell;
}

- (UIView *)footerView
{
    if (!_footerView)
    {
        _footerView = [[UIView alloc] init];
        _footerView.size = CGSizeMake(SCREEN_WIDTH, 90);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.size = CGSizeMake(500, 70);
        button.centerX = _footerView.width / 2;
        button.centerY = _footerView.height / 2;
        [button clipRadius:5 borderWidth:2 borderColor:COLOR_YSYC_ORANGE];
        button.titleLabel.font = FONT_WITH_23;
        [button setTitle:@"私信TA" forState:UIControlStateNormal];
        [button setTitleColor:COLOR_YSYC_ORANGE forState:UIControlStateNormal];
        [button addTarget:self action:@selector(chatTouchAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:button];
    }
    return _footerView;
}

#pragma mark ACTION
- (void)chatTouchAction
{
    [ARTConversationViewController launchViewController:self chater:self.userID info:self.info];
}

#pragma mark REQUEST
- (void)requestWithInfo:(void (^)(ARTUserInfo *info))completion
{
    WS(weak)
    [ARTRequestUtil requestUserinfo:self.userID completion:^(NSURLSessionDataTask *task, ARTUserInfo *data) {
        [weak layoutWithInfo:data];
        if (completion)
        {
            completion(data);
        }
    } failure:^(ErrorItemd *error) {
        [weak.view displayTostError:error.errMsg];
        if (completion)
        {
            completion(nil);
        }
    }];
}

#pragma mark DELEGATE
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellList[indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellList[indexPath.row].height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return self.footerView.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.footerView;
}


@end
