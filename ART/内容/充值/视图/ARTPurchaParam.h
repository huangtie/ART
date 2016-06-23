//
//  ARTPurchaParam.h
//  ART
//
//  Created by huangtie on 16/6/23.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBaseParam.h"

@interface ARTPurchaParam : ARTBaseParam

//加密串
@property (nonatomic , strong) NSString *receiptyData;

//充值的项目ID
@property (nonatomic , strong) NSString *productID;

@end
