//
//  UIScrollView+ART.h
//  ART
//
//  Created by huangtie on 16/5/25.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh.h>

@interface UIScrollView (ART)

- (void)addMJRefreshHeader:(MJRefreshComponentRefreshingBlock)refreshingBlock;

- (void)addMJRefreshFooter:(MJRefreshComponentRefreshingBlock)refreshingBlock;

@end
