//
//  QHPageContainerTopBar.h
//  TestPageContainer
//
//  Created by wuzhikun on 15/12/15.
//  Copyright © 2015年 qihoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QHPageContainerTopBarDelegate;

@interface QHPageContainerTopBar : UIView

@property (nonatomic, assign) id<QHPageContainerTopBarDelegate> target;

/**
 设置相邻button之间的间距。间距是从该button的文字结束到下个button的文字开始之间的距离
 */
@property (nonatomic, assign) CGFloat buttonMargin;

#pragma mark - update style

- (void)setCursorPosition:(CGFloat)percent;

- (void)updateConentWithTitles:(NSArray *)titles;

- (void)setSelectedIndex:(NSInteger)idnex;

- (NSInteger)getSelectedIndex;

///设置滑块的颜色
- (void)setCursorColor:(UIColor *)color;

@end


@protocol QHPageContainerTopBarDelegate <NSObject>
@optional
/** 选中topBar的一项 */
- (void)topBarSelectIndex:(NSInteger)index;

/** 重复点击topBar时会调用该方法 */
- (void)topBarSelectIndicator:(NSInteger)index;

@end