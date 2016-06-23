//
//  ARTPurchaParam.m
//  ART
//
//  Created by huangtie on 16/6/23.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTPurchaParam.h"

@implementation ARTPurchaParam

- (NSMutableDictionary *)buildRequestParam
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [ARTBaseParam filter:self.receiptyData key:@"receiptyData" param:param];
    [ARTBaseParam filter:self.productID key:@"productID" param:param];
    return param;
}

@end
