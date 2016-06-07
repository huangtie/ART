//
//  ARTAlertView.m
//  ART
//
//  Created by huangtie on 16/6/6.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTAlertView.h"
#import "AppDelegate.h"

@interface ARTAlertView()

@property (nonatomic , strong) UILabel *titleLabel;
@property (nonatomic , strong) UILabel *messageLabel;
@property (nonatomic , strong) UIButton *doneButton;
@property (nonatomic , strong) UIButton *cancelButton;

@property (nonatomic , strong) UIView *alert;

@end

@implementation ARTAlertView

+ (ARTAlertView *)alertTitle:(NSString *)title
           message:(NSString *)message
         doneTitle:(NSString *)doneTitle
       cancelTitle:(NSString *)cancelTitle
         doneBlock:(ARTAlertDismissBlock)doneBlock
       cancelBlock:(ARTAlertDismissBlock)cancelBlock
{
    ARTAlertView *alertView = [[ARTAlertView alloc] initWithTitle:title message:message cancelButtonTitle:cancelTitle doneButtonTitle:doneTitle];
    alertView.doneBlock = doneBlock;
    alertView.cancelBlock = cancelBlock;
    [alertView show];
    return alertView;
}

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
              doneButtonTitle:(NSString *)doneButtonTitle
{
    self = [super init];
    if (self)
    {
        self.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = RGBCOLOR(0, 0, 0, .5);
        
        NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"  %@",title]];
        [attStr addAttribute:NSFontAttributeName value:FONT_WITH_21 range:NSMakeRange(0, attStr.length)];
        [attStr addAttribute:NSForegroundColorAttributeName value:UICOLOR_ARGB(0xff333333) range:NSMakeRange(0, attStr.length)];
        NSTextAttachment * textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = [UIImage imageNamed:@"emoji_icon_2"];
        textAttachment.bounds=CGRectMake(-5, -5, 30, 30);
        NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
        [attStr replaceCharactersInRange:NSMakeRange(0, 2) withAttributedString:imageStr];
        self.titleLabel.attributedText = attStr;
        
        self.messageLabel.text = message;
        [self.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
        [self.doneButton setTitle:doneButtonTitle forState:UIControlStateNormal];
    }
    return self;
}

- (void)show
{
    self.titleLabel.top = 15;
    self.titleLabel.centerX = self.alert.width / 2 - 10;
    
    self.messageLabel.top = self.titleLabel.bottom + 10;
    self.messageLabel.centerX = self.alert.width / 2;
    
    CGFloat messageHeight = [self.messageLabel.text heightForFont:self.messageLabel.font width:self.messageLabel.width];
    if (messageHeight > self.messageLabel.height)
    {
        self.messageLabel.height = messageHeight;
    }
    
    if (!self.cancelButton.titleLabel.text.length)
    {
        self.cancelButton.hidden = YES;
    }
    
    if (!self.doneButton.titleLabel.text.length)
    {
        self.doneButton.hidden = YES;
    }
    
    NSInteger count = !self.cancelButton.hidden + !self.doneButton.hidden;
    UIView *items = [[UIView alloc] init];
    items.top = self.messageLabel.bottom + 20;
    [self.alert addSubview:items];
    for (NSInteger i = 0; i < count; i++)
    {
        UIButton *button;
        if (i == 0)
        {
            button = self.cancelButton.hidden ? self.doneButton : self.cancelButton;
        }
        else
        {
            button = self.doneButton;
        }
        button.left = i * (button.width + 20);
        items.width = button.right;
        items.height = button.height;
        [items addSubview:button];
    }
    items.centerX = self.alert.width / 2;
    
    
    self.alert.height = items.bottom + 20;
    self.alert.centerY = self.height / 2;
    [self addSubview:self.alert];
    self.alert.right = 0;
    [[AppDelegate delegate].window addSubview:self];
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alert.centerX = self.width / 2;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:.3 animations:^{
        self.alert.left = self.width;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (UIView *)alert
{
    if (!_alert)
    {
        _alert = [[UIView alloc] init];
        _alert.backgroundColor = [UIColor whiteColor];
        _alert.width = 280;
        _alert.centerX = self.width / 2;
        [_alert clipRadius:5 borderWidth:0 borderColor:[UIColor clearColor]];
        [_alert addSubview:self.titleLabel];
        [_alert addSubview:self.messageLabel];
        [_alert addSubview:self.doneButton];
        [_alert addSubview:self.cancelButton];
    }
    return _alert;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.size = CGSizeMake(220, 30);
        _titleLabel.textColor = UICOLOR_ARGB(0xff333333);
        _titleLabel.font = FONT_WITH_19;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)messageLabel
{
    if (!_messageLabel)
    {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.size = CGSizeMake(250, 40);
        _messageLabel.textColor = UICOLOR_ARGB(0xff444444);
        _messageLabel.font = FONT_WITH_18;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

- (UIButton *)doneButton
{
    if (!_doneButton)
    {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneButton.size = CGSizeMake(110, 42);
        [_doneButton setTitleColor:COLOR_YSYC_ORANGE forState:UIControlStateNormal];
        _doneButton.titleLabel.font = FONT_WITH_17;
        [_doneButton clipRadius:5 borderWidth:1 borderColor:COLOR_YSYC_ORANGE];
        [_doneButton addTarget:self action:@selector(doneTouchAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _doneButton;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton)
    {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.size = CGSizeMake(110, 42);
        [_cancelButton setTitleColor:UICOLOR_ARGB(0xff666666) forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = FONT_WITH_17;
        [_cancelButton clipRadius:5 borderWidth:1 borderColor:UICOLOR_ARGB(0xff666666)];
        [_cancelButton addTarget:self action:@selector(cancelTouchAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _cancelButton;
}

#pragma mark ACTION
- (void)doneTouchAction
{
    if (self.doneBlock)
    {
        self.doneBlock();
    }
    [self dismiss];
}

- (void)cancelTouchAction
{
    if (self.cancelBlock)
    {
        self.cancelBlock();
    }
    [self dismiss];
}


@end
