//
//  ARTEmojiManager.h
//  ART
//
//  Created by huangtie on 16/7/13.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARTEmoji : NSObject

@property (nonatomic , copy) NSString *chs;

@property (nonatomic , copy) NSString *png;

@end

@interface ARTEmojiManager : NSObject

@property (nonatomic , strong) NSArray <ARTEmoji *> * emojis;

+ (instancetype)sharedInstance;

- (NSString *)text:(NSString *)text;

//通过表情名称获取对应图片名称  [xx] 获取 xx.png
- (NSString *)pngName:(NSString *)emojiName;
@end
