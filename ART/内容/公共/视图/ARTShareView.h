//
//  ARTShareView.h
//  ART
//
//  Created by huangtie on 16/6/1.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARTShareUtil.h"

typedef void(^ARTShareChoseeBlock)(SHARE_DESTINATION destination);

@interface ARTShareView : UIView

@property (nonatomic , copy) ARTShareChoseeBlock shareChoseeBlock;

@end
