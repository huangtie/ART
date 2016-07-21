//
//  ARTRecorderControl.h
//  ART
//
//  Created by huangtie on 16/7/15.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ARTRecorderControlDelegate <NSObject>

- (void)recorderDidBeginRecord;

- (void)recorderDidClickKeyboard;

- (void)recorderDidRecordCompletion:(EMVoiceMessageBody *)body;

- (void)recorderDidRecordError:(NSError *)error;

- (void)recorderDidCancel;

@end

@interface ARTRecorderControl : UIView

@property (nonatomic , weak) id<ARTRecorderControlDelegate> delegate;

@end
