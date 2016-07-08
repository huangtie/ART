//
//  ARTTalkData.h
//  ART
//
//  Created by huangtie on 16/5/5.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARTUserData.h"
#import "ARTTalkComData.h"

@interface ARTTalkData : NSObject

//说说ID
@property (nonatomic , copy) NSString *talkID;

//时间
@property (nonatomic , copy) NSString *talkTime;

//文字内容
@property (nonatomic , copy) NSString *talkText;

//是否所有人可见（0 否 1是）
@property (nonatomic , copy) NSString *talkAllLook;

//来自什么设备
@property (nonatomic , copy) NSString *talkFrom;

//说说图片
@property (nonatomic , strong) NSArray <NSString *> *talkImages;

//发布人 信息
@property (nonatomic , strong) ARTUserInfo *sender;

//赞数量
@property (nonatomic , copy) NSString *zanCount;

//点赞列表(只展示前10条)
@property (nonatomic , strong) NSArray *zanList;

//评论数量
@property (nonatomic , copy) NSString *comCount;

//评论列表(只展示前3条)
@property (nonatomic , strong) NSArray <ARTTalkComData *> *comList;

@end
