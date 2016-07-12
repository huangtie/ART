//
//  QHPageContainerTopBar.m
//  TestPageContainer
//
//  Created by wuzhikun on 15/12/15.
//  Copyright © 2015年 qihoo. All rights reserved.
//

#import "QHPageContainerTopBar.h"
#import "QHPageContainerButton.h"


#define MARGIN_HORI (0) //左右侧的间距
#define CURSOR_HEIGHT   (1.5) //底部标示的高度

#define DEFAULT_BUTTON_MARGIN   (20)

@interface QHPageContainerTopBar ()

@property (nonatomic, strong) UIScrollView *scrollView;

/// 底部可移动的标识
@property (nonatomic, strong) UIView *cursor;

@property (nonatomic, strong) NSArray *arrayButtons;

@property (nonatomic, strong) NSArray *arraySeperateLines;

@end

@implementation QHPageContainerTopBar

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _buttonMargin = DEFAULT_BUTTON_MARGIN;
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    [self addSubview:_scrollView];
    
    _cursor = [[UIView alloc] initWithFrame:CGRectZero];
    _cursor.backgroundColor = [UIColor clearColor];
    _cursor.layer.cornerRadius = CURSOR_HEIGHT / 2.0;
    [_scrollView addSubview:_cursor];
}

#pragma mark - 设置各个控件的位置
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = self.frame.size;
    
    _scrollView.frame = CGRectMake(0, 0, size.width, size.height);
    if ([_arrayButtons count] == 0) {
        return;
    }
    
    CGFloat contentWidth = MARGIN_HORI * 2; //增加两侧的间距
    for (int i=0; i<[_arrayButtons count]; i++) {
        UIButton *button = [_arrayButtons objectAtIndex:i];
        contentWidth += button.frame.size.width;
    }
    
    
    if (contentWidth < size.width) {//排不满的情况
        CGFloat buttonWidth = floorf((size.width-MARGIN_HORI*2) / [_arrayButtons count]);
        for (UIButton *button in _arrayButtons) {
            CGRect frame = button.frame;
            frame.size.width = buttonWidth;
            button.frame = frame;
        }
    }
    
    CGFloat buttonHeight = size.height;
    
    NSInteger selectedIndex = 0;
    
    CGFloat xOffset = MARGIN_HORI;
    for (int i=0; i<[_arrayButtons count]; i++) {
        UIButton *button = [_arrayButtons objectAtIndex:i];
        CGRect frame = button.frame;
        frame.origin.x = xOffset;
        frame.origin.y = 0;
        frame.size.height = buttonHeight;
        button.frame = frame;
        xOffset += frame.size.width;
        if (button.selected) {
            selectedIndex = i;
        }
    }
    
    for (int i=0; i<[_arraySeperateLines count]; i++) {
        UIView *line = [_arraySeperateLines objectAtIndex:i];
        
        UIButton *buttonPrev = [_arrayButtons objectAtIndex:i];
        UIButton *buttonNext = [_arrayButtons objectAtIndex:i+1];
        
        CGRect frame = line.frame;
        frame.origin.x = (CGRectGetMaxX(buttonPrev.frame)+CGRectGetMinX(buttonNext.frame))/2;
        line.frame = frame;
    }
    _scrollView.contentSize = CGSizeMake(xOffset + MARGIN_HORI, size.height);
    
    UIButton *buttonSelected = [_arrayButtons objectAtIndex:selectedIndex];
    CGRect frame = buttonSelected.frame;
    CGFloat cursorWidth = 73;               //原始赋予的默认值
    cursorWidth = 0.8 * self.width/_arrayButtons.count ;    //gj add
    _cursor.frame = CGRectMake(frame.origin.x+(frame.size.width-cursorWidth)/2, CGRectGetMaxY(frame)-CURSOR_HEIGHT-.5, cursorWidth, CURSOR_HEIGHT);
}

#pragma mark - 创建各个button

- (void)updateConentWithTitles:(NSArray *)titles
{
    for (UIButton *button in _arrayButtons) {
        [button removeFromSuperview];
    }
    
    if ([titles count] == 0) {
        return;
    }
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i=0; i<[titles count]; i++) {
        NSString *title = [titles objectAtIndex:i];
        UIButton *button = [self createCustomButtonWithTitle:title];
        button.tag = i;
        [button sizeToFit];
        CGRect frame = button.frame;
        frame.size.width += _buttonMargin;
        button.frame = frame;
        [_scrollView addSubview:button];
        [tempArray addObject:button];
    }
    _arrayButtons = [NSArray arrayWithArray:tempArray];
    [_scrollView bringSubviewToFront:_cursor];
    [self setSelectedIndex:0];
    
    tempArray = [NSMutableArray array];
    
    CGFloat lineTop = CGRectGetHeight(self.frame)/5;
    CGFloat lineHeight = CGRectGetHeight(self.frame)-lineTop*2;
    for (int i=0; i<[_arrayButtons count]-1; i++) {
        UIButton *buttonPrev = [_arrayButtons objectAtIndex:i];
        UIButton *buttonNext = [_arrayButtons objectAtIndex:i+1];
        
        CGFloat left = (CGRectGetMaxX(buttonPrev.frame)+CGRectGetMinX(buttonNext.frame))/2;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(left, lineTop, 1, lineHeight)];
        line.backgroundColor = [UIColor clearColor];
        line.hidden = YES;
        [_scrollView addSubview:line];
        [tempArray addObject:line];
    }
    _arraySeperateLines = [NSArray arrayWithArray:tempArray];
}

