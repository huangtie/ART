//
//  ARTRegisterViewController.h
//  ART
//
//  Created by huangtie on 16/6/3.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBaseViewController.h"
typedef void (^ARTLoginSuccessBlock)(ARTUserData * data);
@interface ARTRegisterViewController : ARTBaseViewController

@property (nonatomic , copy) ARTLoginSuccessBlock loginSuccessBlock;

@end
