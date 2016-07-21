//
//  ARTConversationViewController.h
//  ART
//
//  Created by huangtie on 16/7/12.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBaseViewController.h"

@class ARTUserInfo;
@interface ARTConversationViewController : ARTBaseViewController

+ (ARTConversationViewController *)launchViewController:(UIViewController *)viewController
                                                 chater:(NSString *)chater
                                                   info:(ARTUserInfo *)info;

@end
