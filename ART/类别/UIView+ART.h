//
//  UIView+ART.h
//  ART
//
//  Created by huangtie on 16/5/27.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ART)

//圆形视图
- (void)circleBorderWidth:(CGFloat)bWidth borderColor:(UIColor *)bColor;

- (void)clipRadius:(CGFloat)cRadius
       borderWidth:(CGFloat)bWidth
       borderColor:(UIColor *)bColor;

- (void)displayTostSuccess:(NSString *)message;

- (void)displayTostError:(NSString *)message;

- (void)displayTost:(NSString *)message;
@end
