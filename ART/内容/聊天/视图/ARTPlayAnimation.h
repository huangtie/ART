//
//  ARTPlayAnimation.h
//  ART
//
//  Created by huangtie on 16/7/15.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARTPlayAnimation : UIView

@property (nonatomic , assign) BOOL isLeft;

- (void)beginAnimation:(BOOL)isLeft;

- (void)stopAnimation;

@end
