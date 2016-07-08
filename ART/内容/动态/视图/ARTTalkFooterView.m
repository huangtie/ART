//
//  ARTTalkFooterView.m
//  ART
//
//  Created by huangtie on 16/7/5.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTTalkFooterView.h"

@interface ARTTalkFooterView()

@property (nonatomic , strong)ARTTalkData *data;

@end

@implementation ARTTalkFooterView

+ (ARTTalkFooterView *)crate:(ARTTalkData *)data index:(NSInteger)index
{
    ARTTalkFooterView *view = [[ARTTalkFooterView alloc] initWithData:data index:index];
    return view;
}

#define COMMENT_WIDTH 550
#define REPLAY_WIDTH 550
#define SPADDING 5
#define LEFT 120
#define BUTTON_HEIGHT 40
+ (CGFloat)viewHeight:(ARTTalkData *)data
{
    if (data.comList.count == 0)
    {
        return 0;
    }
    CGFloat comHeigh = SPADDING;
    for (ARTTalkComData *comData in data.comList)
    {
        CGFloat textHeight = [[ARTTalkFooterView content:comData.comText firstNick:comData.comNick secondNick:nil].string heightForFont:FONT_WITH_15 width:COMMENT_WIDTH];
        comHeigh += textHeight + SPADDING;
        
        CGFloat repalyHeight = 0;
        for (ARTTalkReplayData *repalyData in comData.replays)
        {
            CGFloat palyHeight = [[ARTTalkFooterView content:repalyData.replayText firstNick:repalyData.replayNick secondNick:repalyData.acceptNick].string heightForFont:FONT_WITH_15 width:REPLAY_WIDTH];
            repalyHeight += palyHeight + SPADDING;
        }
        comHeigh += repalyHeight + 10;
    }
    if (data.comCount.integerValue > 3)
    {
        comHeigh += BUTTON_HEIGHT;
    }
    return comHeigh + 20;
}

- (instancetype)initWithData:(ARTTalkData *)data index:(NSInteger)index
{
    self = [super init];
    if (self)
    {
        self.data = data;
        self.size = CGSizeMake(SCREEN_WIDTH, [ARTTalkFooterView viewHeight:data]);
        self.backgroundColor = index % 2 == 0 ? [UIColor whiteColor] : UICOLOR_ARGB(0xfffafafa);
        
        CGFloat comHeigh = SPADDING;
        for (ARTTalkComData *comData in data.comList)
        {
            NSMutableAttributedString *comText = [ARTTalkFooterView content:comData.comText firstNick:comData.comNick secondNick:nil];
            CGFloat textHeight = [comText.string heightForFont:FONT_WITH_15 width:COMMENT_WIDTH];
            UILabel *comLabel = [[UILabel alloc] init];
            comLabel.numberOfLines = 0;
            comLabel.size = CGSizeMake(COMMENT_WIDTH, textHeight);
            comLabel.left = LEFT;
            comLabel.top = comHeigh;
            comLabel.attributedText = comText;
            [self addSubview:comLabel];
            WS(weak)
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
                ARTSendTalkComParam *param = [[ARTSendTalkComParam alloc] init];
                param.talkID = data.talkID;
                param.replayID = comData.comID;
                param.accept = comData.comUser;
                param.replayNick = comData.comNick;
                [weak.delegate commentReplayMember:param];
            }];
            [comLabel addGestureRecognizer:tap];
            comLabel.userInteractionEnabled = YES;
            comHeigh += textHeight + SPADDING;
            
            for (ARTTalkReplayData *repalyData in comData.replays)
            {
                NSMutableAttributedString *palyText = [ARTTalkFooterView content:repalyData.replayText firstNick:repalyData.replayNick secondNick:repalyData.acceptNick];
                CGFloat palyHeight = [palyText.string heightForFont:FONT_WITH_15 width:REPLAY_WIDTH];
                UILabel *replayLabel = [[UILabel alloc] init];
                replayLabel.numberOfLines = 0;
                replayLabel.size = CGSizeMake(REPLAY_WIDTH, palyHeight);
                replayLabel.left = LEFT + (COMMENT_WIDTH - REPLAY_WIDTH);
                replayLabel.top = comHeigh;
                replayLabel.attributedText = palyText;
                [self addSubview:replayLabel];
                UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
                    ARTSendTalkComParam *param = [[ARTSendTalkComParam alloc] init];
                    param.talkID = data.talkID;
                    param.replayID = comData.comID;
                    param.accept = repalyData.replayUser;
                    param.replayNick = repalyData.replayNick;
                    [weak.delegate commentReplayMember:param];
                }];
                [replayLabel addGestureRecognizer:tap2];
                replayLabel.userInteractionEnabled = YES;
                comHeigh += palyHeight + SPADDING;
            }
            comHeigh += 10;
        }
        if (data.comCount.integerValue > 3)
        {
            UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [moreButton setTitle:[NSString stringWithFormat:@"查看更多评论(共%@条)>>",data.comCount] forState:UIControlStateNormal];
            [moreButton setTitleColor:UICOLOR_ARGB(0xff5dadff) forState:UIControlStateNormal];
            moreButton.titleLabel.font = FONT_WITH_16;
            [moreButton sizeToFit];
            moreButton.height = BUTTON_HEIGHT;
            moreButton.right = self.width - 50;
            moreButton.top = comHeigh;
            [moreButton addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:moreButton];
        }
    }
    return self;
}

- (void)moreAction
{
    [self.delegate commentDidClickMore:self.data.talkID];
}

+ (NSMutableAttributedString *)content:(NSString *)text
                             firstNick:(NSString *)firstNick
                            secondNick:(NSString *)secondNick
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
    [string appendAttributedString:[ARTTalkFooterView nickString:firstNick]];
    if (secondNick.length)
    {
        [string appendAttributedString:[ARTTalkFooterView textString:@" 回复 "]];
        [string appendAttributedString:[ARTTalkFooterView nickString:secondNick]];
    }
    [string appendAttributedString:[ARTTalkFooterView nickString:@": "]];
    [string appendAttributedString:[ARTTalkFooterView textString:text]];
    return string;
}

+ (NSMutableAttributedString *)nickString:(NSString *)string
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    [text addAttribute:NSFontAttributeName value:FONT_WITH_15 range:NSMakeRange(0, text.length)];
    [text addAttribute:NSForegroundColorAttributeName value:COLOR_YSYC_ORANGE range:NSMakeRange(0, text.length)];
    return text;
}

+ (NSMutableAttributedString *)textString:(NSString *)string
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    [text addAttribute:NSFontAttributeName value:FONT_WITH_15 range:NSMakeRange(0, text.length)];
    [text addAttribute:NSForegroundColorAttributeName value:UICOLOR_ARGB(0xff666666) range:NSMakeRange(0, text.length)];
    return text;
}

@end
