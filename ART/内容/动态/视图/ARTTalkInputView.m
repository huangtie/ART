//
//  ARTTalkInputView.m
//  ART
//
//  Created by huangtie on 16/7/6.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTTalkInputView.h"

@interface ARTTalkInputView()


@end

@implementation ARTTalkInputView


#define HEIGHT 80
#define RECT_WIDTH 550
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.size = CGSizeMake(SCREEN_WIDTH, HEIGHT);
        self.backgroundColor = UICOLOR_ARGB(0xffe6e6e6);
        
        UIView *rect = [[UIView alloc] init];
        rect.size = CGSizeMake(RECT_WIDTH, HEIGHT - 20);
        rect.left = 30;
        rect.centerY = self.height / 2;
        rect.backgroundColor = [UIColor whiteColor];
        [rect clipRadius:5 borderWidth:1 borderColor:[UIColor whiteColor]];
        [self addSubview:rect];
        
        self.textField = [[UITextField alloc] init];
        self.textField.size = CGSizeMake(rect.width - 40, rect.height - 20);
        self.textField.center = CGPointMake(rect.width / 2, rect.height / 2);
        self.textField.font = FONT_WITH_18;
        self.textField.textColor = UICOLOR_ARGB(0xff333333);
        [rect addSubview:self.textField];
        
        UIButton *send = [UIButton buttonWithType:UIButtonTypeCustom];
        send.backgroundColor = COLOR_YSYC_ORANGE;
        send.size = CGSizeMake(140, rect.height);
        send.left = rect.right + (self.width - rect.right - send.width) / 2;
        send.centerY = self.height / 2;
        send.titleLabel.font = FONT_WITH_17;
        [send setTitle:@"发送" forState:UIControlStateNormal];
        [send setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [send clipRadius:4 borderWidth:0 borderColor:nil];
        [send addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:send];
    }
    return self;
}

- (void)beginInput:(ARTSendTalkComParam *)param
{
    self.param = param;
    self.textField.text = @"";
    
    if (param.replayID.length)
    {
        self.textField.placeholder = [NSString stringWithFormat:@"回复 %@ :",param.replayNick];
    }
    else
    {
        self.textField.placeholder = @"评论";
    }
    [self.textField becomeFirstResponder];
}

- (void)sendAction
{
    if (!self.textField.text.length)
    {
        [self.viewController.view displayTostError:@"请输入要评论的文字"];
        return;
    }
    
    if (self.textField.text.length > 400)
    {
        [self.viewController.view displayTostError:@"评论的字数不能大于400个字"];
        return;
    }
    
    self.param.text = self.textField.text;
    [self.delegate inputDidTouchSend:self.param];
}












@end
