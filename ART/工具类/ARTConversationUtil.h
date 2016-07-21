//
//  ARTConversationUtil.h
//  ART
//
//  Created by huangtie on 16/7/13.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <Foundation/Foundation.h>

#define POPAO_IMAGE_SENDER [UIImage imageNamed:@"chat_3"]
#define POPAO_IMAGE_SENDER_HEILIGHT [UIImage imageNamed:@"chat_4"]

#define POPAO_IMAGE_RECEDER [UIImage imageNamed:@"chat_1"]
#define POPAO_IMAGE_RECEDER_HEILIGHT [UIImage imageNamed:@"chat_2"]

@interface ARTConversationUtil : NSObject

//判断该休息是对方发的还是自己发的 YES:自己 ， NO:对方
+ (BOOL)isSender:(EMMessage *)message;

//拉伸泡泡图片
+ (UIImage *)resizableImage:(UIImage *)image;

//聊天文字
+ (NSMutableAttributedString *)conText:(NSString *)messageText;

//文字的尺寸
+ (CGSize)converTextSize:(NSMutableAttributedString *)text;

//文字气泡的尺寸
+ (CGSize)popaoTextSize:(NSMutableAttributedString *)text;

//图片消息的尺寸
+ (CGSize)converImageSize;

//语音消息的尺寸
+ (CGSize)converVoiceSize:(NSInteger)duration;
@end
