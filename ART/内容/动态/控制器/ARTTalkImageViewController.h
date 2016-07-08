//
//  ARTTalkImageViewController.h
//  ART
//
//  Created by huangtie on 16/7/6.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBaseViewController.h"

@interface ARTTalkImageView : UIScrollView

@end

@interface ARTTalkImageViewController : ARTBaseViewController

+ (ARTTalkImageViewController *)launchViewController:(UIViewController *)viewController
                                                URLS:(NSArray <NSString *> *)URLS
                                               index:(NSInteger)index;

@end
