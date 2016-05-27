//
//  ARTBookInputView.h
//  ART
//
//  Created by huangtie on 16/5/27.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ARTBookInputViewDelegate <NSObject>
@optional

- (void)bookInputViewDidDoSend:(NSString *)text scole:(NSString *)scole;

@end

@interface ARTBookInputView : UIView

@property (nonatomic , assign) id <ARTBookInputViewDelegate> delegate;

- (void)cleanText;

@end
