//
//  ARTTalkComData.h
//  ART
//
//  Created by huangtie on 16/5/6.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARTTalkReplayData : NSObject

//消息ID
@property (nonatomic , copy) NSString *replayID;

//回复人ID
@property (nonatomic , copy) NSString *replayUser;

//回复人昵称
@property (nonatomic , copy) NSString *replayNick;

//回复人头像
@property (nonatomic , copy) NSString *replayImage;

//被回复人ID
@property (nonatomic , copy) NSString *acceptUser;

//被回复人昵称
@property (nonatomic , copy) NSString *acceptNick;

//被回复人头像
@property (nonatomic , copy) NSString *acceptImage;

//回复内容
@property (nonatomic , copy) NSString *replayText;

//回复时间
@property (nonatomic , copy) NSString *replayTime;

@end

@interface ARTTalkComData : NSObject

//评论ID
@property (nonatomic , copy) NSString *comID;

//评论人ID
@property (nonatomic , copy) NSString *comUser;

//评论人昵称
@property (nonatomic , copy) NSString *comNick;

//评论人头像
@property (nonatomic , copy) NSString *comImage;

//评论内容
@property (nonatomic , copy) NSString *comText;

//评论时间
@property (nonatomic , copy) NSString *comTime;

//回复列表
@property (nonatomic , strong) NSArray <ARTTalkReplayData *> *replays;


@end
