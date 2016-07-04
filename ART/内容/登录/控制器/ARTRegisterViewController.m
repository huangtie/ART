//
//  ARTRegisterViewController.m
//  ART
//
//  Created by huangtie on 16/6/3.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTRegisterViewController.h"
#import "ARTRequestUtil.h"
#import "ARTLoginViewController.h"

@interface ARTRegisterViewController ()

@property (nonatomic , strong) UITextField *nameTextField;
@property (nonatomic , strong) UITextField *pawTextField;
@property (nonatomic , strong) UITextField *pawAgainTextField;
@property (nonatomic , strong) UITextField *nickTextField;

@property (nonatomic , strong) UIButton *registerButton;

@end

@implementation ARTRegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"注册艺赏雅藏账号";
    
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
    
    //密码
    UIView *pwdInput = [[UIView alloc] initWithFrame:CGRectMake(0, nameInput.bottom + 20, nameInput.width, nameInput.height)];
    pwdInput.centerX = self.view.width / 2;
    pwdInput.backgroundColor = [UIColor whiteColor];
    [pwdInput clipRadius:5 borderWidth:.5 borderColor:UICOLOR_ARGB(0xfffafafa)];
    [self.view addSubview:pwdInput];
    
    self.pawTextField.frame = self.nameTextField.frame;
    [pwdInput addSubview:self.pawTextField];
    
    //确认密码
    UIView *pwdAgainInput = [[UIView alloc] initWithFrame:CGRectMake(0, pwdInput.bottom + 20, pwdInput.width, pwdInput.height)];
    pwdAgainInput.centerX = self.view.width / 2;
    pwdAgainInput.backgroundColor = [UIColor whiteColor];
    [pwdAgainInput clipRadius:5 borderWidth:.5 borderColor:UICOLOR_ARGB(0xfffafafa)];
    [self.view addSubview:pwdAgainInput];
    
    self.pawAgainTextField.frame = self.pawTextField.frame;
    [pwdAgainInput addSubview:self.pawAgainTextField];
    
    //昵称
    UIView *nickInput = [[UIView alloc] initWithFrame:CGRectMake(0, pwdAgainInput.bottom + 20, pwdAgainInput.width, pwdAgainInput.height)];
    nickInput.centerX = self.view.width / 2;
    nickInput.backgroundColor = [UIColor whiteColor];
    [nickInput clipRadius:5 borderWidth:.5 borderColor:UICOLOR_ARGB(0xfffafafa)];
    [self.view addSubview:nickInput];
    
    self.nickTextField.frame = self.pawAgainTextField.frame;
    [nickInput addSubview:self.nickTextField];
    
    
    self.registerButton.top = nickInput.bottom + 45;
    self.registerButton.centerX = self.view.width / 2;
    [self.view addSubview:self.registerButton];
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
        _pawTextField.placeholder = @"密码";
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
        _pawAgainTextField.placeholder = @"确认密码";
        _pawAgainTextField.secureTextEntry = YES;
    }
    return _pawAgainTextField;
}

- (UITextField *)nickTextField
{
    if (!_nickTextField)
    {
        _nickTextField = [[UITextField alloc] init];
        _nickTextField.borderStyle = UITextBorderStyleNone;
        _nickTextField.textColor = UICOLOR_ARGB(0xff515151);
        _nickTextField.font = FONT_WITH_15;
        _nickTextField.placeholder = @"昵称(非必选)";
    }
    return _nickTextField;
}

- (UIButton *)registerButton
{
    if (!_registerButton)
    {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerButton.titleLabel.font = FONT_WITH_18;
        [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registerButton setBackgroundColor:COLOR_YSYC_ORANGE];
        _registerButton.size = CGSizeMake(367, 45);
        [_registerButton clipRadius:5 borderWidth:0 borderColor:[UIColor clearColor]];
        [_registerButton addTarget:self action:@selector(registerTouchAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

#pragma mark ACTION
- (void)registerTouchAction
{
    //校验用户名
    if (!self.nameTextField.text.length)
    {
        [self.view displayTostError:@"请输入用户名"];
        return;
    }
    
    NSString * regex = @"^[A-Za-z0-9]{3,15}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self.nameTextField.text];
    if (!isMatch)
    {
        [self.view displayTostError:@"用户名必须为3~15位以内字母与数字组合"];
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
    
    //校验昵称是否过长
    if (self.nickTextField.text.length > 20)
    {
        [self.view displayTostError:@"昵称过长"];
        return;
    }
    
    [self.view endEditing:YES];
    [self requestWithRegister];
}

#pragma mark REQUEST
- (void)requestWithRegister
{
    ARTRegisterParam *param = [[ARTRegisterParam alloc] init];
    param.userName = self.nameTextField.text;
    param.userPassword = self.pawTextField.text;
    param.userNick = self.nickTextField.text;
    
    [self displayHUD];
    WS(weak)
    [ARTRequestUtil requestRegister:param completion:^(NSURLSessionDataTask *task, ARTUserData *data) {
        [weak hideHUD];
        [weak performBlock:^{
            [weak.view displayTostSuccess:@"注册并登录成功"];
            [weak performBlock:^{
                [ARTUserManager sharedInstance].userinfo = data;
                NSInteger index = [weak.navigationController.viewControllers indexOfObject:weak];
                if (index > 1)
                {
                    [weak.navigationController popToViewController:weak.navigationController.viewControllers[index - 2] animated:YES];
                }
                else
                {
                    [weak.navigationController popViewControllerAnimated:YES];
                }
                
                if (weak.loginSuccessBlock)
                {
                    weak.loginSuccessBlock(data);
                }
            } afterDelay:1.5];
        } afterDelay:1];
    } failure:^(ErrorItemd *error) {
        [weak hideHUD];
        [weak.view displayTostError:error.errMsg];
    }];
}

@end
