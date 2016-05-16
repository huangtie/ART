//
//  ARTUserManager.h
//  ART
//
//  Created by huangtie on 16/5/3.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARTUserData.h"

@interface ARTUserManager : NSObject

@property (nonatomic , strong) ARTUserData * userinfo;

+ (instancetype)sharedInstance;

- (BOOL)isLogin;

- (void)logout;

@end
