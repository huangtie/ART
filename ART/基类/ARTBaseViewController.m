//
//  ARTBaseViewController.m
//  ART
//
//  Created by huangtie on 16/5/12.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBaseViewController.h"
#import "ARTUMengServer.h"

@implementation ARTBaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    //友盟统计
    [MobClick beginLogPageView:self.title];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //友盟统计
    [MobClick endLogPageView:self.title];
}

@end
