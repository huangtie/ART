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

@end
