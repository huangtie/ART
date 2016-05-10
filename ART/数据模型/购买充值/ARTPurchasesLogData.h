//
//  ARTPurchasesLogData.h
//  ART
//
//  Created by huangtie on 16/5/5.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARTPurchasesLogData : NSObject

//日志ID
@property (nonatomic , copy) NSString *logID;

//类型（0 花费  1 充值 ）
@property (nonatomic , copy) NSString *logType;

//说明
@property (nonatomic , copy) NSString *logRemark;

//日期
@property (nonatomic , copy) NSString *logTime;

//涉及金额
@property (nonatomic , copy) NSString *logPrice;

@end
