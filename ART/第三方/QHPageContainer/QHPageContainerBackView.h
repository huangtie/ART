//
//  QHPageContainerBackView.h
//  TestPageContainer
//
//  Created by wuzhikun on 15/12/16.
//  Copyright © 2015年 qihoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHPageContainerHeaderProtocol.h"

@interface QHPageContainerBackView : UIView
<QHPageContainerHeaderProtocol>

- (void)setImageName:(NSString *)imageName;

@end
