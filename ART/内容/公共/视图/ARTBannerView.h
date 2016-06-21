//
//  ARTBannerView.h
//  ART
//
//  Created by huangtie on 16/6/20.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARTBannerView;

@protocol ARTBannerViewDataSource <NSObject>
- (NSInteger)numberOfItemsInBannerView:(ARTBannerView *)bannerView;
- (NSURL *)bannerView:(ARTBannerView *)bannerView imageURLAtIndex:(NSInteger)index;
- (NSString *)bannerView:(ARTBannerView *)bannerView titleAtIndex:(NSInteger)index;
- (UIImage *)bannerView:(ARTBannerView *)bannerView iconImageAtIndex:(NSInteger)index;
@end

@protocol ARTBannerViewDelegate <NSObject>
@optional
- (void)bannerView:(ARTBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index;
@end

typedef NS_ENUM(NSInteger, ARTBannerPageIndicatorAlignment) {
    ARTBannerPageIndicatorAlignmentLeft   = 0,
    ARTBannerPageIndicatorAlignmentCenter = 1,
    ARTBannerPageIndicatorAlignmentRight  = 2
};

@interface ARTBannerView : UIView

/**
 * 滑屏间隔
 */
@property (assign, nonatomic) IBInspectable CGFloat flippingInterval;

/**
 * 无限循环
 */
@property (assign, nonatomic) IBInspectable BOOL infinite;

/**
 * 展示分页符
 */
@property (assign, nonatomic) IBInspectable BOOL showsPageIndicator;

/**
 * 占位图
 */
@property (strong, nonatomic) IBInspectable UIImage *placeholderImage;

/**
 * 位置
 */
@property (assign, nonatomic) ARTBannerPageIndicatorAlignment pageIndicatorAlignment;

@property (weak, nonatomic) id<ARTBannerViewDataSource> dataSource;
@property (weak, nonatomic) id<ARTBannerViewDelegate> delegate;

- (void)reloadData;

@end

@interface FSBannerViewCell : UICollectionViewCell

@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UIView *overlay;
@property (weak, nonatomic) UIImageView *iconImageView;

@end


