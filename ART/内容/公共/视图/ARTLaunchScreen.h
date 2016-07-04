//
//  ARTLaunchScreen.h
//  ART
//
//  Created by huangtie on 16/7/1.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ARTLaunchDismissBlock)();
@interface ARTLaunchScreen : UIView

@property (nonatomic , copy) ARTLaunchDismissBlock launchDismissBlock;

+ (void)launchIn:(UIView *)view completion:(void (^)())completion;

@end
