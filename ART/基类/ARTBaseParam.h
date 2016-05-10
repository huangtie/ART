//
//  ARTBaseParam.h
//  ART
//
//  Created by huangtie on 16/4/28.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYKit.h>

@interface ARTBaseParam : NSObject

- (NSMutableDictionary *)buildRequestParam;

+ (void)filter:(id)value key:(NSString *)key param:(NSMutableDictionary *)param;

@end
