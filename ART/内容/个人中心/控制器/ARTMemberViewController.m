//
//  ARTMemberViewController.m
//  ART
//
//  Created by huangtie on 16/6/23.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTMemberViewController.h"
#import "ARTPurchasesViewController.h"
#import "ARTRequestUtil.h"
#import <UIImageView+WebCache.h>
#import "ARTMemberEditViewController.h"

typedef NS_ENUM(NSInteger, JUMP_CODE)
{
    JUMP_CODE_1001 = 1001,       // 基本资料
    JUMP_CODE_1002 = 1002,       // 我的认证
    JUMP_CODE_1003 = 1003,       // 我的动态
    JUMP_CODE_1004 = 1004,       // 我的图集
    JUMP_CODE_1005 = 1005,       // 消费记录
    JUMP_CODE_1006 = 1006,       // 我的拍卖
    JUMP_CODE_1007 = 1007,       // 我的成交记录
    JUMP_CODE_1008 = 1008,       // 我的出价
    JUMP_CODE_1009 = 1009,       // 设置
};

@interface ARTMemberViewController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) NSArray *item2D;

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) UIView *footder;
@property (nonatomic , strong) UIView *header;
@property (nonatomic , strong) UIImageView *imageView;
@property (nonatomic , strong) UILabel *nickLabel;
@property (nonatomic , strong) UILabel *priceLabel;
@property (nonatomic , strong) UIButton *purchaButton;
@end

@implementation ARTMemberViewController

+ (ARTMemberViewController *)launchViewController:(UIViewController *)vc
{
    ARTMemberViewController *memberVC = [[ARTMemberViewController alloc] init];
    [[ARTUserManager sharedInstance] isLogin:(ARTBaseViewController *)vc logined:^(ARTUserData *userInfo) {
        [vc.navigationController pushViewController:memberVC animated:YES];
    }];
    return memberVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"个人中心";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGH, self.view.width, self.view.height - NAVIGATION_HEIGH) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = UICOLOR_ARGB(0xfffafafa);
    self.tableView.backgroundColor = UICOLOR_ARGB(0xfffafafa);
    self.tableView.separatorColor = UICOLOR_ARGB(0xffe5e5e5);
    self.tableView.tableFooterView = self.footder;
    self.tableView.tableHeaderView = self.header;
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestUserInfo];
}

#pragma mark LAYOUT
- (void)updateSubviews
{
    ARTUserInfo *info = [ARTUserManager sharedInstance].userinfo.userInfo;
    
    //头像
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:info.userImage] placeholderImage:[UIImage imageNamed:@"user_icon_1"]];
    
    //昵称
    self.nickLabel.attributedText = [self title:@"昵称:  " text:info.userNick];
    
    //金币
    self.priceLabel.attributedText = [self title:@"金币余额:  " text:info.userPrice];
}

- (NSAttributedString *)title:(NSString *)title text:(NSString *)text
{
    if (!title.length)
    {
        return nil;
    }
    
    NSMutableAttributedString * attStrA = [[NSMutableAttributedString alloc]initWithString:title];
    [attStrA addAttribute:NSFontAttributeName value:FONT_WITH_19 range:NSMakeRange(0, attStrA.length)];
    [attStrA addAttribute:NSForegroundColorAttributeName value:UICOLOR_ARGB(0xff666666) range:NSMakeRange(0, attStrA.length)];
    
    if (!text.length)
    {
        return attStrA;
    }
    
    NSMutableAttributedString * attStrB = [[NSMutableAttributedString alloc]initWithString:text];
    [attStrB addAttribute:NSFontAttributeName value:FONT_WITH_19 range:NSMakeRange(0, attStrB.length)];
    [attStrB addAttribute:NSForegroundColorAttributeName value:COLOR_YSYC_ORANGE range:NSMakeRange(0, attStrB.length)];
    
    [attStrA appendAttributedString:attStrB];
    return attStrA;
}

#pragma mark GET_SET
- (NSArray *)item2D
{
    if (!_item2D)
    {
        NSDictionary *dic1 = @{@"title":@"基本资料",@"code":STRING_FORMAT_ADC(@(JUMP_CODE_1001))};
        NSDictionary *dic2 = @{@"title":@"我的图集",@"code":STRING_FORMAT_ADC(@(JUMP_CODE_1004))};
        NSDictionary *dic3 = @{@"title":@"消费记录",@"code":STRING_FORMAT_ADC(@(JUMP_CODE_1005))};
        NSDictionary *dic4 = @{@"title":@"设置",@"code":STRING_FORMAT_ADC(@(JUMP_CODE_1006))};
        
        _item2D = @[@[dic1,dic2,dic3],@[dic4]];
    }
    return _item2D;
}

