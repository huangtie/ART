//
//  ARTLoginViewController.h
//  ART
//
//  Created by huangtie on 16/6/2.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBaseViewController.h"
#import "ARTUserData.h"

typedef void (^ARTLoginSuccessBlock)(ARTUserData * data);
@interface ARTLoginViewController : ARTBaseViewController

@property (nonatomic , copy) ARTLoginSuccessBlock loginSuccessBlock;

@end
