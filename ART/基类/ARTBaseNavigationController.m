//
//  ARTBaseNavigationController.m
//  ART
//
//  Created by huangtie on 16/6/17.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBaseNavigationController.h"

@implementation ARTBaseNavigationController

- (BOOL)shouldAutorotate
{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return  UIInterfaceOrientationMaskPortrait;
}

@end
