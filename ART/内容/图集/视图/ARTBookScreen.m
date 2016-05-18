//
//  ARTBookScreen.m
//  ART
//
//  Created by huangtie on 16/5/18.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBookScreen.h"

typedef void (^ARTBookScreenListSelectBlock)(NSInteger index);
@interface ARTBookScreenList()

@property (strong, nonatomic) IBOutlet UIButton *upItem;

@property (strong, nonatomic) IBOutlet UIButton *centerItem;

@property (strong, nonatomic) IBOutlet UIButton *downItem;

@property (strong, nonatomic) IBOutlet UIImageView *gou;

@property (nonatomic , copy) ARTBookScreenListSelectBlock selectBlock;

@end

@implementation ARTBookScreenList

- (instancetype)initWithTitles:(NSArray *)titles index:(NSInteger)index
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"ARTBookScreen" owner:self options:nil] lastObject];
    if (self)
    {
        if (titles.count > 2)
        {
            [self.upItem setTitle:titles[0] forState:UIControlStateNormal];
            [self.centerItem setTitle:titles[1] forState:UIControlStateNormal];
            [self.downItem setTitle:titles[2] forState:UIControlStateNormal];
        }
        [self gouLoction:index];
    }
    return self;
}

- (void)gouLoction:(NSInteger)index
{
    UIButton *button = index == 0 ? self.upItem : (index == 1 ? self.centerItem : (index == 2 ? self.downItem : nil));
    self.gou.centerY = button.centerY;
}

#pragma mark ACTION
- (IBAction)itemsTouchAction:(UIButton *)sender
{
    NSInteger index = sender == self.upItem ? 0 : (sender == self.centerItem ? 1 : (sender == self.downItem ? 2 : 0));
    [self gouLoction:index];
    if (self.selectBlock)
    {
        self.selectBlock(index);
    }
    [self dismiss];
}

- (void)dismiss
{
    [self removeFromSuperview];
}

@end


@interface ARTBookScreen()

@property (nonatomic , strong) NSArray *itemTitles;

@property (nonatomic , strong) UILabel *titleLabel;

@property (nonatomic , assign) NSInteger selectIndex;

@property (nonatomic , strong) ARTBookScreenList *screenList;

@end

@implementation ARTBookScreen

- (instancetype)initWithTitels:(NSArray <NSString *> *)titles
{
    self = [super init];
    if (self)
    {
        self.itemTitles = titles;
        
        self.size = CGSizeMake(150, 30);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = self.bounds;
        [button setBackgroundImage:[UIImage imageNamed:@"book_button_item"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonTouchAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
        self.titleLabel.font = FONT_WITH_15;
        self.titleLabel.textColor = RGBCOLOR(51, 51, 51, 1);
        self.titleLabel.text = [titles firstObject];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)buttonTouchAction
{
    self.screenList = [[ARTBookScreenList alloc] initWithTitles:self.itemTitles index:self.selectIndex];
    self.screenList.top = self.bottom;
    self.screenList.centerX = self.centerX;
    [self.superview addSubview:self.screenList];
    self.screenList.userInteractionEnabled = YES;
    
    WS(weak)
    self.screenList.selectBlock = ^(NSInteger index)
    {
        weak.selectIndex = index;
        weak.titleLabel.text = weak.itemTitles[index];
        [weak.delegate screenDidScreen:weak index:index];
    };
}

@end
