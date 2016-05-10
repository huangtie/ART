//
//  ARTCommentData.h
//  ART
//
//  Created by huangtie on 16/5/4.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARTCommentData : NSObject

//评论ID
@property (nonatomic , copy) NSString *commentID;

//评分
@property (nonatomic , copy) NSString *commentPoint;

//内容
@property (nonatomic , copy) NSString *commentText;

//评论时间
@property (nonatomic , copy) NSString *commentTime;

//用户ID
@property (nonatomic , copy) NSString *userID;

//昵称
@property (nonatomic , copy) NSString *userNick;

//头像
@property (nonatomic , copy) NSString *userImage;

@end
