//
//  ARTForgetViewController.m
//  ART
//
//  Created by huangtie on 16/6/3.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTForgetViewController.h"
#import "ARTRequestUtil.h"

@interface ARTForgetViewController ()

@property (nonatomic , strong) UITextField *nameTextField;
@property (nonatomic , strong) UITextField *pawTextField;
@property (nonatomic , strong) UITextField *pawAgainTextField;
@property (nonatomic , strong) UITextField *phoneTextField;

@property (nonatomic , strong) UIButton *commitButton;

@property (nonatomic , strong) UILabel *tipLabel;

@end

@implementation ARTForgetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"忘记密码";
    
    self.view.backgroundColor = UICOLOR_ARGB(0xfff2f2f2);
    
    //用户名
    UIView *nameInput = [[UIView alloc] initWithFrame:CGRectMake(0, 145, 367, 45)];
    nameInput.centerX = self.view.width / 2;
    nameInput.backgroundColor = [UIColor whiteColor];
    [nameInput clipRadius:5 borderWidth:.5 borderColor:UICOLOR_ARGB(0xfffafafa)];
    [self.view addSubview:nameInput];
    
    self.nameTextField.size = CGSizeMake(nameInput.width - 30, 37);
    self.nameTextField.center = CGPointMake(nameInput.width / 2, nameInput.height / 2);
    [nameInput addSubview:self.nameTextField];
    
    //手机号
    UIView *phoneInput = [[UIView alloc] initWithFrame:CGRectMake(0, nameInput.bottom + 20, nameInput.width, nameInput.height)];
    phoneInput.centerX = self.view.width / 2;
    phoneInput.backgroundColor = [UIColor whiteColor];
    [phoneInput clipRadius:5 borderWidth:.5 borderColor:UICOLOR_ARGB(0xfffafafa)];
    [self.view addSubview:phoneInput];
    
    self.phoneTextField.frame = self.nameTextField.frame;
    [phoneInput addSubview:self.phoneTextField];
    
    //密码
    UIView *pwdInput = [[UIView alloc] initWithFrame:CGRectMake(0, phoneInput.bottom + 20, phoneInput.width, phoneInput.height)];
    pwdInput.centerX = self.view.width / 2;
    pwdInput.backgroundColor = [UIColor whiteColor];
    [pwdInput clipRadius:5 borderWidth:.5 borderColor:UICOLOR_ARGB(0xfffafafa)];
    [self.view addSubview:pwdInput];
    
    self.pawTextField.frame = self.phoneTextField.frame;
    [pwdInput addSubview:self.pawTextField];
    
    //确认密码
    UIView *pwdAgainInput = [[UIView alloc] initWithFrame:CGRectMake(0, pwdInput.bottom + 20, pwdInput.width, pwdInput.height)];
    pwdAgainInput.centerX = self.view.width / 2;
    pwdAgainInput.backgroundColor = [UIColor whiteColor];
    [pwdAgainInput clipRadius:5 borderWidth:.5 borderColor:UICOLOR_ARGB(0xfffafafa)];
    [self.view addSubview:pwdAgainInput];
    
    self.pawAgainTextField.frame = self.pawTextField.frame;
    [pwdAgainInput addSubview:self.pawAgainTextField];
    
    self.commitButton.top = pwdAgainInput.bottom + 45;
    self.commitButton.centerX = self.view.width / 2;
    [self.view addSubview:self.commitButton];
    
    self.tipLabel.size = self.commitButton.size;
    self.tipLabel.top = self.commitButton.bottom + 20;
    self.tipLabel.centerX = self.view.width / 2;
    [self.view addSubview:self.tipLabel];
}

#pragma mark GET-SET
- (UITextField *)nameTextField
{
    if (!_nameTextField)
    {
        _nameTextField = [[UITextField alloc] init];
        _nameTextField.borderStyle = UITextBorderStyleNone;
        _nameTextField.textColor = UICOLOR_ARGB(0xff515151);
        _nameTextField.font = FONT_WITH_15;
        _nameTextField.placeholder = @"用户名";
    }
    return _nameTextField;
}

