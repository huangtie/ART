//
//  ARTLoginParam.h
//  ART
//
//  Created by huangtie on 16/4/28.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBaseParam.h"

@interface ARTLoginParam : ARTBaseParam

//账号类型(0游客 1账号 2新浪 3QQ 4微信)
@property (nonatomic , copy) NSString *userType;

//用户名
@property (nonatomic , copy) NSString *userName;

//登录密码(base64加密)
@property (nonatomic , copy) NSString *userPassword;

//第三方唯一标识
@property (nonatomic , copy) NSString *userPart;

//第三方登录获取到的昵称
@property (nonatomic , copy) NSString *userNick;

@end
