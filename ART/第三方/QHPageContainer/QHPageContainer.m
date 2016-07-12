//
//  QHPageContainer.m
//  TestPageContainer
//
//  Created by wuzhikun on 15/12/15.
//  Copyright © 2015年 qihoo. All rights reserved.
//

#import "QHPageContainer.h"
#import "QHPageContainerHeaderView.h"
#import "QHPageContainerTopBar.h"
#import "QHPageContainerScrollView.h"
#import "QHPageContainerBackView.h"

typedef NS_ENUM(NSUInteger, UIViewAppearState) {
    UIViewAppearStateUnknow,
    UIViewAppearStatePrepareToHide,
    UIViewAppearStateHidden,
    UIViewAppearStateShown
};


#define TOPBAR_HEIGHT  60.0
#define MJRefreshHeaderHeight 54.0

@interface QHPageContainer ()
<UIScrollViewDelegate, QHPageContainerTopBarDelegate>

@property (nonatomic, strong) UIView<QHPageContainerHeaderProtocol> *backView;

@property (nonatomic, strong) UIView *frontView;

//放在TableView的Controller后面的View，用来盛放公用的view
@property (nonatomic, strong) UIView *backHeaderView;

@property (nonatomic, strong) QHPageContainerTopBar *topBar;

/** 公用的HeaderView，包含了commonTopView和topBar */
@property (nonatomic, strong) QHPageContainerHeaderView *frontHeaderView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bottomLineView;

@property (nonatomic, strong) NSArray<UIViewController<QHPageContainerControllerProtocol> *> *arrayViewControllers;

@property (nonatomic, assign) NSInteger currentPageIndex;

@property (nonatomic, assign) CGFloat anchorHeight;

/** 当前正在显示的Index，用来记录show和hide事件发送的Index */
@property (nonatomic, assign) NSInteger displayingPageIndex;


/** 记录当前view的显示状态，用于在willMoveToWindow中得到它的显示或隐藏 */
@property (assign, nonatomic) UIViewAppearState state;
@end

@implementation QHPageContainer

- (void)dealloc
{
    for (UIViewController<QHPageContainerControllerProtocol> *controller in _arrayViewControllers) {
        [controller.tableView removeObserver:self forKeyPath:@"contentSize"];
        [controller.tableView removeObserver:self forKeyPath:@"contentOffset"];
        [controller.tableView removeObserver:self forKeyPath:@"contentInset"];
    }
}

- (id)initWithFrame:(CGRect)frame andBackImageName:(NSString *)imageName andFrontView:(UIView *)frontView
{
    CGRect backFrame = frontView.frame;
    QHPageContainerBackView *backView = [[QHPageContainerBackView alloc] initWithFrame:backFrame];
    [backView setImageName:imageName];
    return [self initWithFrame:frame andBackView:backView andFrontView:frontView];
}

- (id)initWithFrame:(CGRect)frame andBackView:(UIView<QHPageContainerHeaderProtocol> *)backView andFrontView:(UIView *)frontView
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _backView = backView;
        _frontView = frontView;
        [self setup];
    }
    return self;
}

