//
//  ARTTalkDetailCell.m
//  ART
//
//  Created by huangtie on 16/7/7.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTTalkDetailCell.h"

@interface ARTTalkDetailCell()

@property (nonatomic , strong) ARTTalkReplayData *data;

@property (nonatomic , strong) UILabel *contentLabel;

@property (nonatomic , copy) NSString *comID;

@end

@implementation ARTTalkDetailCell

#define spacing 8
#define LABEL_WIDTH 600
#define LABEL_HEIGHT 20
#define LEFT 120
#define FONT_TEXT FONT_WITH_16
+ (CGFloat)cellHeight:(ARTTalkReplayData *)data
{
    CGFloat palyHeight = [[ARTTalkDetailCell content:data.replayText firstNick:data.replayNick secondNick:data.acceptNick].string heightForFont:FONT_WITH_15 width:LABEL_WIDTH];
    return palyHeight + 2 * spacing;
}

+ (NSMutableAttributedString *)content:(NSString *)text
                             firstNick:(NSString *)firstNick
                            secondNick:(NSString *)secondNick
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
    [string appendAttributedString:[ARTTalkDetailCell nickString:firstNick]];
    if (secondNick.length)
    {
        [string appendAttributedString:[ARTTalkDetailCell textString:@" 回复 "]];
        [string appendAttributedString:[ARTTalkDetailCell nickString:secondNick]];
    }
    [string appendAttributedString:[ARTTalkDetailCell nickString:@": "]];
    [string appendAttributedString:[ARTTalkDetailCell textString:text]];
    return string;
}

+ (NSMutableAttributedString *)nickString:(NSString *)string
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    [text addAttribute:NSFontAttributeName value:FONT_TEXT range:NSMakeRange(0, text.length)];
    [text addAttribute:NSForegroundColorAttributeName value:COLOR_YSYC_ORANGE range:NSMakeRange(0, text.length)];
    return text;
}

+ (NSMutableAttributedString *)textString:(NSString *)string
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    [text addAttribute:NSFontAttributeName value:FONT_TEXT range:NSMakeRange(0, text.length)];
    [text addAttribute:NSForegroundColorAttributeName value:UICOLOR_ARGB(0xff666666) range:NSMakeRange(0, text.length)];
    return text;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.width = SCREEN_WIDTH;
    }
    return self;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel)
    {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.left = LEFT;
        _contentLabel.top = spacing;
        _contentLabel.width = LABEL_WIDTH;
        [self.contentView addSubview:_contentLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replayTouch)];
        [_contentLabel addGestureRecognizer:tap];
        _contentLabel.userInteractionEnabled = YES;
        
    }
    return _contentLabel;
}

- (void)replayTouch
{
    ARTSendTalkComParam *param = [[ARTSendTalkComParam alloc] init];
    param.replayID = self.comID;
    param.accept = self.data.replayUser;
    param.replayNick = self.data.replayNick;
    [self.delegate replayCellWillReplay:param];
}

- (void)bindingWithData:(ARTTalkReplayData *)data comID:(NSString *)comID
{
    self.data = data;
    self.comID = comID;
    self.height = [ARTTalkDetailCell cellHeight:data];
    NSMutableAttributedString *palyText = [ARTTalkDetailCell content:data.replayText firstNick:data.replayNick secondNick:data.acceptNick];
    CGFloat palyHeight = [palyText.string heightForFont:FONT_WITH_15 width:LABEL_WIDTH];
    self.contentLabel.attributedText = palyText;
    self.contentLabel.height = palyHeight;
}

@end
