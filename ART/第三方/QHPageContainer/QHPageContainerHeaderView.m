//
//  QHPageContainerHeaderView.m
//  TestPageContainer
//
//  Created by wuzhikun on 15/12/15.
//  Copyright © 2015年 qihoo. All rights reserved.
//

#import "QHPageContainerHeaderView.h"

@implementation QHPageContainerHeaderView

- (NSArray *)listSubControlsOfView:(UIView *)view
{
    NSArray *subviews = [view subviews];
    
    if ([subviews count] == 0)
        return nil;
    
    NSMutableArray *temp = [NSMutableArray array];
    for (UIView *subview in subviews) {
        if (!subview.hidden && [subview isKindOfClass:[UIControl class]]) {
            [temp addObject:subview];
        }
        [temp addObjectsFromArray:[self listSubControlsOfView:subview]];
    }
    return [NSArray arrayWithArray:temp];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01) {
        return nil;
    }
    
    if (!CGRectContainsPoint(self.bounds, point)) {
        return nil;
    }
    
    NSArray *allSubViews = [self listSubControlsOfView:self];
    for (UIView *view in allSubViews) {
        CGRect frame = [view convertRect:view.bounds toView:self];
        if (CGRectContainsPoint(frame, point)) {
            return view;
        }
    }
    
    CGRect frame = [self.belowView convertRect:self.belowView.bounds toView:self];
    if (CGRectContainsPoint(frame, point)) {
        return self.belowView;
    }
    return nil;
}


@end
