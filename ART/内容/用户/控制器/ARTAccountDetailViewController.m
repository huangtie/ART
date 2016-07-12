//
//  ARTAccountDetailViewController.m
//  ART
//
//  Created by huangtie on 16/7/11.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTAccountDetailViewController.h"

@interface ARTAccountDetailViewController ()

@property (nonatomic , copy) NSString *userID;

@property (nonatomic , strong) UITableView *tableView;

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
}


@end