- (void)setup
{
    _currentPageIndex = -1;
    _displayingPageIndex = -1;
    
    CGSize size = self.frame.size;
    
    CGFloat commonHeaderHeight = TOPBAR_HEIGHT;
    if (_backView) {
        commonHeaderHeight += CGRectGetHeight(_backView.frame);
    }
    
    _backHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, commonHeaderHeight)];
    _backHeaderView.backgroundColor = [UIColor clearColor];
    [self addSubview:_backHeaderView];
    if (_backView) {
        CGRect frame = _backView.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        _backView.frame = frame;
        [_backHeaderView addSubview:_backView];
    }
    
    _frontHeaderView = [[QHPageContainerHeaderView alloc] initWithFrame:CGRectMake(0, 0, size.width, commonHeaderHeight)];
    [self addSubview:_frontHeaderView];
    
    _topBar = [[QHPageContainerTopBar alloc] initWithFrame:CGRectMake(15, CGRectGetHeight(_backView.frame), size.width - 30, TOPBAR_HEIGHT)];
    [_topBar setBackgroundColor:[UIColor whiteColor]];
    _topBar.target = self;
    [_frontHeaderView addSubview:_topBar];
    
    _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topBar.frame)-.5, size.width, .5)];
    _bottomLineView.backgroundColor = UICOLOR_ARGB(0xff999999);
    [_frontHeaderView addSubview:_bottomLineView];
    
    [_frontHeaderView addSubview:_frontView];
    
    _scrollView = [[QHPageContainerScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [_scrollView setScrollsToTop:NO];
    [_scrollView setAlwaysBounceHorizontal:NO];
    [_scrollView setAlwaysBounceVertical:NO];
    [_scrollView setBounces:NO];
    [self insertSubview:_scrollView belowSubview:_frontHeaderView];
    
    _frontHeaderView.belowView = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = self.frame.size;
    
    for (int i=0; i<[_arrayViewControllers count]; i++) {
        UIViewController *controller = [_arrayViewControllers objectAtIndex:i];
        controller.view.frame = CGRectMake(i*size.width, 0, size.width, size.height);
    }
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
    
    NSString *statusCode = [NSString stringWithFormat:@"%@%@%@%@",@(self.window!=nil),@(newWindow!=nil),@(newWindow==[UIApplication sharedApplication].keyWindow),@([UIView areAnimationsEnabled])];
    if ([self statusCodeIsActionCode:statusCode]) {
        if (self.state == UIViewAppearStateUnknow || self.state == UIViewAppearStateHidden) {
            self.state = UIViewAppearStateShown;
            [self pageContainerDidShow];
        }
        if (self.state == UIViewAppearStatePrepareToHide) {
            self.state = UIViewAppearStateHidden;
            [self pageContainerDidHide];
        }
    } else if ([statusCode isEqualToString:@"1001"]) {
        if (self.state != UIViewAppearStateHidden) {
            self.state = UIViewAppearStateHidden;
            [self pageContainerDidHide];
        }
        
    } else if ([statusCode isEqualToString:@"1000"]) {
        self.state = UIViewAppearStatePrepareToHide;
        
    }
}

- (BOOL)statusCodeIsActionCode:(NSString *)statusCode
{
    return [statusCode hasPrefix:@"011"];
}

#pragma mark - public interfaces
- (void)setAnchorHeight:(CGFloat)anchorHeight
{
    _anchorHeight = anchorHeight;
}

- (void)setButtonMargin:(CGFloat)margin
{
    _topBar.buttonMargin = margin;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentSize.width > 0) {
        [_topBar setCursorPosition:scrollView.contentOffset.x / scrollView.contentSize.width];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger pageIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (pageIndex != _currentPageIndex) {
        _currentPageIndex = pageIndex;
        [_topBar setSelectedIndex:pageIndex];
        [self notifyDelegateSelectedIndex:pageIndex];
    }
}

#pragma mark - update content
- (void)setDefaultSelectedPageIndex:(NSInteger)index
{
    if (index >= 0 && index <= [_arrayViewControllers count] && index != _currentPageIndex) {
        [_topBar setSelectedIndex:index];
        _currentPageIndex = index;
        
        [_scrollView setContentOffset:CGPointMake(index * _scrollView.frame.size.width, 0) animated:NO];
    }
}

- (void)setSelectedPageIndex:(NSInteger)index
{
    if (index >= 0 && index <= [_arrayViewControllers count]) {
        [_topBar setSelectedIndex:index];
        [self topBarSelectIndex:index];
    }
}

- (NSInteger)getCurrentPageIndex
{
    return [_topBar getSelectedIndex];
}

- (UIView *)getCurrentPageView
{
    return [self getPageViewWithIndex:[_topBar getSelectedIndex]];
}

- (UIView *)getPageViewWithIndex:(NSInteger)index
{
    if (index<[_arrayViewControllers count]) {
        UIViewController<QHPageContainerControllerProtocol> *controller = [_arrayViewControllers objectAtIndex:index];
        return controller.tableView;
    } else {
        return nil;
    }
}

- (void)updateContentWithTitles:(NSArray *)titles
{
    [_topBar updateConentWithTitles:titles];
}

- (void)updateContentWithControllers:(NSArray<UIViewController<QHPageContainerControllerProtocol> *> *)controllers
{
    for (UIViewController<QHPageContainerControllerProtocol> *controller in _arrayViewControllers) {
        [controller.tableView removeObserver:self forKeyPath:@"contentSize"];
        [controller.tableView removeObserver:self forKeyPath:@"contentOffset"];
        [controller.tableView removeObserver:self forKeyPath:@"contentInset"];
        [controller.view removeFromSuperview];
    }
    if ([controllers count] == 0) {
        return;
    }
    _arrayViewControllers = [NSArray arrayWithArray:controllers];
    
    CGSize size = self.frame.size;
    
    CGFloat topHeight = CGRectGetHeight(_frontHeaderView.frame);
    UIEdgeInsets scrollInsets = UIEdgeInsetsMake(topHeight, 0, 0, 0);
    
    for (int i=0; i<[controllers count]; i++) {
        UIView *emptyHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, topHeight)];
        
        UIViewController<QHPageContainerControllerProtocol> *controller = [_arrayViewControllers objectAtIndex:i];
        
        //此处会调用viewDidLoad方法，并且设置它的View的背景色为透明色
        controller.view.frame = CGRectMake(i*size.width, 0, size.width, size.height);
        controller.view.backgroundColor = [UIColor clearColor];
        
        UITableView *tableView = controller.tableView;
        [tableView setBackgroundColor:[UIColor clearColor]];
        [tableView setTableHeaderView:emptyHeader];
        [tableView setScrollIndicatorInsets:scrollInsets];
        [_scrollView addSubview:controller.view];
        
        [tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        [tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        [tableView addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    }
    _scrollView.contentSize = CGSizeMake(size.width * [_arrayViewControllers count], size.height);
}

#pragma mark - QHPagesContainerTopBarDelegate
- (void)topBarSelectIndex:(NSInteger)index
{
    if (index < [_arrayViewControllers count]) {
        _currentPageIndex = index;
        
        [_scrollView setContentOffset:CGPointMake(index * _scrollView.frame.size.width, 0) animated:YES];
        [self notifyDelegateSelectedIndex:index];
    }
}

/** 重复点击topBar时会调用该方法 */
- (void)topBarSelectIndicator:(NSInteger)index
{
    if (index < [_arrayViewControllers count]) {
        _currentPageIndex = index;
        [_scrollView setContentOffset:CGPointMake(index * _scrollView.frame.size.width, 0) animated:YES];
        
        if (_delegate && [_delegate respondsToSelector:@selector(onClickPageIndicator:selectIndex:)]) {
            [_delegate onClickPageIndicator:self selectIndex:index];
        }
    }
}

- (void)notifyDelegateSelectedIndex:(NSInteger )index
{
    [self notifyChildControllerDidShowAtIndex:[self getCurrentPageIndex]];

    UIViewController<QHPageContainerControllerProtocol> *controller = [_arrayViewControllers objectAtIndex:index];
    _frontHeaderView.belowView = controller.tableView;
    [self verticalTableViewDidScroll:controller.tableView shouldNotify:NO];
    if (_delegate && [_delegate respondsToSelector:@selector(pageContainer:selectIndex:)]) {
        [_delegate pageContainer:self selectIndex:index];
    }
}

/** 顶部的tabBar */
- (QHPageContainerTopBar *)topBar
{
    return _topBar;
}

#pragma mark - observer for size

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isKindOfClass: [UITableView class]]) {
        if (object==[self getCurrentPageView] && ([keyPath isEqualToString:@"contentOffset"] || [keyPath isEqualToString:@"contentInset"])) {
            UITableView *tableview = object;
            if(tableview.isDecelerating == 1)
            {
                [self.delegate pageContainer:self willDecelerate:YES];
            }
            if ([keyPath isEqualToString:@"contentOffset"]) {
                CGPoint oldPoint = [[change objectForKey:@"old"] CGPointValue];
                CGPoint newPoint = [[change objectForKey:@"new"] CGPointValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (newPoint.y == 0 && -oldPoint.y == MJRefreshHeaderHeight) {
                        /** 在使用MJRefresh时，刷新结束时，改变ContentInsets时有动画，为了适应改变ContentInsets时的动画 */
                        [UIView animateWithDuration:0.25 animations:^{
                            [self verticalTableViewDidScroll:object shouldNotify:YES];
                        }];
                    } else {
                        [self verticalTableViewDidScroll:object shouldNotify:(!oldPoint.y || (oldPoint.y!=newPoint.y))];
                    }
                });
            } else if ([keyPath isEqualToString:@"contentInset"]) {
                UIEdgeInsets oldInsets = [[change objectForKey:@"old"] UIEdgeInsetsValue];
                UIEdgeInsets newInsets = [[change objectForKey:@"new"] UIEdgeInsetsValue];
                [self verticalTableViewDidScroll:object shouldNotify:oldInsets.top != newInsets.top];
            }
        } else if ([keyPath isEqualToString:@"contentSize"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self adjustTableViewFooterHeight:object];
            });
        }
    }
}

