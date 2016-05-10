//
//  ARTForgetParam.h
//  ART
//
//  Created by huangtie on 16/5/3.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBaseParam.h"

@interface ARTForgetParam : ARTBaseParam

//用户名
@property (nonatomic , copy) NSString *userName;

//手机号
@property (nonatomic , copy) NSString *userPhone;

//新密码
@property (nonatomic , copy) NSString *userPassword;

@end