//
//  ARTAlertView.h
//  ART
//
//  Created by huangtie on 16/6/6.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ARTAlertDismissBlock)();
@interface ARTAlertView : UIView

@property (nonatomic , copy) ARTAlertDismissBlock doneBlock;

@property (nonatomic , copy) ARTAlertDismissBlock cancelBlock;

+ (ARTAlertView *)alertTitle:(NSString *)title
           message:(NSString *)message
         doneTitle:(NSString *)doneTitle
       cancelTitle:(NSString *)cancelTitle
         doneBlock:(ARTAlertDismissBlock)doneBlock
       cancelBlock:(ARTAlertDismissBlock)cancelBlock;

@end
