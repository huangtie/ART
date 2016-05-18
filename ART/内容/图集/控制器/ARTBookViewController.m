//
//  ARTBookViewController.m
//  ART
//
//  Created by huangtie on 16/5/18.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBookViewController.h"
#import "ARTBookScreen.h"

@interface ARTBookViewController ()

@property (nonatomic , strong) UIView *screenContrl;

@property (nonatomic , strong) ARTBookScreen *VIPScreen;

@end

@implementation ARTBookViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"图集";
    
    [self.view addSubview:self.screenContrl];
}

- (UIView *)screenContrl
{
    if (!_screenContrl)
    {
        _screenContrl = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGH, self.view.width, 70)];
        _screenContrl.backgroundColor = [UIColor whiteColor];
        
        CGFloat Spacing = (_screenContrl.width - 4 * 150) / 5;
        self.VIPScreen = [[ARTBookScreen alloc] initWithTitels:@[@"全部",@"会员",@"非会员"]];
        self.VIPScreen.left = Spacing;
        self.VIPScreen.top = 30;
        [_screenContrl addSubview:self.VIPScreen];
    }
    return _screenContrl;
}

@end
