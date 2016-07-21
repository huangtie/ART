//
//  ARTConversationUtil.m
//  ART
//
//  Created by huangtie on 16/7/13.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTConversationUtil.h"

@implementation ARTConversationUtil

+ (BOOL)isSender:(EMMessage *)message
{
    if (![[ARTUserManager sharedInstance] isLogin] || !message)
    {
        return NO;
    }
    return [message.from isEqualToString:[ARTUserManager sharedInstance].userinfo.userInfo.userID];
}

+ (UIImage *)resizableImage:(UIImage *)image
{
    CGFloat top = image.size.height / 2; // 顶端盖高度
    CGFloat bottom = image.size.height / 2 ; // 底端盖高度
    CGFloat left = image.size.width / 2; // 左端盖宽度
    CGFloat right = image.size.width / 2; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    return [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
}

#define LABEL_MAX_WIDTH 480
#define LABEL_MIN_HEIGHT 26
#define LABEL_PADDING 30
#define LABEL_SPADING 20
+ (NSMutableAttributedString *)conText:(NSString *)messageText
{
    NSString *pattern = @"\\[\\w+\\]";
    NSArray *resultArr = [messageText machesWithPattern:pattern];
    NSMutableAttributedString *attrContent = [[NSMutableAttributedString alloc] initWithString:messageText];
    [attrContent addAttribute:NSFontAttributeName value:FONT_WITH_18 range:NSMakeRange(0, attrContent.length)];
    [attrContent addAttribute:NSForegroundColorAttributeName value:UICOLOR_ARGB(0xff333333) range:NSMakeRange(0, attrContent.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6.0f;
    [attrContent addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrContent.length)];
    long number = 2;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attrContent addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attrContent length])];
    CFRelease(num);
    if (!resultArr)
    {
        return attrContent;
    }
    
    NSUInteger lengthDetail = 0;
    for (NSTextCheckingResult *result in resultArr)
    {
        NSString *emojiName = [messageText substringWithRange:NSMakeRange(result.range.location, result.range.length)];
        NSString *imageName = [[ARTEmojiManager sharedInstance] pngName:emojiName];
        NSTextAttachment * textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = [UIImage imageNamed:imageName];
        textAttachment.bounds = CGRectMake(0, -5 , 33, 33);
        NSAttributedString *emojiText = [NSAttributedString attributedStringWithAttachment:textAttachment];
        
        NSUInteger length = attrContent.length;
        NSRange newRange = NSMakeRange(result.range.location - lengthDetail, result.range.length);
        [attrContent replaceCharactersInRange:newRange withAttributedString:emojiText];
        lengthDetail += length - attrContent.length;
    }
    return attrContent;
}

//LABEL的尺寸
+ (CGSize)converTextSize:(NSMutableAttributedString *)text
{
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(LABEL_MAX_WIDTH, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    if (textSize.height <= LABEL_MIN_HEIGHT)
    {
        textSize.height = LABEL_MIN_HEIGHT;
    }
    return textSize;
}

//起泡的尺寸
+ (CGSize)popaoTextSize:(NSMutableAttributedString *)text
{
    CGSize labelSize = [ARTConversationUtil converTextSize:text];
    CGSize popaoSize = CGSizeMake(labelSize.width + 2 * LABEL_PADDING, labelSize.height + 2 * LABEL_SPADING);
    return popaoSize;
}

+ (CGSize)converImageSize
{
    return CGSizeMake(250, 250);
}

#define VOICEDEFULTWIDTH 120
#define VOICEMAXWIDTH LABEL_MAX_WIDTH + 2 * LABEL_PADDING
+ (CGSize)converVoiceSize:(NSInteger)duration
{
    return CGSizeMake((duration * 2 + VOICEDEFULTWIDTH) > VOICEMAXWIDTH ? VOICEMAXWIDTH : (duration * 5 + VOICEDEFULTWIDTH), 72);
}


@end
