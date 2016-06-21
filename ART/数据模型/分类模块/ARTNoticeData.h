//
//  ARTNoticeData.h
//  ART
//
//  Created by huangtie on 16/6/20.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARTNoticeData : NSObject

//通知ID
@property (nonatomic , copy) NSString *noticeID;

//标题
@property (nonatomic , copy) NSString *noticeTitle;

//时间
@property (nonatomic , copy) NSString *noticeTime;

//内容
@property (nonatomic , copy) NSString *noticeContent;

//图片
@property (nonatomic , copy) NSString *noticeImage;

//链接
@property (nonatomic , copy) NSString *noticeURL;

//跳转代码(0:html 1:H5)
@property (nonatomic , copy) NSString *noticeCode;

@end
