//
//  ARTBookListParam.h
//  ART
//
//  Created by huangtie on 16/5/4.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBaseParam.h"

@interface ARTBookListParam : ARTBaseParam

//图集分类ID
@property (nonatomic , copy) NSString *bookGroup;

//是否会员图集(0 非 1 是)
@property (nonatomic , copy) NSString *bookVIP;

//排序(1 按下载量排序) 默认按时间
@property (nonatomic , copy) NSString *bookOrder;

//是否收费(0 免费 1收费),不传则全部
@property (nonatomic , copy) NSString *bookFree;

//作者ID
@property (nonatomic , copy) NSString *bookAuthor;

//搜索的关键字
@property (nonatomic , copy) NSString *key;

//第几条
@property (nonatomic , copy) NSString *offset;

//一页几条(默认10)
@property (nonatomic , copy) NSString *limit;

@end
