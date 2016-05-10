//
//  ARTCommentListParam.h
//  ART
//
//  Created by huangtie on 16/5/4.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBaseParam.h"

@interface ARTCommentListParam : ARTBaseParam

//图集ID
@property (nonatomic , copy) NSString *bookID;

//第几条
@property (nonatomic , copy) NSString *offset;

//一页几条
@property (nonatomic , copy) NSString *limit;

@end
