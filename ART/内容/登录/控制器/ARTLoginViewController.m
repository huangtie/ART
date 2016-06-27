//
//  ARTLoginViewController.m
//  ART
//
//  Created by huangtie on 16/6/2.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTLoginViewController.h"
#import "ARTShareUtil.h"
#import "ARTRequestUtil.h"
#import "ARTUdidUtil.h"
#import "ARTForgetViewController.h"

typedef enum
{
    LOGIN_TYPE_VISITOR,             //以游客身份登录
    LOGIN_TYPE_ACCOUNT,             //使用账号登录
    LOGIN_TYPE_WEIBO,               //微博
    LOGIN_TYPE_QQ,                  //QQ
    LOGIN_TYPE_WECHAT,              //微信
}LOGIN_TYPE;

@interface ARTLoginViewController()

@property (nonatomic , strong) UITextField *nameTextField;
@property (nonatomic , strong) UITextField *pawTextField;

@property (nonatomic , strong) UIButton *rememberButton;
@property (nonatomic , strong) UIButton *loginButton;
@property (nonatomic , strong) UIButton *visitorButton;

@property (nonatomic , strong) NSMutableArray <NSDictionary *> *loginTypes;

@end

@implementation ARTLoginViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"登录艺赏雅藏";
    
    self.view.backgroundColor = UICOLOR_ARGB(0xfff2f2f2);
    
    if (self.rememberButton.selected)
    {
        NSDictionary *dic = [ARTUdidUtil loadAccount];
        if (dic)
        {
            self.nameTextField.text = dic[@"name"];
            self.pawTextField.text = dic[@"pwd"];
        }
    }
    
    UIView *nameInput = [[UIView alloc] initWithFrame:CGRectMake(0, 145, 367, 45)];
    nameInput.centerX = self.view.width / 2;
    nameInput.backgroundColor = [UIColor whiteColor];
    [nameInput clipRadius:5 borderWidth:.5 borderColor:UICOLOR_ARGB(0xfffafafa)];
    [self.view addSubview:nameInput];
    
    self.nameTextField.size = CGSizeMake(nameInput.width - 30, 37);
    self.nameTextField.center = CGPointMake(nameInput.width / 2, nameInput.height / 2);
    [nameInput addSubview:self.nameTextField];
    
    UIView *pwdInput = [[UIView alloc] initWithFrame:CGRectMake(0, nameInput.bottom + 20, nameInput.width, nameInput.height)];
    pwdInput.centerX = self.view.width / 2;
    pwdInput.backgroundColor = [UIColor whiteColor];
    [pwdInput clipRadius:5 borderWidth:.5 borderColor:UICOLOR_ARGB(0xfffafafa)];
    [self.view addSubview:pwdInput];
    
    self.pawTextField.frame = self.nameTextField.frame;
    [pwdInput addSubview:self.pawTextField];
    
    self.rememberButton.top = pwdInput.bottom + 10;
    self.rememberButton.left = pwdInput.left + 15;
    [self.view addSubview:self.rememberButton];
    
    self.loginButton.top = self.rememberButton.bottom + 25;
    self.loginButton.centerX = self.view.width / 2;
    [self.view addSubview:self.loginButton];
    
    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetButton.titleLabel.font = FONT_WITH_16;
    [forgetButton setTitleColor:COLOR_YSYC_ORANGE forState:UIControlStateNormal];
    [forgetButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetButton setBackgroundColor:[UIColor clearColor]];
    [forgetButton sizeToFit];
    [forgetButton addTarget:self action:@selector(forgetTouchAction) forControlEvents:UIControlEventTouchUpInside];
    forgetButton.height = 35;
    forgetButton.top = self.loginButton.bottom + 15;
    forgetButton.right = self.loginButton.right;
    [self.view addSubview:forgetButton];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.titleLabel.font = FONT_WITH_16;
    [registerButton setTitleColor:COLOR_YSYC_ORANGE forState:UIControlStateNormal];
    [registerButton setTitle:@"立即注册" forState:UIControlStateNormal];
    [registerButton setBackgroundColor:[UIColor clearColor]];
    [registerButton sizeToFit];
    [registerButton addTarget:self action:@selector(registerTouchAction) forControlEvents:UIControlEventTouchUpInside];
    registerButton.height = 35;
    registerButton.top = self.loginButton.bottom + 15;
    registerButton.right = forgetButton.left - 30;
    [self.view addSubview:registerButton];
    
    UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_3"]];
    [line sizeToFit];
    line.top = registerButton.bottom + 40;
    line.centerX = self.view.width / 2;
    [self.view addSubview:line];
    
    self.loginTypes = [NSMutableArray array];
    NSMutableDictionary *weibo = [[NSMutableDictionary alloc] init];
    [weibo setObject:@"login_4" forKey:@"image"];
    [weibo setObject:@(SHARE_DESTINATION_WEIBO) forKey:@"type"];
    [self.loginTypes addObject:weibo];
    
    NSMutableDictionary *qq = [[NSMutableDictionary alloc] init];
    [qq setObject:@"login_5" forKey:@"image"];
    [qq setObject:@(SHARE_DESTINATION_ZONE) forKey:@"type"];
    [self.loginTypes addObject:qq];
    
    NSMutableDictionary *wechat = [[NSMutableDictionary alloc] init];
    [wechat setObject:@"login_6" forKey:@"image"];
    [wechat setObject:@(SHARE_DESTINATION_WECHAT) forKey:@"type"];
    [self.loginTypes addObject:wechat];
    
    if (![QQApiInterface isQQInstalled])
    {
        [self.loginTypes removeObject:qq];
    }
    
    if (![WXApi isWXAppInstalled])
    {
        [self.loginTypes removeObject:wechat];
    }
    UIView *itemView = [[UIView alloc] init];
    for (NSInteger i = 0; i < self.loginTypes.count; i ++)
    {
        NSDictionary *dic = self.loginTypes[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:dic[@"image"]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(loginItemsClick:) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        CGFloat padding = 93;
        button.left = i * (button.width + padding);
        itemView.height = button.height;
        itemView.width = button.right;
        [itemView addSubview:button];
    }
    itemView.top = line.bottom + 30;
    itemView.centerX = self.view.width / 2;
    [self.view addSubview:itemView];
    
    self.visitorButton.top = itemView.bottom + 30;
    self.visitorButton.centerX = self.view.width / 2;
    [self.view addSubview:self.visitorButton];
}