- (UIButton *)createCustomButtonWithTitle:(NSString *)title
{
    UIButton *button = [[QHPageContainerButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateDisabled];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

/** 点击topbar的某一项 */
- (void)buttonClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger tag = button.tag;
    
    if (button.selected) {
        if (_target && [_target respondsToSelector:@selector(topBarSelectIndicator:)]) {
            [_target topBarSelectIndicator:tag];
        }
        return;
    }
    
    [self setSelectedIndex:tag];
    if (_target && [_target respondsToSelector:@selector(topBarSelectIndex:)]) {
        
        [_target topBarSelectIndex:tag];
    }
}

#pragma mark 更新和设置位置
- (void)setSelectedIndex:(NSInteger)index
{
    if (index >= [_arrayButtons count]) {
        return;
    }
    
    for (int i=0; i<[_arrayButtons count]; i++) {
        UIButton *button = [_arrayButtons objectAtIndex:i];
        button.enabled = (i != index);
    }
    [self updateScrollViewPosition];
}

- (NSInteger)getSelectedIndex
{
    NSInteger selectedIndex = 0;
    for (int i=0; i<[_arrayButtons count]; i++) {
        UIButton *button = [_arrayButtons objectAtIndex:i];
        if (!button.enabled) {
            selectedIndex = i;
        }
    }
    return selectedIndex;
}

- (void)scrollRectToCenter:(CGRect)frame
{
    CGSize size = self.frame.size;
    CGSize contentSize = self.scrollView.contentSize;
    
    CGFloat targetX = frame.origin.x - (size.width - frame.size.width) / 2;
    CGFloat targetEndX = targetX + size.width;
    
    if (targetX < 0) {
        targetX = 0;
    }
    if (targetEndX > contentSize.width) {
        targetEndX = contentSize.width;
    }
    CGRect targetRect = CGRectMake(targetX, 0, targetEndX - targetX, frame.size.height);
    
    [self.scrollView scrollRectToVisible:targetRect animated:YES];
}

- (void)updateScrollViewPosition
{
    CGSize size = self.frame.size;
    CGSize contentSize = self.scrollView.contentSize;
    if (size.width >= contentSize.width) {
        return;
    }
    
    CGRect frame = CGRectZero;
    for (int i=0; i<[_arrayButtons count]; i++) {
        UIButton *button = [_arrayButtons objectAtIndex:i];
        if (button.selected) {
            frame = button.frame;
        }
    }
    
    [self scrollRectToCenter:frame];
}

- (void)setCursorPosition:(CGFloat)percent
{
    CGRect frame = _cursor.frame;
    CGFloat positonX = frame.origin.x;
    
    CGFloat offsetOfItems = percent * [_arrayButtons count];
    NSInteger currentIndex = floorf(offsetOfItems);
    //    NSInteger nextIndex = ceilf(offsetOfItems);
    
    CGFloat cursorWidth = frame.size.width;
    
    if (currentIndex >= 0 && currentIndex <= [_arrayButtons count]) {
        UIButton *currentButton = [_arrayButtons objectAtIndex:currentIndex];
        //        UIButton *nextButton = [_arrayButtons objectAtIndex:nextIndex];
        //        if (nextIndex!=currentIndex) {
        //            cursorWidth = (currentButton.frame.size.width*(nextIndex-offsetOfItems)) + (nextButton.frame.size.width*(offsetOfItems-currentIndex));
        //        } else {
        //            cursorWidth = currentButton.frame.size.width;
        //        }
        positonX = currentButton.frame.origin.x + (offsetOfItems-currentIndex) * currentButton.frame.size.width + (currentButton.frame.size.width-cursorWidth)/2;
    }
    if (cursorWidth == 0) {
//        int i;
//        i = 0;
    }
    
    
    frame.origin.x = positonX;
    _cursor.frame = frame;
}

- (QHPageContainerButton *)getCustomButtonAtIndex:(NSInteger)index
{
    if (index >= 0 && index < [_arrayButtons count]) {
        QHPageContainerButton *button = [_arrayButtons objectAtIndex:index];
        if ([QHPageContainerButton isKindOfClass:[QHPageContainerButton class]]) {
            return button;
        }
    }
    return nil;
}

- (void)setCursorColor:(UIColor *)color
{
    _cursor.backgroundColor = color;
}

@end