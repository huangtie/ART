//
//  ARTMemberSetupViewController.m
//  ART
//
//  Created by huangtie on 16/6/27.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTMemberSetupViewController.h"

@interface ARTMemberSetupViewController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) NSArray *item2D;

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) UITableViewCell *clearCell;

@property (nonatomic , strong) UITableViewCell *pwdCell;

@end

@implementation ARTMemberSetupViewController

+ (ARTMemberSetupViewController *)launchViewController:(UIViewController *)viewController
{
    ARTMemberSetupViewController *vc = [[ARTMemberSetupViewController alloc] init];
    [viewController.navigationController pushViewController:vc animated:YES];
    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"设置";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGH, self.view.width, self.view.height - NAVIGATION_HEIGH) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UICOLOR_ARGB(0xfffafafa);
    self.tableView.separatorColor = UICOLOR_ARGB(0xffe5e5e5);
    [self.view addSubview:self.tableView];
}

#pragma mark GET_SET
#define CELL_HEIGHT 60
- (NSArray *)item2D
{
    if (!_item2D)
    {
        _item2D = @[@[self.clearCell]];
    }
    return _item2D;
}

- (UITableViewCell *)clearCell
{
    if (!_clearCell)
    {
        _clearCell = [[UITableViewCell alloc] init];
        _clearCell.size = CGSizeMake(SCREEN_WIDTH, CELL_HEIGHT);
        _clearCell.textLabel.text = @"清除缓存";
        _clearCell.textLabel.textColor = UICOLOR_ARGB(0xff333333);
        _clearCell.textLabel.font = FONT_WITH_16;
        _clearCell.separatorInset = UIEdgeInsetsZero;
    }
    return _clearCell;
}

- (UITableViewCell *)pwdCell
{
    if (!_pwdCell)
    {
        _pwdCell = [[UITableViewCell alloc] init];
        _pwdCell.size = CGSizeMake(SCREEN_WIDTH, CELL_HEIGHT);
        _pwdCell.textLabel.text = @"修改密码";
        _pwdCell.textLabel.textColor = UICOLOR_ARGB(0xff333333);
        _pwdCell.textLabel.font = FONT_WITH_16;
        _pwdCell.separatorInset = UIEdgeInsetsZero;
    }
    return _pwdCell;
}

#pragma mark DELEGATE
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
    return self.item2D[indexPath.section][indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = self.item2D[indexPath.section][indexPath.row];
    if (cell == self.clearCell)
    {
        WS(weak)
        [ARTAlertView alertTitle:@"警告" message:@"是否清楚缓存数据?" doneTitle:@"清除" cancelTitle:@"取消" doneBlock:^{
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                [weak.view displayTostSuccess:@"清楚缓存成功"];
            }];
        } cancelBlock:^{
            
        }];
    }
    else if (cell == self.pwdCell)
    {
    
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}





@end
