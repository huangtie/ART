//
//  ARTBookDetailHead.h
//  ART
//
//  Created by huangtie on 16/5/30.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARTBookData.h"

@protocol ARTBookDetailHeadDelegate <NSObject>
@optional

- (void)detailHeadDidChangeFrame;

- (void)detailHeadDidTouchBuy;

- (void)detailHeadDidTouchDown;

- (void)detailHeadDidTouchSave;

- (void)detailHeadDidTouchRead;

@end

@interface ARTBookDetailHead : UIView

@property (nonatomic , assign) id <ARTBookDetailHeadDelegate> delegate;

- (void)updateSubviews:(ARTBookData *)bookData;

@end
