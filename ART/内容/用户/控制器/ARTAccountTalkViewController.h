//
//  ARTAccountTalkViewController.h
//  ART
//
//  Created by huangtie on 16/7/11.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBaseViewController.h"

@interface ARTAccountTalkViewController : ARTBaseViewController

- (instancetype)initWithUserID:(NSString *)userID;

- (void)requestDataList:(BOOL)isRefresh completion:(void (^)())completion;
@end
