//
//  ARTUserManager.h
//  ART
//
//  Created by huangtie on 16/5/3.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARTUserData.h"
#import "ARTBaseViewController.h"

@interface ARTUserManager : NSObject

@property (nonatomic , strong) ARTUserData * userinfo;

+ (instancetype)sharedInstance;

- (BOOL)isLogin;

- (void)logout;

- (BOOL)isLogin:(ARTBaseViewController *)targe
        logined:(void (^)(ARTUserData *userInfo))logined;
@end
