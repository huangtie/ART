//
//  ARTBookData.h
//  ART
//
//  Created by huangtie on 16/5/4.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARTAuthorData.h"

@interface ARTBookData : NSObject

//图集ID
@property (nonatomic , copy) NSString *bookID;

//图集名称
@property (nonatomic , copy) NSString *bookName;

//图集简介
@property (nonatomic , copy) NSString *bookRemark;

//图集创建时间
@property (nonatomic , copy) NSString *bookTime;

//封面图片
@property (nonatomic , copy) NSString *bookImage;

//分类ID
@property (nonatomic , copy) NSString *bookGroup;

//页数
@property (nonatomic , copy) NSString *bookPage;

//完成状态
@property (nonatomic , copy) NSString *bookState;

//是否收费（0 免费 1收费）
@property (nonatomic , copy) NSString *bookFree;

//是否会员图集（0 否 1 是）
@property (nonatomic , copy) NSString *bookVIP;

//图集价格(金币个数)
@property (nonatomic , copy) NSString *bookPrice;

//下载量
@property (nonatomic , copy) NSString *bookDowns;

//评论数量
@property (nonatomic , copy) NSString *bookComments;

//评分
@property (nonatomic , copy) NSString *bookPoint;

//分类名称
@property (nonatomic , copy) NSString *bookGroupName;

//详细介绍
@property (nonatomic , copy) NSString *bookContext;

//是否已购买
@property (nonatomic , copy) NSString *isBuy;

//分享链接
@property (nonatomic , copy) NSString *shareURL;

//藏家信息
@property (nonatomic , strong) ARTAuthorData *author;

@end
