//
//  ARTUserData.h
//  ART
//
//  Created by huangtie on 16/4/28.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARTUserCity : NSObject

//省ID
@property (nonatomic , copy) NSString *codeSheng;

//省名称
@property (nonatomic , copy) NSString *nameSheng;

//市ID
@property (nonatomic , copy) NSString *codeShi;

//市名称
@property (nonatomic , copy) NSString *nameShi;

//区ID
@property (nonatomic , copy) NSString *codeQu;

//区名称
@property (nonatomic , copy) NSString *nameQu;

@end

@interface ARTUserInfo : NSObject

//用户ID
@property (nonatomic , copy) NSString *userID;

//用户名
@property (nonatomic , copy) NSString *userName;

//昵称
@property (nonatomic , copy) NSString *userNick;

//手机号
@property (nonatomic , copy) NSString *userPhone;

//邮箱
@property (nonatomic , copy) NSString *userEmail;

//性别（0 男 1女）
@property (nonatomic , copy) NSString *userSex;

//个性签名
@property (nonatomic , copy) NSString *userSign;

//头像
@property (nonatomic , copy) NSString *userImage;

//金币个数
@property (nonatomic , copy) NSString *userPrice;

//账户金额
@property (nonatomic , copy) NSString *userMoney;

//账号类型(0游客 1账号 2新浪 3QQ 4微信)
@property (nonatomic , copy) NSString *userType;

//是否会员（0 否 1是）
@property (nonatomic , copy) NSString *userVIP;

//资料是否好友才可见(0 所有人可见 1 只有关注的人可见)
@property (nonatomic , copy) NSString *userLook;

//是否已关注
@property (nonatomic , copy) NSString *isFan;

//地区
@property (nonatomic , strong) ARTUserCity *userCity;

@end

@interface ARTUserData : NSObject

//登录标志
@property (nonatomic , copy) NSString *c;

@property (nonatomic , strong) ARTUserInfo *userInfo;

@end
