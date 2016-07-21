//
//  QHPageContainerButton.m
//  TestPageContainer
//
//  Created by wuzhikun on 15/12/15.
//  Copyright © 2015年 qihoo. All rights reserved.
//

#import "QHPageContainerButton.h"

@implementation QHPageContainerButton
- (id)init
{
    self = [super init];
    if (self) {
        [self setTitleColor:COLOR_YSYC_ORANGE forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        
        [self setBackgroundImage:[UIImage imageWithColor:COLOR_YSYC_ORANGE] forState:UIControlStateDisabled];
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        
        [self clipRadius:2 borderWidth:2 borderColor:COLOR_YSYC_ORANGE];
        [self.titleLabel setFont:FONT_WITH_20];
    }
    return self;
}


@end
