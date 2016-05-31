//
//  NSString+ART.m
//  ART
//
//  Created by huangtie on 16/5/30.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "NSString+ART.h"

@implementation NSString (ART)

//时间戳转换为可读时间
+ (NSString *)timeString:(NSString *)timestamp dateFormat:(NSString *)dateFormat
{
    if (!timestamp || !timestamp.length || timestamp.length < 10 || !dateFormat.length)
    {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:dateFormat];
    
    //截取前十位  （由于时间戳的时13位的  所以要截取 得到10位的）
    NSString *time = [timestamp substringToIndex:10];
    // 时间戳转时间的方法   将前面nsstring的time幻化成int型之后  赋值给  nsstring  为了判断之后截取需要的时间
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[time integerValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

@end
