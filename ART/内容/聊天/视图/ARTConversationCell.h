//
//  ARTConversationCell.h
//  ART
//
//  Created by huangtie on 16/7/12.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMVoiceMessageBody+ART.h"

@protocol ARTConversationCellDelegate <NSObject>

- (void)cellDidClickImage:(EMMessage *)message;

- (void)cellDidClickVoice:(EMMessage *)message;

- (void)cellDidClickResend:(EMMessage *)message;

@end

@interface ARTConversationCell : UITableViewCell

@property (nonatomic , weak) id<ARTConversationCellDelegate> delegate;

- (void)bindingData:(EMMessage *)message info:(ARTUserInfo *)info;

+ (CGFloat)cellHeight:(EMMessage *)message;

@end
