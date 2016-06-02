//
//  UIView+ART.m
//  ART
//
//  Created by huangtie on 16/5/27.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "UIView+ART.h"

@implementation UIView (ART)

- (void)circleBorderWidth:(CGFloat)bWidth borderColor:(UIColor *)bColor
{
    [self clipRadius:self.bounds.size.width / 2.0f borderWidth:bWidth borderColor:bColor];
}

- (void)clipRadius:(CGFloat)cRadius
       borderWidth:(CGFloat)bWidth
       borderColor:(UIColor *)bColor
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cRadius;
    if (bWidth > .0)
    {
        self.layer.borderWidth = bWidth;
    }
    if (bColor)
    {
        self.layer.borderColor = bColor.CGColor;
    }
}

- (void)displayTostSuccess:(NSString *)message
{
    [CSToastManager sharedStyle].messageFont = FONT_WITH_20;
    [CSToastManager sharedStyle].imageSize = CGSizeMake(21, 30);
    [CSToastManager sharedStyle].cornerRadius = 5.0;
    [CSToastManager sharedStyle].horizontalPadding = 15;
    [CSToastManager sharedStyle].backgroundColor = RGBCOLOR(33, 33, 33, .8);
    [self makeToast:message duration:2.5 position:[NSValue valueWithCGPoint:CGPointMake(self.centerX, self.centerY + 100)] title:nil image:[UIImage imageNamed:@"emoji_icon_3"] style:[CSToastManager sharedStyle] completion:nil];
}

- (void)displayTostError:(NSString *)message
{
    [CSToastManager sharedStyle].messageFont = FONT_WITH_20;
    [CSToastManager sharedStyle].imageSize = CGSizeMake(35, 30);
    [CSToastManager sharedStyle].cornerRadius = 5.0;
    [CSToastManager sharedStyle].horizontalPadding = 15;
    [CSToastManager sharedStyle].backgroundColor = RGBCOLOR(33, 33, 33, .8);
    [self makeToast:message duration:2.5 position:[NSValue valueWithCGPoint:CGPointMake(self.centerX, self.centerY + 100)] title:nil image:[UIImage imageNamed:@"emoji_icon_4"] style:[CSToastManager sharedStyle] completion:nil];
}

- (void)displayTost:(NSString *)message
{
    [CSToastManager sharedStyle].messageFont = FONT_WITH_20;
    [CSToastManager sharedStyle].cornerRadius = 5.0;
    [CSToastManager sharedStyle].horizontalPadding = 15;
    [CSToastManager sharedStyle].backgroundColor = RGBCOLOR(33, 33, 33, .8);
    [CSToastManager setDefaultPosition:[NSValue valueWithCGPoint:CGPointMake(self.centerX, self.centerY + 100)]];
    [self makeToast:message];
}

@end
