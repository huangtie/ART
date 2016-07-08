//
//  ARTTalkFooterView.h
//  ART
//
//  Created by huangtie on 16/7/5.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARTTalkData.h"
#import "ARTSendTalkComParam.h"

@protocol ARTTalkFooterViewDelegate <NSObject>

- (void)commentReplayMember:(ARTSendTalkComParam *)param;


- (void)commentDidClickMore:(NSString *)talkID;

@end

@interface ARTTalkFooterView : UIView

@property (nonatomic , weak) id <ARTTalkFooterViewDelegate> delegate;

+ (CGFloat)viewHeight:(ARTTalkData *)data;

+ (ARTTalkFooterView *)crate:(ARTTalkData *)data index:(NSInteger)index;

@end
