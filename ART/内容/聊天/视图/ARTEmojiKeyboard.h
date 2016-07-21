//
//  ARTEmojiKeyboard.h
//  ART
//
//  Created by huangtie on 16/7/14.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ARTEmojiKeyboardDelegate <NSObject>

- (void)emojiDidClickEmoji:(ARTEmoji *)emoji;

- (void)emojiDidClickDelete;

- (void)emojiDidClickSend;

- (void)emojiDidClickKeyboard;

@end

@interface ARTEmojiKeyboard : UIView

@property (nonatomic , weak) id<ARTEmojiKeyboardDelegate> delegate;

@end
