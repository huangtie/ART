//
//  ARTStarRatingView.h
//  ART
//
//  Created by huangtie on 16/5/27.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ARTStarRatingView;

@protocol StarRatingViewDelegate <NSObject>

@optional

-(void)starRatingView:(ARTStarRatingView *)view score:(CGFloat)score;

@end

@interface ARTStarRatingView : UIView

@property (nonatomic, readonly) NSInteger numberOfStar;

@property (nonatomic, weak) id <StarRatingViewDelegate> delegate;

/**
 *  初始化TQStarRatingView
 *
 *  @param frame  Rectangles
 *  @param number 星星个数
 *
 *  @return TQStarRatingViewObject
 */
- (id)initWithFrame:(CGRect)frame numberOfStar:(NSInteger)number;

/**
 *  设置控件分数
 *
 *  @param score     分数，必须在 0 － 1 之间
 *  @param isAnimate 是否启用动画
 */
- (void)setScore:(CGFloat)score withAnimation:(BOOL)isAnimate;

/**
 *  设置控件分数
 *
 *  @param score      分数，必须在 0 － 1 之间
 *  @param isAnimate  是否启用动画
 *  @param completion 动画完成block
 */
- (void)setScore:(CGFloat)score withAnimation:(BOOL)isAnimate completion:(void (^)(BOOL finished))completion;

@end
