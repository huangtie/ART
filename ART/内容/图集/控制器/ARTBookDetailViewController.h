//
//  ARTBookDetailViewController.h
//  ART
//
//  Created by huangtie on 16/5/26.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBaseViewController.h"

@interface ARTBookDetailViewController : ARTBaseViewController

+ (ARTBookDetailViewController *)launchFromController:(ARTBaseViewController *)controller
                                               bookID:(NSString *)bookID;

@end
