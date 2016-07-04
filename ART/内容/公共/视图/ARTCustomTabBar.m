//
//  ARTCustomTabBar.m
//  ART
//
//  Created by huangtie on 16/5/18.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTCustomTabBar.h"
#import "ARTFPSLabel.h"

@interface ARTCustomTabBar()

@property (strong, nonatomic) IBOutlet UIView *itemsContrl;

@end

@implementation ARTCustomTabBar

- (instancetype)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"ARTCustomTabBar" owner:self options:nil] lastObject];
    if (self) {
#ifdef DEBUG
//        ARTFPSLabel *fps = [[ARTFPSLabel alloc] initWithFrame:CGRectMake(self.width - 320, 10, 300, 20)];
//        [self addSubview:fps];
#endif
    }
    return self;
}


#pragma mark ACTION
- (void)moveTabin:(ART_TABINDEX)index
{
    if (index < self.itemsContrl.subviews.count)
    {
        [self itemsTouchAction:self.itemsContrl.subviews[index]];
    }
}

- (IBAction)itemsTouchAction:(UIButton *)sender
{
    if (![sender isKindOfClass:[UIButton class]])
    {
        return;
    }
    
    for (UIView *view in self.itemsContrl.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            UIButton *itemd = (UIButton *)view;
            itemd.selected = NO;
        }
    }
    sender.selected = YES;
    [self.delegate customTabBarDidTouchItems:(ART_TABINDEX)[self.itemsContrl.subviews indexOfObject:sender]];
}

- (IBAction)searchTouchAction:(UIButton *)sender
{
    [self.delegate customTabBarDidTouchSearch];
}

- (IBAction)userTouchAction:(UIButton *)sender
{
    [self.delegate customTabBarDidTouchUser];
}

@end
