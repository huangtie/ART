//
//  NSString+ART.h
//  ART
//
//  Created by huangtie on 16/5/30.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ART)

//时间戳转换为可读时间
+ (NSString *)timeString:(NSString *)timestamp dateFormat:(NSString *)dateFormat;

//是否为手机号格式
- (BOOL)isMobileNumber;

//是否是邮箱格式
- (BOOL)isEmailNumber;

/**
 *  返回正则表达式匹配的第一个结果
 *
 *  @param pattern 正则表达式
 *
 *  @return 匹配的第一个结果 是NSTextCheckingResult类型
 */
- (NSTextCheckingResult *)firstMacthWithPattern:(NSString *)pattern;

- (NSArray <NSTextCheckingResult *> *)machesWithPattern:(NSString *)pattern;

@end
