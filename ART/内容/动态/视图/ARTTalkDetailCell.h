//
//  ARTTalkDetailCell.h
//  ART
//
//  Created by huangtie on 16/7/7.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARTTalkComData.h"
#import "ARTSendTalkComParam.h"

@protocol ARTTalkDetailCellDelegate <NSObject>

- (void)replayCellWillReplay:(ARTSendTalkComParam *)param;

@end

@interface ARTTalkDetailCell : UITableViewCell

@property (nonatomic , weak) id<ARTTalkDetailCellDelegate> delegate;

+ (CGFloat)cellHeight:(ARTTalkReplayData *)data;

- (void)bindingWithData:(ARTTalkReplayData *)data comID:(NSString *)comID;

@end
