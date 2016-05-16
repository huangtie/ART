//
//  ARTBookLocalData.h
//  ART
//
//  Created by huangtie on 16/5/16.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ARTLocalPicture : NSObject

@property (nonatomic , copy) NSString *ID;

@property (nonatomic , copy) NSString *local;

@property (nonatomic , copy) NSString *distance;

@end

@interface ARTBookLocalData : NSObject

@property (nonatomic , copy) NSString *ID;

//名称
@property (nonatomic , copy) NSString *name;

//简介
@property (nonatomic , copy) NSString *remak;

//封面
@property (nonatomic , copy) NSString *cover;

//图片集合
@property (nonatomic , strong) NSArray <ARTLocalPicture *> *pictures;

- (CGFloat)downStatus;

@end
