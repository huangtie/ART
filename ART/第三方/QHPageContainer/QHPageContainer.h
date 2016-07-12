//
//  QHPageContainer.h
//  TestPageContainer
//
//  Created by wuzhikun on 15/12/15.
//  Copyright © 2015年 qihoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHPageContainerControllerProtocol.h"
#import "QHPageContainerHeaderProtocol.h"

@class QHPageContainerTopBar;
@protocol QHPageContainerDelegate;

@interface QHPageContainer : UIView

@property (nonatomic, weak) id<QHPageContainerDelegate>delegate;

- (id)initWithFrame:(CGRect)frame andBackImageName:(NSString *)imageName andFrontView:(UIView *)frontView;

/** 使用backView和FrontView来初始化控件 */
- (id)initWithFrame:(CGRect)frame andBackView:(UIView<QHPageContainerHeaderProtocol> *)backView andFrontView:(UIView *)frontView;

/** 设置停留部分的高度 */
- (void)setAnchorHeight:(CGFloat)anchorHeight;

/**
 设置相邻button之间的间距。间距是从该button的文字结束到下个button的文字开始之间的距离
 默认值是20
 */
- (void)setButtonMargin:(CGFloat)margin;

/**
 设置顶部的标题
 */
- (void)updateContentWithTitles:(NSArray *)titles;
/**
 设置内容ViewController，每个Controller会占据该容器的大小
 */
- (void)updateContentWithControllers:(NSArray<UIViewController<QHPageContainerControllerProtocol> *> *)controllers;

/**
 设置所应选择的页，不通知外部
 */
- (void)setDefaultSelectedPageIndex:(NSInteger)index;

/**
 设置所应选择的页
 */
- (void)setSelectedPageIndex:(NSInteger)index;
/**
 得到当前的页面
 */
- (NSInteger)getCurrentPageIndex;

/**
 得到当前正在显示的view
 */
- (UIView *)getCurrentPageView;

/**
 得到index对应的view
 */
- (UIView *)getPageViewWithIndex:(NSInteger)index;

/** 顶部的tabBar */
- (QHPageContainerTopBar *)topBar;


@end

@protocol QHPageContainerDelegate <NSObject>

@optional
/** page切换 */
- (void)pageContainer:(QHPageContainer *)container selectIndex:(NSInteger)index;

/** 点击当前的指示器 */
- (void)onClickPageIndicator:(QHPageContainer *)container selectIndex:(NSInteger)index;

/** 纵向的TableView滚动 */
- (void)pageContainer:(QHPageContainer *)container verticalScroll:(CGFloat)offset;

- (void)pageContainer:(QHPageContainer *)container willDecelerate:(BOOL)decelerate;

@end



