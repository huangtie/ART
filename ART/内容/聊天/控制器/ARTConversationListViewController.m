//
//  ARTConversationListViewController.m
//  ART
//
//  Created by huangtie on 16/7/21.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTConversationListViewController.h"
#import "ARTConversationListCell.h"

@interface ARTConversationListViewController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) NSArray <EMConversation *> *conversations;

@end

@implementation ARTConversationListViewController

+ (ARTConversationListViewController *)launchViewController:(UIViewController *)viewController
{
    ARTConversationListViewController *vc = [[ARTConversationListViewController alloc] init];
    [viewController.navigationController pushViewController:vc animated:YES];
    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"私信列表";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGH + .5, self.view.width, self.view.height - NAVIGATION_HEIGH) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = UICOLOR_ARGB(0xffe5e5e5);
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshData];
}

#pragma mark LOAD
- (void)refreshData
{
    self.conversations = [[EMClient sharedClient].chatManager getAllConversations];
    [self.tableView reloadData];
}

#pragma mark DELEGATE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.conversations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifar = @"conversationlistcell";
    ARTConversationListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifar];
    if (!cell)
    {
        cell = [[ARTConversationListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifar];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ARTCONVERSATIONLISTCELLHEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}















@end
