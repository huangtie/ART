//
//  ARTConversationInput.h
//  ART
//
//  Created by huangtie on 16/7/14.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ARTConversationInputDelegate <NSObject>

- (void)inputDidTouchSend:(NSString *)text;

@end

@interface ARTConversationInput : UIView

@property (nonatomic , strong) UITextView *textView;

@property (nonatomic , weak) id<ARTConversationInputDelegate> delegate;

@end
