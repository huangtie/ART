//
//  ARTMemberViewController.m
//  ART
//
//  Created by huangtie on 16/6/23.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTMemberViewController.h"

@interface ARTMemberViewController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) NSArray *item2D;

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) UIView *header;
@property (nonatomic , strong) UIImageView *imageView;
@property (nonatomic , strong) UILabel *nickLabel;
@property (nonatomic , strong) UILabel *priceLabel;
@property (nonatomic , strong) UIButton *purchaButton;
@end

@implementation ARTMemberViewController

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
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
    return [[UITableViewCell alloc] init];
}

@end
