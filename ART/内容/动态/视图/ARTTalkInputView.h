//
//  ARTTalkInputView.h
//  ART
//
//  Created by huangtie on 16/7/6.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARTSendTalkComParam.h"

@protocol ARTTalkInputViewDelegate <NSObject>

- (void)inputDidTouchSend:(ARTSendTalkComParam *)param;

@end

@interface ARTTalkInputView : UIView

@property (nonatomic , weak) id<ARTTalkInputViewDelegate> delegate;

@property (nonatomic , strong) ARTSendTalkComParam *param;

@property (nonatomic , strong) UITextField *textField;

- (void)beginInput:(ARTSendTalkComParam *)param;

@end
