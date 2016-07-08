//
//  ARTTalkHeadView.h
//  ART
//
//  Created by huangtie on 16/7/4.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARTTalkData.h"

@protocol ARTTalkHeadViewDelegate <NSObject>

- (void)headDidTouchComment:(ARTTalkData *)data;

- (void)headDidTouchZan:(ARTTalkData *)data;

- (void)headDidTouchDelete:(ARTTalkData *)data;

- (void)headDidTouchImage:(ARTTalkData *)data index:(NSInteger)index;

@end

@interface ARTTalkHeadView : UITableViewCell

@property (nonatomic , weak) id<ARTTalkHeadViewDelegate> delegate;

+ (CGFloat)viewHeight:(ARTTalkData *)data;

- (void)bindingWithData:(ARTTalkData *)data index:(NSInteger)index;

@end
