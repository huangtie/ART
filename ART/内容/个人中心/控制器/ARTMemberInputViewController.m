//
//  ARTMemberInputViewController.m
//  ART
//
//  Created by huangtie on 16/6/24.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTMemberInputViewController.h"

@interface ARTMemberInputViewController()

@property (nonatomic , strong) UIView *inputRectView;

@property (nonatomic , strong) UITextView *textView;

@property (nonatomic , strong) UIButton *finishButton;

@property (nonatomic , strong) NSString *titleText;

@property (nonatomic , strong) NSString *text;
@end

@implementation ARTMemberInputViewController

+ (ARTMemberInputViewController *)launchViewController:(UIViewController *)viewController
                                                 title:(NSString *)title
                                                  text:(NSString *)text
                                            inputBlock:(ARTMemberInputBlock)inputBlock
{
    ARTMemberInputViewController *inputVC = [[ARTMemberInputViewController alloc] init];
    inputVC.titleText = title;
    inputVC.text = text;
    inputVC.inputBlock = inputBlock;
    [viewController.navigationController pushViewController:inputVC animated:YES];
    return inputVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_YSYC_GRAY;
    self.title = [NSString stringWithFormat:@"编辑%@",self.titleText];
    self.textView.text = self.text;
    
    self.inputRectView.top = NAVIGATION_HEIGH + 10;
    [self.inputRectView addSubview:self.textView];
    [self.view addSubview:self.inputRectView];
    self.finishButton.top = self.inputRectView.bottom + 40;
    [self.view addSubview:self.finishButton];
}

- (void)dealloc
{
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

#pragma mark GET_SET
- (UIView *)inputRectView
{
    if (!_inputRectView)
    {
        _inputRectView = [[UIView alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 310)];
        _inputRectView.backgroundColor = [UIColor whiteColor];
        [_inputRectView clipRadius:3 borderWidth:.5 borderColor:UICOLOR_ARGB(0xfff0f0f0)];
    }
    return _inputRectView;
}

- (UITextView *)textView
{
    if (!_textView)
    {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 15, self.inputRectView.width - 30, self.inputRectView.height - 30)];
        _textView.font = FONT_WITH_16;
        _textView.textColor = UICOLOR_ARGB(0xff333333);
    }
    return _textView;
}

- (UIButton *)finishButton
{
    if (!_finishButton)
    {
        _finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _finishButton.size = CGSizeMake(400, 50);
        _finishButton.backgroundColor = COLOR_YSYC_ORANGE;
        [_finishButton setTitle:@"完成编辑" forState:UIControlStateNormal];
        [_finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _finishButton.titleLabel.font = FONT_WITH_16;
        [_finishButton clipRadius:5 borderWidth:0 borderColor:nil];
        [_finishButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
        _finishButton.centerX = SCREEN_WIDTH / 2;
    }
    return _finishButton;
}

#pragma mark ACTION
- (void)finishAction
{
    if ([self.titleText isEqualToString:@"手机号"])
    {
        if (![self.textView.text isMobileNumber])
        {
            [self.view displayTostError:@"请输入正确格式的手机号"];
            return;
        }
    }
    
    if ([self.titleText isEqualToString:@"邮箱"])
    {
        if (![self.textView.text isEmailNumber])
        {
            [self.view displayTostError:@"请输入正确格式的邮箱"];
            return;
        }
    }
    
    if ([self.titleText isEqualToString:@"昵称"])
    {
        if (!self.textView.text.length)
        {
            [self.view displayTostError:@"昵称不允许为空"];
            return;
        }
        
        if (self.textView.text.length > 20)
        {
            [self.view displayTostError:@"昵称过长"];
            return;
        }
    }
    
    if ([self.titleText isEqualToString:@"个性签名"])
    {
        if (self.textView.text.length > 500)
        {
            [self.view displayTostError:@"个性签名过长"];
            return;
        }
    }
    
    if (self.inputBlock)
    {
        self.inputBlock(self.textView.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
















@end
