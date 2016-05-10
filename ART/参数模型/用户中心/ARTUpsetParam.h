//
//  ARTUpsetParam.h
//  ART
//
//  Created by huangtie on 16/5/3.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBaseParam.h"

@interface ARTUpsetParam : ARTBaseParam

//用户昵称
@property (nonatomic , copy) NSString *userNick;

//手机号
@property (nonatomic , copy) NSString *userPhone;

//邮箱
@property (nonatomic , copy) NSString *userEmail;

//性别0：保密 1：男 2：女	是
@property (nonatomic , copy) NSString *userSex;

//省ID
@property (nonatomic , copy) NSString *userSheng;

//市ID
@property (nonatomic , copy) NSString *userShi;

//区ID
@property (nonatomic , copy) NSString *userQu;

//个性签名
@property (nonatomic , copy) NSString *userSign;

@end
