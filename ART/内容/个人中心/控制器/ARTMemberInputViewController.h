//
//  ARTMemberInputViewController.h
//  ART
//
//  Created by huangtie on 16/6/24.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBaseViewController.h"

typedef void(^ARTMemberInputBlock)(NSString *text);
@interface ARTMemberInputViewController : ARTBaseViewController

@property (nonatomic , copy) ARTMemberInputBlock inputBlock;

+ (ARTMemberInputViewController *)launchViewController:(UIViewController *)viewController
                                                 title:(NSString *)title
                                                  text:(NSString *)text
                                            inputBlock:(ARTMemberInputBlock)inputBlock;

@end
