//
//  ARTAccountDetailViewController.h
//  ART
//
//  Created by huangtie on 16/7/11.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBaseViewController.h"


@interface ARTAccountDetailViewController : ARTBaseViewController

- (instancetype)initWithUserID:(NSString *)userID;

- (void)requestWithInfo:(void (^)(ARTUserInfo *info))completion;

@end
