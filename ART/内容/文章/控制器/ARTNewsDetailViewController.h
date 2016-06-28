//
//  ARTNewsDetailViewController.h
//  ART
//
//  Created by huangtie on 16/6/28.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBaseViewController.h"

@interface ARTNewsDetailViewController : ARTBaseViewController

+ (ARTNewsDetailViewController *)launchViewController:(UIViewController *)viewController
                                               newsID:(NSString *)newsID;

@end
