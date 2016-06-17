//
//  ARTBaseViewController.h
//  ART
//
//  Created by huangtie on 16/5/12.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARTBaseViewController : UIViewController

//是否能旋转屏幕
@property (nonatomic , assign) BOOL isAutorotate;

/**
 * 自定制导航条
 */
@property (readonly, nonatomic) UINavigationBar *navigationBar;

- (void)_backItemClicked:(id)sender;
- (void)_rightItemClicked:(id)sender;

- (void)displayHUD;
- (void)hideHUD;

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;

@end
