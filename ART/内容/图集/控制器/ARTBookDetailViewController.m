//
//  ARTBookDetailViewController.m
//  ART
//
//  Created by huangtie on 16/5/26.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBookDetailViewController.h"

@interface ARTBookDetailViewController()

@property (nonatomic , copy) NSString *bookID;

@end

@implementation ARTBookDetailViewController

+ (ARTBookDetailViewController *)launchFromController:(ARTBaseViewController *)controller
                                               bookID:(NSString *)bookID
{
    ARTBookDetailViewController *detailVC = [[ARTBookDetailViewController alloc] init];
    detailVC.bookID = bookID;
    [controller.navigationController pushViewController:detailVC animated:YES];
    return detailVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"图集详情";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barItemWithMore:self action:@selector(_rightItemClicked:)];
}

@end
