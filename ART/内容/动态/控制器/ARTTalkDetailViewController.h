//
//  ARTTalkDetailViewController.h
//  ART
//
//  Created by huangtie on 16/7/6.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBaseViewController.h"

@interface ARTTalkDetailViewController : ARTBaseViewController

+ (ARTTalkDetailViewController *)launchViewController:(UIViewController *)viewController
                                               talkID:(NSString *)talkID;

@end
