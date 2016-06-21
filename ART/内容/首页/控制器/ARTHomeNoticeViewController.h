//
//  ARTHomeNoticeViewController.h
//  ART
//
//  Created by huangtie on 16/6/21.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBaseViewController.h"
#import "ARTNoticeData.h"

@interface ARTHomeNoticeViewController : ARTBaseViewController

+ (ARTHomeNoticeViewController *)launchFromController:(ARTBaseViewController *)controller
                                                 data:(ARTNoticeData *)noticeData;

@end
