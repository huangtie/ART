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

- (void)rock
{
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.duration = 1;
    animation.values = @[ @(0), @(10), @(-8), @(8), @(-5), @(5), @(0) ];
    animation.keyTimes = @[ @(0), @(0.225), @(0.425), @(0.6), @(0.75), @(0.875), @(1) ];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:animation forKey:@"transienceRock"];
}

-(void)parabola:(CGPoint)point
{
    float duration = .7;
    
    CGPoint orignal =  self.center;
    CGPoint focus = CGPointZero;
    CGPoint symPoint = CGPointZero;
    CGPoint destPoint = point;
    focus.x = orignal.x + (destPoint.x - orignal.x)/2;
    focus.y = orignal.y - (destPoint.y - orignal.y);
    
    symPoint.x = 2* focus.x - orignal.x;
    symPoint.y = orignal.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path,NULL,orignal.x,orignal.y);
    CGPathAddQuadCurveToPoint(path,NULL,focus.x ,focus.y,destPoint.x,destPoint.y);
    CAKeyframeAnimation *
    animation = [CAKeyframeAnimation
                 animationWithKeyPath:@"position"];
    [animation setPath:path];
    [animation setDuration:duration];
    CFRelease(path);
    
    
    CAAnimationGroup * animationGp = [CAAnimationGroup animation];
    animationGp.duration = duration;
    animationGp.animations = @[animation];
    
    [self.layer addAnimation:animationGp forKey:nil];
    
    self.center = point;
}

@end
