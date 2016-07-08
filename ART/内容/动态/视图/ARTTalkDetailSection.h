//
//  ARTTalkDetailSection.h
//  ART
//
//  Created by huangtie on 16/7/6.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARTTalkComData.h"
#import "ARTSendTalkComParam.h"

@protocol ARTTalkDetailSectionDelegate <NSObject>

- (void)sectionWillReplay:(ARTSendTalkComParam *)param;

@end

@interface ARTTalkDetailSection : UIView

@property (nonatomic , weak) id<ARTTalkDetailSectionDelegate> delegate;

+ (CGFloat)viewHeight:(ARTTalkComData *)comData;

+ (ARTTalkDetailSection *)crate:(ARTTalkComData *)comData;
@end