- (UIView *)footder
{
    if (!_footder)
    {
        _footder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        _footder.backgroundColor = [UIColor clearColor];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.size = CGSizeMake(400, 50);
        button.backgroundColor = COLOR_YSYC_ORANGE;
        [button setTitle:@"退出当前账号" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = FONT_WITH_16;
        [button clipRadius:5 borderWidth:0 borderColor:nil];
        button.center = CGPointMake(_footder.width / 2, _footder.height / 2);
        [button addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
        [_footder addSubview:button];
    }
    return _footder;
}

- (UIView *)header
{
    if (!_header)
    {
        _header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
        _header.backgroundColor = [UIColor whiteColor];
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.size = CGSizeMake(125, 125);
        self.imageView.left = 30;
        self.imageView.centerY = _header.height / 2;
        [self.imageView circleBorderWidth:0 borderColor:[UIColor clearColor]];
        self.imageView.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_header addSubview:self.imageView];
        
        self.nickLabel = [[UILabel alloc] init];
        self.nickLabel.size = CGSizeMake(300, 20);
        self.nickLabel.left = self.imageView.right + 20;
        self.nickLabel.top = self.imageView.top + 30;
        self.nickLabel.font = FONT_WITH_18;
        self.nickLabel.textColor = UICOLOR_ARGB(0xff333333);
        [_header addSubview:self.nickLabel];
        
        self.priceLabel = [[UILabel alloc] init];
        self.priceLabel.size = CGSizeMake(150, 20);
        self.priceLabel.left = self.imageView.right + 20;
        self.priceLabel.bottom = self.imageView.bottom - 30;
        self.priceLabel.font = FONT_WITH_18;
        self.priceLabel.textColor = UICOLOR_ARGB(0xff333333);
        [_header addSubview:self.priceLabel];
        
        self.purchaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.purchaButton.size = CGSizeMake(100, 40);
        self.purchaButton.backgroundColor = [UIColor clearColor];
        [self.purchaButton setTitle:@"充值金币" forState:UIControlStateNormal];
        [self.purchaButton setTitleColor:COLOR_YSYC_ORANGE forState:UIControlStateNormal];
        self.purchaButton.titleLabel.font = FONT_WITH_16;
        [self.purchaButton clipRadius:4 borderWidth:1 borderColor:COLOR_YSYC_ORANGE];
        self.purchaButton.left = self.priceLabel.right + 10;
        self.purchaButton.centerY = self.priceLabel.centerY;
        [self.purchaButton addTarget:self action:@selector(purchaAction) forControlEvents:UIControlEventTouchUpInside];
        [_header addSubview:self.purchaButton];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _header.width, ONE_POINT_LINE_WIDTH)];
        line.bottom = _header.height;
        line.backgroundColor = UICOLOR_ARGB(0xffe5e5e5);
        [_header addSubview:line];
    }
    return _header;
}

#pragma mark ACTION
- (void)logoutAction
{
    [ARTAlertView alertTitle:@"警告" message:@"确定退出当前账号?" doneTitle:@"退出" cancelTitle:@"取消" doneBlock:^{
        
    } cancelBlock:^{
        
    }];
}

- (void)purchaAction
{
    [ARTPurchasesViewController launch:self];
}

#pragma mark REQUEST
- (void)requestUserInfo
{
    if (![[ARTUserManager sharedInstance] isLogin])
    {
        return;
    }
    WS(weak)
    [ARTRequestUtil requestUserinfo:[ARTUserManager sharedInstance].userinfo.userInfo.userID completion:^(NSURLSessionDataTask *task, ARTUserInfo *data) {
        [ARTUserManager sharedInstance].userinfo.userInfo = data;
        [weak updateSubviews];
    } failure:^(ErrorItemd *error) {
        
    }];
}

#pragma mark DELEGATE_TABLEVIEW
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.item2D.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.item2D[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * idetifar = @"membercell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idetifar];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idetifar];
        cell.size = CGSizeMake(self.tableView.width, 60);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.separatorInset = UIEdgeInsetsZero;
        cell.textLabel.font = FONT_WITH_15;
        cell.textLabel.textColor = UICOLOR_ARGB(0xff333333);
    }
    NSDictionary *dic = self.item2D[indexPath.section][indexPath.row];
    cell.textLabel.text = dic[@"title"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 20;
    }
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = self.item2D[indexPath.section][indexPath.row];
    switch ([dic[@"code"] integerValue])
    {
        case JUMP_CODE_1001:
        {
            [ARTMemberEditViewController launchViewController:self];
        }
            break;
        default:
            break;
    }
}

@end
