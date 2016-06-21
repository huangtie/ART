//
//  ARTNewsData.h
//  ART
//
//  Created by huangtie on 16/6/20.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARTNewsData : NSObject

//新闻ID
@property (nonatomic , copy) NSString *newsID;

//标题
@property (nonatomic , copy) NSString *newsTitle;

//时间
@property (nonatomic , copy) NSString *newsTime;

//来自
@property (nonatomic , copy) NSString *newsFrom;

//摘要
@property (nonatomic , copy) NSString *newsRemark;

//封面图片
@property (nonatomic , copy) NSString *newsImage;

//内容
@property (nonatomic , copy) NSString *newsContent;

//分享链接
@property (nonatomic , copy) NSString *newsShare;
@end
