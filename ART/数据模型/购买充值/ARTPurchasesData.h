//
//  ARTPurchasesData.h
//  ART
//
//  Created by huangtie on 16/5/5.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARTPurchasesData : NSObject

//价格ID
@property (nonatomic , copy) NSString *iapID;

//产品ID
@property (nonatomic , copy) NSString *iapBundle;

//支付价格
@property (nonatomic , copy) NSString *iapMoney;

//标题
@property (nonatomic , copy) NSString *iapTitle;

//介绍
@property (nonatomic , copy) NSString *iapRemark;

//获得金币数量
@property (nonatomic , copy) NSString *iapPoint;

@end
