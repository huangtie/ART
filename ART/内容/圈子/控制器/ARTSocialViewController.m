//
//  ARTSocialViewController.m
//  ART
//
//  Created by huangtie on 16/5/18.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTSocialViewController.h"
#import "ARTSocialCell.h"
#import "ARTTalkSendViewController.h"
#import "ARTLocalPageViewController.h"

@interface ARTSocialViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) NSArray *icons;

@property (nonatomic , strong) NSArray *titles;

@end

@implementation ARTSocialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"圈子";
    
    self.navigationBar.hidden = YES;
    
    self.icons = @[@"talk_icon_chat",@"talk_icon_friend",@"talk_icon_shuo",@"talk_icon_news"];
    self.titles = @[@"我的私信",@"我的关注",@"动态",@"文章中心"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGH, self.view.width, self.view.height - NAVIGATION_HEIGH)];
    self.tableView.backgroundColor = COLOR_YSYC_GRAY;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

#pragma mark DELEGATE_TABLEVIEW
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.icons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *itentifar = @"scocialcell";
    ARTSocialCell *cell = [tableView dequeueReusableCellWithIdentifier:itentifar];
    if (!cell)
    {
        cell = [[ARTSocialCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itentifar];
    }
    
    [cell updateData:self.icons[indexPath.row] titleName:self.titles[indexPath.row] isWhite:indexPath.row % 2 != 0];
    
    if (indexPath.row == 0)
    {
        [cell upDateNoRead:13];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ARTSocialCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1)
    {
        ARTLocalPageViewController *vc = [[ARTLocalPageViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.row == 2)
    {
        ARTTalkSendViewController *vc = [[ARTTalkSendViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
