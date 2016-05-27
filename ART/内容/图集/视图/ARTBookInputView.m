//
//  ARTBookInputView.m
//  ART
//
//  Created by huangtie on 16/5/27.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBookInputView.h"
#import "ARTStarRatingView.h"

@interface ARTBookInputView()<StarRatingViewDelegate>

@property (nonatomic , strong) UITextField *textField;

@property (nonatomic , strong) UIButton *sendButton;

@property (nonatomic , strong) ARTStarRatingView *starRatingView;

@property (nonatomic , assign) CGFloat point;
@end

@implementation ARTBookInputView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.size = CGSizeMake(SCREEN_WIDTH, 75);
        self.backgroundColor = UICOLOR_ARGB(0xffe6e6e6);
        
        self.point = 3.0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        self.sendButton.centerY = self.centerY;
        self.sendButton.right = self.width - 15;
        [self addSubview:self.sendButton];
        
        CGFloat inputHeight = 45;
        UIView *inputContrl = [[UIView alloc] initWithFrame:CGRectMake(20, (self.height - inputHeight) / 2, 260, inputHeight)];
        inputContrl.backgroundColor = [UIColor whiteColor];
        [inputContrl clipRadius:4.0 borderWidth:0 borderColor:[UIColor clearColor]];
        [self addSubview:inputContrl];
        
        self.textField = [[UITextField alloc] init];
        self.textField.borderStyle = UITextBorderStyleNone;
        self.textField.placeholder = @"您此刻的想法...";
        self.textField.font = FONT_WITH_14;
        self.textField.textColor = UICOLOR_ARGB(0xff666666);
        self.textField.frame = CGRectMake(10, (inputContrl.height - 30) / 2, inputContrl.width - 20, 30);
        [inputContrl addSubview:self.textField];
        
        [self addSubview:self.starRatingView];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIButton *)sendButton
{
    if (!_sendButton)
    {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.size = CGSizeMake(150, 45);
        [_sendButton setBackgroundColor:UICOLOR_ARGB(0xfff4a629)];
        [_sendButton clipRadius:3.0 borderWidth:0 borderColor:[UIColor clearColor]];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton setTitle:@"发表评论" forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
        _sendButton.titleLabel.font = FONT_WITH_15;
    }
    return _sendButton;
}

- (ARTStarRatingView *)starRatingView
{
    if (!_starRatingView)
    {
        _starRatingView = [[ARTStarRatingView alloc] initWithFrame:CGRectMake(320, (self.height - 35) / 2, 175, 35) numberOfStar:5];
        _starRatingView.delegate = self;
        [_starRatingView setScore:self.point / 5 withAnimation:NO];
    }
    return _starRatingView;
}

#pragma mark ACTION
- (void)cleanText
{
    self.textField.text = @"";
}

- (void)sendClick
{
    if (!self.textField.text.length)
    {
        [self.viewController.view displayTostError:@"请输入评论内容!"];
        return;
    }
    
    [self.delegate bookInputViewDidDoSend:self.textField.text scole:[NSString stringWithFormat:@"%.1f",self.point]];
    [self.viewController.view endEditing:YES];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSUInteger curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationDuration:duration];
    self.top = keyboardFrame.origin.y - self.height;
    [UIView commitAnimations];
}

#pragma mark DELEGATE

- (void)starRatingView:(ARTStarRatingView *)view score:(CGFloat)score
{
    self.point = score * 5;
}


@end
