//
//  ARTUdidUtil.h
//  ART
//
//  Created by huangtie on 16/5/3.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SSKeychain.h>

@interface ARTUdidUtil : NSObject

+ (NSString *)LoadUDID;

+ (BOOL)isRemmenber;

+ (void)remmenber:(BOOL)isRemmenber;

+ (void)saveAccoutName:(NSString *)name pwd:(NSString *)pwd;

+ (NSDictionary *)loadAccount;

@end
