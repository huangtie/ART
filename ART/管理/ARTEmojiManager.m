//
//  ARTEmojiManager.m
//  ART
//
//  Created by huangtie on 16/7/13.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTEmojiManager.h"
#import <MJExtension.h>

@implementation ARTEmoji

@end

@implementation ARTEmojiManager

+ (instancetype)sharedInstance
{
    static ARTEmojiManager *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[ARTEmojiManager alloc] init];
    });
    
    return instance;
}

- (NSArray *)emojis
{
    if (!_emojis)
    {
        NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FaceList" ofType:@"plist"]];
        NSMutableArray *mutableEmoji = [NSMutableArray array];
        for (NSDictionary *dic in array)
        {
            [mutableEmoji addObject:[ARTEmoji mj_objectWithKeyValues:dic]];
        }
        _emojis = mutableEmoji;
    }
    return _emojis;
}

- (NSString *)pngName:(NSString *)emojiName
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"chs == %@", emojiName];
    NSArray <ARTEmoji *> *results = [self.emojis filteredArrayUsingPredicate:predicate];
    if (results.count)
    {
        return results.firstObject.png;
    }
    return @"";
}

- (NSString *)text:(NSString *)text
{
    NSString *pattern = @"\\[\\w+\\]";
    
    NSArray *resultArr = [text machesWithPattern:pattern];
    if (!resultArr) return @"";
    
    NSMutableAttributedString *attrContent = [[NSMutableAttributedString alloc] init];
    //遍历所有的result 取出range
    for (NSTextCheckingResult *result in resultArr)
    {
        NSString *imageName = [text substringWithRange:NSMakeRange(result.range.location, result.range.length)];
        [attrContent appendString:imageName];
    }
    return attrContent.string;
}










@end
