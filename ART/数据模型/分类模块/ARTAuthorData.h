//
//  ARTAuthorData.h
//  ART
//
//  Created by huangtie on 16/5/4.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARTAuthorData : NSObject

//藏家ID
@property (nonatomic , copy) NSString *authorID;

//藏家名称
@property (nonatomic , copy) NSString *authorName;

//藏家简介
@property (nonatomic , copy) NSString *authorRema;

//藏家头像
@property (nonatomic , copy) NSString *authorImag;

//详细介绍
@property (nonatomic , copy) NSString *authorContent;

@end
