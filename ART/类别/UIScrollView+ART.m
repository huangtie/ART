//
//  UIScrollView+ART.m
//  ART
//
//  Created by huangtie on 16/5/25.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "UIScrollView+ART.h"

@implementation UIScrollView (ART)

- (void)addMJRefreshHeader:(MJRefreshComponentRefreshingBlock)refreshingBlock
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:refreshingBlock];
    header.lastUpdatedTimeLabel.font = FONT_WITH_14;
    header.lastUpdatedTimeLabel.textColor = COLOR_YSYC_ORANGE;
    header.stateLabel.font = FONT_WITH_15;
    header.stateLabel.textColor = COLOR_YSYC_ORANGE;
    header.arrowView.image = [UIImage imageNamed:@"refresh_icon_head"];
    self.mj_header = header;
}

- (void)addMJRefreshFooter:(MJRefreshComponentRefreshingBlock)refreshingBlock
{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:refreshingBlock];
    footer.stateLabel.font = FONT_WITH_15;
    footer.stateLabel.textColor = COLOR_YSYC_ORANGE;
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    self.mj_footer = footer;
}

@end
