//
//  ARTSendTalkComParam.h
//  ART
//
//  Created by huangtie on 16/5/5.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBaseParam.h"

@interface ARTSendTalkComParam : ARTBaseParam

//说说ID
@property (nonatomic , copy) NSString *talkID;

//回复某条评论
@property (nonatomic , copy) NSString *replayID;

//回复某人（传replayID则必须）
@property (nonatomic , copy) NSString *accept;

//内容
@property (nonatomic , copy) NSString *text;

//回复某人的昵称
@property (nonatomic , copy) NSString *replayNick;

@end