/*!
 *     如果 table view 的 contentSize 不够高，则用 footerView 来补齐
 */
- (void)adjustTableViewFooterHeight:(UITableView *)tableView
{
    CGFloat tabHeight = _anchorHeight;
    
    CGFloat heightToAdjust = (tableView.frame.size.height + tableView.tableHeaderView.frame.size.height - tabHeight) - tableView.contentSize.height;
    
    if ((int)heightToAdjust != 0) {
        if (tableView.tableFooterView.frame.size.height + heightToAdjust > 0) {
            
            UIView *footerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, CGRectGetWidth(self.frame), tableView.tableFooterView.frame.size.height + heightToAdjust)];
            footerView.backgroundColor = [UIColor clearColor];
            footerView.userInteractionEnabled = NO;
            tableView.tableFooterView = footerView;
        } else {
            if (tableView.tableFooterView) {
                tableView.tableFooterView = nil;
            }
        }
    }
}

- (void)verticalTableViewDidScroll:(UIScrollView *)scrollView shouldNotify:(BOOL)shouldNotify
{
    if (!scrollView.window) return;
    CGRect frame = _backHeaderView.frame;
    _backHeaderView.frame = (CGRect){{frame.origin.x, -scrollView.contentOffset.y}, frame.size};
    if ([_backView respondsToSelector:@selector(updateBackgroundImageViewWithOffsetY:)]) {
        [_backView updateBackgroundImageViewWithOffsetY:scrollView.contentOffset.y];
    }
    if (shouldNotify && [_delegate respondsToSelector:@selector(pageContainer:verticalScroll:)]) {
        [_delegate pageContainer:self verticalScroll:scrollView.contentOffset.y];
    }
    if (scrollView.contentOffset.y <= (CGRectGetHeight(_backView.frame)-_anchorHeight)) {
        [self setHeaderBackgroundViewOriginY: -scrollView.contentOffset.y byScrollView: scrollView];
        CGRect frontViewframe = _frontView.frame;
        frontViewframe.origin.y = 0;
        _frontView.frame = frontViewframe;
    } else {
        [self setHeaderBackgroundViewOriginY: -(CGRectGetHeight(_backView.frame)-_anchorHeight) byScrollView: scrollView];
        CGRect frontViewframe = _frontView.frame;
        frontViewframe.origin.y = -(_anchorHeight+scrollView.contentOffset.y-CGRectGetHeight(_backView.frame));
        _frontView.frame = frontViewframe;
    }
}

