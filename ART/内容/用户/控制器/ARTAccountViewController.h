//
//  ARTAccountViewController.h
//  ART
//
//  Created by huangtie on 16/7/11.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBaseViewController.h"
@class ARTUserInfo;

@interface ARTAccountViewController : ARTBaseViewController

+ (ARTAccountViewController *)launchViewController:(UIViewController *)viewController userID:(NSString *)userID  info:(ARTUserInfo *)info;

@end
