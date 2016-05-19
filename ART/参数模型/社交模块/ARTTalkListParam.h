//
//  ARTTalkListParam.h
//  ART
//
//  Created by huangtie on 16/5/19.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBaseParam.h"

@interface ARTTalkListParam : ARTBaseParam

//0 仅关注的 1 所有
@property (nonatomic , copy) NSString *talkAllLook;

//用户ID
@property (nonatomic , copy) NSString *userID;

//第几条
@property (nonatomic , copy) NSString *offset;

//一页几条
@property (nonatomic , copy) NSString *limit;

@end
