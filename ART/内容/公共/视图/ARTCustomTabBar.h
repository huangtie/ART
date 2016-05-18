//
//  ARTCustomTabBar.h
//  ART
//
//  Created by huangtie on 16/5/18.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ARTCustomTabBarDelegate <NSObject>
@optional
- (void)customTabBarDidTouchSearch;

- (void)customTabBarDidTouchItems:(ART_TABINDEX)index;

- (void)customTabBarDidTouchUser;
@end

@interface ARTCustomTabBar : UIView

@property (nonatomic , assign) id<ARTCustomTabBarDelegate> delegate;

@end