- (void)setHeaderBackgroundViewOriginY:(CGFloat)originY byScrollView:(UIScrollView *)scrollView
{
    if (_frontHeaderView && _frontHeaderView.frame.origin.y != originY ) {
        CGRect frame = _frontHeaderView.frame;
        _frontHeaderView.frame = (CGRect){{frame.origin.x, originY}, frame.size};
        
        if (originY > 0) {
            originY = 0;
        }
        for (UIViewController<QHPageContainerControllerProtocol> *controller in _arrayViewControllers) {
            UITableView *tableView = controller.tableView;
            if (tableView != scrollView) {
                tableView.contentOffset = CGPointMake(tableView.contentOffset.x, -originY);
            }
        }
    }
}

#pragma mark - 处理显示时间
- (void)pageContainerDidHide
{
    if (_displayingPageIndex >= 0 && _displayingPageIndex < [_arrayViewControllers count]) {
        [self notifyChildControllerDidHideAtIndex:_displayingPageIndex];
    }
}

- (void)pageContainerDidShow
{
    [self notifyChildControllerDidShowAtIndex:[self getCurrentPageIndex]];
}

- (void)notifyChildControllerDidHideAtIndex:(NSInteger)index
{
    UIViewController<QHPageContainerControllerProtocol> *controller = [_arrayViewControllers objectAtIndex:index];
    if ([controller respondsToSelector:@selector(viewControllerDidHide)]) {
        [controller viewControllerDidHide];
    }
    _displayingPageIndex = -1;
}

- (void)notifyChildControllerDidShowAtIndex:(NSInteger)index
{
    if (index == _displayingPageIndex) {
        return;
    }
    if (_displayingPageIndex >= 0 && _displayingPageIndex < [_arrayViewControllers count]) {
        UIViewController<QHPageContainerControllerProtocol> *oldController = [_arrayViewControllers objectAtIndex:_displayingPageIndex];
        if ([oldController respondsToSelector:@selector(viewControllerDidHide)]) {
            [oldController viewControllerDidHide];
        }
    }
    UIViewController<QHPageContainerControllerProtocol> *controller = [_arrayViewControllers objectAtIndex:index];
    _displayingPageIndex = index;
    if ([controller respondsToSelector:@selector(viewControllerDidShow)]) {
        [controller viewControllerDidShow];
    }
}

@end