- (UITextField *)pawTextField
{
    if (!_pawTextField)
    {
        _pawTextField = [[UITextField alloc] init];
        _pawTextField.borderStyle = UITextBorderStyleNone;
        _pawTextField.textColor = UICOLOR_ARGB(0xff515151);
        _pawTextField.font = FONT_WITH_15;
        _pawTextField.placeholder = @"新密码";
        _pawTextField.secureTextEntry = YES;
    }
    return _pawTextField;
}

- (UITextField *)pawAgainTextField
{
    if (!_pawAgainTextField)
    {
        _pawAgainTextField = [[UITextField alloc] init];
        _pawAgainTextField.borderStyle = UITextBorderStyleNone;
        _pawAgainTextField.textColor = UICOLOR_ARGB(0xff515151);
        _pawAgainTextField.font = FONT_WITH_15;
        _pawAgainTextField.placeholder = @"确认新密码";
        _pawAgainTextField.secureTextEntry = YES;
    }
    return _pawAgainTextField;
}

- (UITextField *)phoneTextField
{
    if (!_phoneTextField)
    {
        _phoneTextField = [[UITextField alloc] init];
        _phoneTextField.borderStyle = UITextBorderStyleNone;
        _phoneTextField.textColor = UICOLOR_ARGB(0xff515151);
        _phoneTextField.font = FONT_WITH_15;
        _phoneTextField.placeholder = @"已绑定的手机号";
    }
    return _phoneTextField;
}

- (UIButton *)commitButton
{
    if (!_commitButton)
    {
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitButton.titleLabel.font = FONT_WITH_18;
        [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_commitButton setBackgroundColor:COLOR_YSYC_ORANGE];
        _commitButton.size = CGSizeMake(367, 45);
        [_commitButton clipRadius:5 borderWidth:0 borderColor:[UIColor clearColor]];
        [_commitButton addTarget:self action:@selector(commitTouchAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitButton;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel)
    {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = FONT_WITH_15;
        _tipLabel.textColor = UICOLOR_ARGB(0xfff70521);
        _tipLabel.text = @"温馨提示：如您尚未绑定过手机号,将无法使用此功能。如需找回密码,请联系艺赏雅藏客服";
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}

#pragma mark ACTION
- (void)commitTouchAction
{
    //校验用户名
    if (!self.nameTextField.text.length)
    {
        [self.view displayTostError:@"请输入用户名"];
        return;
    }
    
    //校验手机号
    if (!self.phoneTextField.text.length)
    {
        [self.view displayTostError:@"请输入手机号"];
        return;
    }
    
    if (![self.phoneTextField.text isMobileNumber])
    {
        [self.view displayTostError:@"请输入正确格式的手机号"];
        return;
    }
    
    //校验密码
    if (!self.pawTextField.text.length)
    {
        [self.view displayTostError:@"请输入密码"];
        return;
    }
    
    NSString * regex2 = @"^[A-Za-z0-9]{6,15}$";
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    BOOL isMatch2 = [pred2 evaluateWithObject:self.pawTextField.text];
    if (!isMatch2)
    {
        [self.view displayTostError:@"密码必须为6~15位以内字母与数字组合"];
        return;
    }
    
    //校验再次输入密码
    if (![self.pawTextField.text isEqualToString:self.pawAgainTextField.text])
    {
        [self.view displayTostError:@"密码前后输入不一致"];
        return;
    }
    
    [self.view endEditing:YES];
    [self requestWithCommit];
}

#pragma mark REQUEST
- (void)requestWithCommit
{
    ARTForgetParam *param = [[ARTForgetParam alloc] init];
    param.userName = self.nameTextField.text;
    param.userPassword = self.pawTextField.text;
    param.userPhone = self.phoneTextField.text;
    
    [self displayHUD];
    WS(weak)
    [ARTRequestUtil requestFinepassword:param completion:^(NSURLSessionDataTask *task) {
        [weak hideHUD];
        [weak performBlock:^{
            [weak.view displayTostSuccess:@"密码修改成功"];
            [weak performBlock:^{
                [weak.navigationController popViewControllerAnimated:YES];
            } afterDelay:1.5];
        } afterDelay:1];
    } failure:^(ErrorItemd *error) {
        [weak hideHUD];
        [weak.view displayTostError:error.errMsg];
    }];
}

@end
