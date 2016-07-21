//
//  ARTEmojiKeyboard.m
//  ART
//
//  Created by huangtie on 16/7/14.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTEmojiKeyboard.h"

@interface ARTEmojiKeyboard()<UIScrollViewDelegate>

@property (nonatomic , strong) UIView *bottomView;

@property (nonatomic , strong) UIScrollView *scrollView;

@property (nonatomic , strong) NSArray *emoji2D;

@property (nonatomic , strong) UIPageControl *pageContrl;

@end

#define KEYBOARD_WIDTH 768
#define KEYBOARD_HEIGHT 383
#define COUNT_ROW 8
#define COUNT_LINE 3
#define LEFT 20
@implementation ARTEmojiKeyboard

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.size = CGSizeMake(KEYBOARD_WIDTH, KEYBOARD_HEIGHT);
        self.backgroundColor = [UIColor whiteColor];
        
        self.scrollView.top = LEFT;
        self.scrollView.left = LEFT;
        [self addSubview:self.scrollView];
        self.pageContrl.bottom = KEYBOARD_HEIGHT - self.bottomView.height - 10;
        [self addSubview:self.pageContrl];
        [self addSubview:self.bottomView];
    }
    return self;
}

#pragma mark GET_SET
- (UIView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIView alloc] init];
        _bottomView.size = CGSizeMake(KEYBOARD_WIDTH, 60);
        _bottomView.backgroundColor = UICOLOR_ARGB(0xfff8f8f8);
        _bottomView.bottom = KEYBOARD_HEIGHT;
        
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sendButton.titleLabel.font = FONT_WITH_22;
        sendButton.size = CGSizeMake(110, _bottomView.height);
        sendButton.right = _bottomView.width;
        [sendButton setBackgroundColor:UICOLOR_ARGB(0xff007aff)];
        [sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:sendButton];
        
        UIButton *keyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [keyButton setBackgroundImage:[UIImage imageNamed:@"chat_icon_19"] forState:UIControlStateNormal];
        [keyButton sizeToFit];
        keyButton.centerY = _bottomView.height / 2;
        keyButton.left = 30;
        [keyButton addTarget:self action:@selector(keyboardAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:keyButton];
    }
    return _bottomView;
}

- (NSArray *)emoji2D
{
    if (!_emoji2D)
    {
        NSArray *emojis = [ARTEmojiManager sharedInstance].emojis;
        NSMutableArray *dataList = [[NSMutableArray alloc]init];
        NSMutableArray *tmps = [[NSMutableArray alloc]init];
        for(NSInteger i = 1; i <= emojis.count; i++)
        {
            if (i % (COUNT_ROW * COUNT_LINE) == 0)
            {
                [tmps addObject:[NSNull null]];
            }
            else
            {
                [tmps addObject:emojis[i - 1]];
            }
            if (i % (COUNT_ROW * COUNT_LINE) == 0 || i == emojis.count)
            {
                if(i % (COUNT_ROW * COUNT_LINE) != 0 && i == emojis.count)
                {
                    [tmps addObject:[NSNull null]];
                }
                [dataList addObject:tmps];
                tmps = [[NSMutableArray alloc]init];
            }
        }
        _emoji2D = dataList;
    }
    return _emoji2D;
}

- (UIPageControl *)pageContrl
{
    if (!_pageContrl)
    {
        _pageContrl = [[UIPageControl alloc] init];
        _pageContrl.numberOfPages = self.emoji2D.count;
        _pageContrl.pageIndicatorTintColor = UICOLOR_ARGB(0xff959698);
        _pageContrl.currentPageIndicatorTintColor = UICOLOR_ARGB(0xff5a6572);
        _pageContrl.centerX = KEYBOARD_WIDTH / 2;
    }
    return _pageContrl;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.size = CGSizeMake(KEYBOARD_WIDTH - 2 * LEFT, KEYBOARD_HEIGHT - self.bottomView.height - 10 - self.pageContrl.height - 2 * LEFT);
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(_scrollView.width * self.emoji2D.count, _scrollView.height);
        
        for (NSInteger i = 0; i < self.emoji2D.count; i++)
        {
            UIView *view = [[UIView alloc] initWithFrame:_scrollView.bounds];
            view.left = i * view.width;
            [_scrollView addSubview:view];
            
            NSArray *datas = self.emoji2D[i];
            for (NSInteger j = 0; j < datas.count; j++)
            {
                NSString *imageName;
                if ([datas[j] isKindOfClass:[ARTEmoji class]])
                {
                    ARTEmoji *emoji = datas[j];
                    imageName = emoji.png;
                }
                else
                {
                    imageName = @"chat_8";
                }
                UIButton *emojiItem = [UIButton buttonWithType:UIButtonTypeCustom];
                emojiItem.size = CGSizeMake(view.width / COUNT_ROW, view.height / COUNT_LINE);
                [emojiItem setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
                emojiItem.left = j % COUNT_ROW * emojiItem.width;
                emojiItem.top = j / COUNT_ROW * emojiItem.height;
                if (j == datas.count - 1 && datas.count != COUNT_ROW * COUNT_LINE)
                {
                    emojiItem.right = view.width;
                    emojiItem.bottom = view.height;
                }
                [emojiItem addTarget:self action:@selector(emojiTouchAction:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:emojiItem];
            }
        }
    }
    return _scrollView;
}

#pragma mark ACTION
- (void)sendAction
{
    [self.delegate emojiDidClickSend];
}

- (void)keyboardAction
{
    [self.delegate emojiDidClickKeyboard];
}

- (void)emojiTouchAction:(UIButton *)sender
{
    NSInteger bigIndex = [self.scrollView.subviews indexOfObject:sender.superview];
    NSInteger smallIndex = [sender.superview.subviews indexOfObject:sender];
    if (bigIndex < self.emoji2D.count)
    {
        NSArray *array = self.emoji2D[bigIndex];
        if (smallIndex < array.count)
        {
            id object = array[smallIndex];
            if ([object isKindOfClass:[ARTEmoji class]])
            {
                [self.delegate emojiDidClickEmoji:object];
            }
            else
            {
                [self.delegate emojiDidClickDelete];
            }
        }
    }
    
}

#pragma mark DELEGATE
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger offset = scrollView.contentOffset.x;
    NSInteger index = offset / (scrollView.width - 20);
    self.pageContrl.currentPage = index;
}

















@end
