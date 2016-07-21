//
//  ARTRecorderControl.m
//  ART
//
//  Created by huangtie on 16/7/15.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTRecorderControl.h"
#import "ARTPlayAnimation.h"
#import "EMCDDeviceManager.h"

@interface ARTRecorderControl()

@property (nonatomic , strong) UIButton *recordButton;

@property (nonatomic , strong) UILabel *tipLabel;

@property (nonatomic , strong) UILabel *cancelTipLabel;

@property (nonatomic , strong) UIButton *cancelButton;

@property (nonatomic , strong) UIView *bottomView;

@property (nonatomic , strong) ARTPlayAnimation *playAnimation;

@end

#define KEYBOARD_WIDTH 768
#define KEYBOARD_HEIGHT 383
#define TIP_RECORD_BEFORE @"按住开始说话"
#define TIP_RECORD_ING @"正在录音,松开发送"
@implementation ARTRecorderControl

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.size = CGSizeMake(KEYBOARD_WIDTH, KEYBOARD_HEIGHT);
        self.backgroundColor = [UIColor whiteColor];
        
        self.recordButton.center = CGPointMake(self.width / 2, self.height / 2);
        [self addSubview:self.recordButton];
        [self addSubview:self.bottomView];
        
        self.cancelButton.center = CGPointMake(self.recordButton.right + (self.width - self.recordButton.right) / 2, self.height / 2);
        [self addSubview:self.cancelButton];
        self.cancelTipLabel.centerX = self.cancelButton.centerX;
        self.cancelTipLabel.bottom = self.cancelButton.top - 50;
        [self addSubview:self.cancelTipLabel];
        
        self.tipLabel.center = CGPointMake(self.width / 2, self.recordButton.top / 2);
        self.tipLabel.bottom = self.recordButton.top - 20;
        [self addSubview:self.tipLabel];
        self.playAnimation.centerX = self.width / 2;
        self.playAnimation.bottom = self.tipLabel.top - 10;
        [self addSubview:self.playAnimation];
    }
    return self;
}

#pragma mark MEA
- (void)startRecord
{
    [self.playAnimation beginAnimation:YES];
    
    [[EMCDDeviceManager sharedInstance] stopPlaying];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"%@",@(time)];
    
    [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName
                                                             completion:^(NSError *error)
     {
         if (error)
         {
             NSLog(NSLocalizedString(@"message.startRecordFail", @"failure to start recording"));
         }
     }];
}

- (void)stopRecord
{
    WS(weak)
    [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        if (!error)
        {
            EMVoiceMessageBody *body = [[EMVoiceMessageBody alloc] initWithLocalPath:recordPath displayName:@"record"];
            body.duration = (int)aDuration;
            [weak.delegate recorderDidRecordCompletion:body];
        }
        else
        {
            [weak.delegate recorderDidRecordError:error];
        }
    }];
}

- (void)cancelRecord
{
    [[EMCDDeviceManager sharedInstance] cancelCurrentRecording];
    [self.delegate recorderDidCancel];
}

#pragma mark GET_SET
- (UIButton *)cancelButton
{
    if (!_cancelButton)
    {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"chat_icon_10"] forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"chat_icon_11"] forState:UIControlStateSelected];
        [_cancelButton sizeToFit];
    }
    return _cancelButton;
}

- (UIButton *)recordButton
{
    if (!_recordButton)
    {
        _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordButton setBackgroundImage:[UIImage imageNamed:@"chat_icon_12"] forState:UIControlStateNormal];
        [_recordButton sizeToFit];
        [_recordButton addTarget:self action:@selector(recordTouchDown) forControlEvents:UIControlEventTouchDown];
        [_recordButton addTarget:self action:@selector(recordTouchDragOutside:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
        [_recordButton addTarget:self action:@selector(recordTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [_recordButton addTarget:self action:@selector(recordTouchUpOutside:withEvent:) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _recordButton;
}

- (UIView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIView alloc] init];
        _bottomView.size = CGSizeMake(KEYBOARD_WIDTH, 60);
        _bottomView.backgroundColor = UICOLOR_ARGB(0xfff8f8f8);
        _bottomView.bottom = KEYBOARD_HEIGHT;
        
        UIButton *keyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [keyButton setBackgroundImage:[UIImage imageNamed:@"chat_icon_19"] forState:UIControlStateNormal];
        [keyButton sizeToFit];
        keyButton.centerY = _bottomView.height / 2;
        keyButton.left = 30;
        [keyButton addTarget:self action:@selector(keyboardAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:keyButton];
    }
    return _bottomView;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel)
    {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = FONT_WITH_22;
        _tipLabel.size = CGSizeMake(400, 30);
        _tipLabel.textColor = UICOLOR_ARGB(0xff555555);
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.text = TIP_RECORD_BEFORE;
    }
    return _tipLabel;
}

- (UILabel *)cancelTipLabel
{
    if (!_cancelTipLabel)
    {
        _cancelTipLabel = [[UILabel alloc] init];
        _cancelTipLabel.font = FONT_WITH_19;
        _cancelTipLabel.size = CGSizeMake(100, 30);
        _cancelTipLabel.textColor = UICOLOR_ARGB(0xffff3b43);
        _cancelTipLabel.textAlignment = NSTextAlignmentCenter;
        _cancelTipLabel.text = @"松开取消";
        _cancelTipLabel.hidden = YES;
    }
    return _cancelTipLabel;
}

- (ARTPlayAnimation *)playAnimation
{
    if (!_playAnimation)
    {
        _playAnimation = [[ARTPlayAnimation alloc] init];
        _playAnimation.isLeft = YES;
    }
    return _playAnimation;
}

#pragma mark ACTION
- (void)keyboardAction
{
    [self.delegate recorderDidClickKeyboard];
}

- (void)recordTouchDown
{
    [self.delegate recorderDidBeginRecord];
    self.tipLabel.text = TIP_RECORD_ING;
    [self startRecord];
}

- (void)recordTouchDragOutside:(UIButton *)button withEvent:(UIEvent *)event
{
    button.highlighted = YES;
    UITouch *touch = [[event allTouches] anyObject];
    BOOL touchOutside = CGRectContainsPoint(self.cancelButton.frame, [touch locationInView:self]);
    self.cancelButton.selected = touchOutside;
    self.cancelTipLabel.hidden = !touchOutside;
}

- (void)recordTouchUpInside
{
    self.tipLabel.text = TIP_RECORD_BEFORE;
    self.cancelButton.selected = NO;
    self.cancelTipLabel.hidden = YES;
    [self.playAnimation stopAnimation];
    [self stopRecord];
}

- (void)recordTouchUpOutside:(UIButton *)button withEvent:(UIEvent *)event
{
    self.tipLabel.text = TIP_RECORD_BEFORE;
    self.cancelButton.selected = NO;
    self.cancelTipLabel.hidden = YES;
    [self.playAnimation stopAnimation];
    
    UITouch *touch = [[event allTouches] anyObject];
    BOOL touchOutside = CGRectContainsPoint(self.cancelButton.frame, [touch locationInView:self]);
    if (touchOutside)
    {
        [self cancelRecord];
    }
    else
    {
        [self stopRecord];
    }
}















@end