#pragma mark METHOD

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

- (UIButton *)rememberButton
{
    if (!_rememberButton)
    {
        _rememberButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rememberButton setBackgroundImage:[UIImage imageNamed:@"login_2"] forState:UIControlStateNormal];
        [_rememberButton setBackgroundImage:[UIImage imageNamed:@"login_1"] forState:UIControlStateSelected];
        _rememberButton.selected = [ARTUdidUtil isRemmenber];
        [_rememberButton sizeToFit];
        [_rememberButton addTarget:self action:@selector(rememberTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rememberButton;
}

- (UIButton *)loginButton
{
    if (!_loginButton)
    {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.titleLabel.font = FONT_WITH_18;
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setBackgroundColor:COLOR_YSYC_ORANGE];
        _loginButton.size = CGSizeMake(367, 45);
        [_loginButton clipRadius:5 borderWidth:0 borderColor:[UIColor clearColor]];
        [_loginButton addTarget:self action:@selector(loginTouchAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UIButton *)visitorButton
{
    if (!_visitorButton)
    {
        _visitorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _visitorButton.titleLabel.font = FONT_WITH_18;
        [_visitorButton setTitleColor:COLOR_YSYC_ORANGE forState:UIControlStateNormal];
        [_visitorButton setTitle:@"不想登录,以游客身份逛逛>>" forState:UIControlStateNormal];
        [_visitorButton setBackgroundColor:[UIColor clearColor]];
        _visitorButton.size = CGSizeMake(367, 45);
        [_visitorButton clipRadius:5 borderWidth:1 borderColor:COLOR_YSYC_ORANGE];
        [_visitorButton addTarget:self action:@selector(visitorTouchAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _visitorButton;
}

#pragma mark ACTION
//记住用户名和密码
- (void)rememberTouchAction:(UIButton *)button
{
    button.selected = !button.selected;
    [ARTUdidUtil remmenber:button.selected];
}

//登录
- (void)loginTouchAction
{
    if (!self.nameTextField.text.length)
    {
        [self.view displayTostError:@"请输入用户名"];
        return;
    }
    if (!self.pawTextField.text.length)
    {
        [self.view displayTostError:@"请输入密码"];
        return;
    }
    
    if (self.rememberButton.selected)
    {
        [ARTUdidUtil saveAccoutName:self.nameTextField.text pwd:self.pawTextField.text];
    }
    [self requestWithLogin:LOGIN_TYPE_ACCOUNT part:nil nick:nil];
}

//游客身份登录
- (void)visitorTouchAction
{
    [self requestWithLogin:LOGIN_TYPE_VISITOR part:nil nick:nil];
}

//忘记密码
- (void)forgetTouchAction
{
    [self.navigationController pushViewController:[[ARTForgetViewController alloc] init] animated:YES];
}

//注册
- (void)registerTouchAction
{
    ARTRegisterViewController *regisetVC = [[ARTRegisterViewController alloc] init];
    if (self.loginSuccessBlock)
    {
        regisetVC.loginSuccessBlock = self.loginSuccessBlock;
    }
    [self.navigationController pushViewController:regisetVC animated:YES];
}

//第三方登录
- (void)loginItemsClick:(UIButton *)button
{
    NSInteger index = [button.superview.subviews indexOfObject:button];
    NSDictionary *dic = self.loginTypes[index];
    SHARE_DESTINATION dest = (SHARE_DESTINATION)[dic[@"type"] integerValue];
    WS(weak)
    [ARTShareUtil loginThird:dest completion:^(id<ISSPlatformCredential> credential , id<ISSPlatformUser> userInfo) {
        NSDictionary *dic = [userInfo sourceData];
        [weak requestWithLogin:(LOGIN_TYPE)(index + 2) part:[credential uid] nick:[dic objectForKey:@"nickname"]];
    }];
}

#pragma mark REQUEST
- (void)requestWithLogin:(LOGIN_TYPE)type
                    part:(NSString *)part
                    nick:(NSString *)nick
{
    [self.view endEditing:YES];
    
    ARTLoginParam *param = [[ARTLoginParam alloc] init];
    param.userType = STRING_FORMAT_ADC(@(type));
    param.userName = self.nameTextField.text;
    param.userPassword = self.pawTextField.text;
    param.userPart = part;
    param.userNick = nick;
    
    [self displayHUD];
    WS(weak)
    [ARTRequestUtil requestLogin:param completion:^(NSURLSessionDataTask *task, ARTUserData *data) {
        [weak hideHUD];
        [ARTUserManager sharedInstance].userinfo = data;
        [weak.view displayTostSuccess:@"登录成功"];
        [weak performBlock:^{
            [weak.navigationController popViewControllerAnimated:YES];
            if (weak.loginSuccessBlock)
            {
                weak.loginSuccessBlock(data);
            }
//            NSMutableArray *array = [NSMutableArray array];
//            for (UIViewController *vc in weak.navigationController.viewControllers)
//            {
//                if (![vc isKindOfClass:weak.class])
//                {
//                    [array addObject:vc];
//                }
//            }
//            weak.navigationController.viewControllers = array;
        } afterDelay:1.5];
    } failure:^(ErrorItemd *error) {
        [weak hideHUD];
        [weak.view displayTostError:error.errMsg];
    }];
    
}

@end
