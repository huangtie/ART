//
//  ARTCommentSendParam.h
//  ART
//
//  Created by huangtie on 16/5/4.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBaseParam.h"

@interface ARTCommentSendParam : ARTBaseParam

//图集ID
@property (nonatomic , copy) NSString *bookID;

//评论内容
@property (nonatomic , copy) NSString *commentText;

//评分
@property (nonatomic , copy) NSString *commentPoint;

@end
