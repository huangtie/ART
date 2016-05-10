//
//  ARTRegisterParam.h
//  ART
//
//  Created by huangtie on 16/4/29.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBaseParam.h"

@interface ARTRegisterParam : ARTBaseParam

//用户名
@property (nonatomic , copy) NSString *userName;

//登录密码
@property (nonatomic , copy) NSString *userPassword;

//昵称
@property (nonatomic , copy) NSString *userNick;

@end
