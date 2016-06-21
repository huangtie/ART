//
//  ARTBannerView.m
//  ART
//
//  Created by huangtie on 16/6/20.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBannerView.h"
#import <UIImageView+WebCache.h>

static const CGFloat   kPageIndicatorHeight = 30.0;
static const NSInteger kInfiniteCount       = 20000;

@interface ARTBannerView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak   , nonatomic) UICollectionView *collectionView;
@property (weak   , nonatomic) UICollectionViewFlowLayout *collectionViewFlowLayout;
@property (weak   , nonatomic) UIPageControl *pageControl;
@property (weak   , nonatomic) UIImageView *placeholderImageView;
@property (weak   , nonatomic) NSTimer *timer;
@property (assign , nonatomic) BOOL needsInvalidate;

- (void)commonInit;

- (void)startAutoFlipping;
- (void)cancelAutoFlipping;
- (void)update:(id)sender;

@end

@implementation ARTBannerView

#pragma mark - Initialize & Life cycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)dealloc
{
    [self cancelAutoFlipping];
}

- (void)commonInit
{
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    collectionViewFlowLayout.sectionInset = UIEdgeInsetsZero;
    collectionViewFlowLayout.minimumInteritemSpacing = 0;
    collectionViewFlowLayout.minimumLineSpacing = 0;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewFlowLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.alwaysBounceHorizontal = YES;
    [collectionView registerClass:[FSBannerViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    self.collectionViewFlowLayout = collectionViewFlowLayout;
    
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.hidesForSinglePage = YES;
    pageControl.enabled = NO;
    pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    
    UIImageView *placeholderImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    placeholderImageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:placeholderImageView];
    self.placeholderImageView = placeholderImageView;
    
    _needsInvalidate = YES;
    _infinite = YES;
    _flippingInterval = 5;
    _pageIndicatorAlignment = ARTBannerPageIndicatorAlignmentRight;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _collectionView.contentInset = UIEdgeInsetsZero;
    _collectionView.frame = self.bounds;
    _collectionViewFlowLayout.itemSize = _collectionView.frame.size;
    _placeholderImageView.frame = self.bounds;
    
    if (_needsInvalidate && [_collectionView numberOfItemsInSection:0] > 1) {
        _needsInvalidate = NO;
        _collectionView.contentOffset = CGPointMake((kInfiniteCount/2-kInfiniteCount/2%_pageControl.numberOfPages)*_collectionView.frame.size.width, 0);
    }
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    if (self.window) {
        if (!_timer) {
            [self startAutoFlipping];
        }
    } else {
        if (_timer) {
            [self cancelAutoFlipping];
            if (_collectionView.indexPathsForVisibleItems.count) {
                [_collectionView scrollToItemAtIndexPath:_collectionView.indexPathsForVisibleItems.firstObject atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
            }
        }
    }
}

#pragma mark - UICollectionView delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (_dataSource) {
        count = [_dataSource numberOfItemsInBannerView:self];
    }
    _placeholderImageView.hidden = count;
    _pageControl.numberOfPages = count;
    CGSize calculatedSize = [_pageControl sizeForNumberOfPages:count];
    calculatedSize = CGSizeMake(MAX(MIN(calculatedSize.width*2, calculatedSize.width+20), calculatedSize.width+60), kPageIndicatorHeight);
    switch (_pageIndicatorAlignment) {
        case ARTBannerPageIndicatorAlignmentLeft: {
            _pageControl.frame = CGRectMake(0, self.frame.size.height-kPageIndicatorHeight, calculatedSize.width, calculatedSize.height);
            break;
        }
        case ARTBannerPageIndicatorAlignmentCenter:{
            _pageControl.frame = CGRectMake(CGRectGetMidX(self.frame)-calculatedSize.width*0.5, self.frame.size.height-kPageIndicatorHeight, calculatedSize.width, kPageIndicatorHeight);
            break;
        }
        case ARTBannerPageIndicatorAlignmentRight:{
            _pageControl.frame = CGRectMake(self.frame.size.width-calculatedSize.width, self.frame.size.height-kPageIndicatorHeight, calculatedSize.width, kPageIndicatorHeight);
            break;
        }
        default:
            break;
    }
    if (_infinite) {
        return count > 1 ? kInfiniteCount : count;
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSBannerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSURL *imageURL;
    NSString *title;
    UIImage *icon;
    if (_dataSource) {
        NSInteger index = indexPath.item;
        if (_infinite) {
            index %= _pageControl.numberOfPages;
        }
        imageURL = [_dataSource bannerView:self imageURLAtIndex:index];
        title = [_dataSource bannerView:self titleAtIndex:index];
        icon = [_dataSource bannerView:self iconImageAtIndex:index];
    }
    [cell.imageView sd_setImageWithURL:imageURL placeholderImage:_placeholderImage];
    cell.titleLabel.text = title;
    cell.iconImageView.image = icon;
    cell.iconImageView.hidden = !icon;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSBannerViewCell *cell = (FSBannerViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.overlay.alpha = 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(bannerView:didSelectItemAtIndex:)]) {
        [_delegate bannerView:self didSelectItemAtIndex:indexPath.item%_pageControl.numberOfPages];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSBannerViewCell *cell = (FSBannerViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.overlay.alpha = 0;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGPoint targetOffset = *targetContentOffset;
    NSInteger targetIndex = (NSInteger)(targetOffset.x/_collectionView.frame.size.width)%_pageControl.numberOfPages;
    _pageControl.currentPage = targetIndex;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self cancelAutoFlipping];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self startAutoFlipping];
}

#pragma mark - Public Setter

- (void)setShowsPageIndicator:(BOOL)showsPageIndicator
{
    _pageControl.hidden = !showsPageIndicator;
}

- (void)setInfinite:(BOOL)infinite
{
    if (_infinite != infinite) {
        _infinite = infinite;
        _collectionView.contentOffset = CGPointMake(kInfiniteCount/2*infinite + _pageControl.currentPage*_collectionView.frame.size.width, 0);
        [self reloadData];
    }
}

- (void)setPageIndicatorAlignment:(ARTBannerPageIndicatorAlignment)pageIndicatorAlignment
{
    if (_pageIndicatorAlignment != pageIndicatorAlignment) {
        _pageIndicatorAlignment = pageIndicatorAlignment;
        [self reloadData];
    }
}

- (void)setPlaceholderImage:(UIImage *)placeholderImage
{
    if (![_placeholderImage isEqual:placeholderImage]) {
        _placeholderImage = placeholderImage;
        _placeholderImageView.image = placeholderImage;
    }
}

#pragma mark - Properties

- (BOOL)showsPageIndicator
{
    return !_pageControl.hidden;
}

#pragma mark - Public interface

- (void)reloadData
{
    _needsInvalidate = YES;
    [_collectionView reloadData];
    [self setNeedsLayout];
}

#pragma mark - Private methods

- (void)startAutoFlipping
{
    [self cancelAutoFlipping];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:_flippingInterval target:self selector:@selector(update:) userInfo:nil repeats:YES];
    self.timer = timer;
    
}

- (void)cancelAutoFlipping
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)update:(id)sender
{
    if (_collectionView.contentSize.width <= 0) {
        return;
    }
    CGFloat contentOffsetX = _collectionView.contentOffset.x;
    NSInteger index = contentOffsetX/_collectionView.frame.size.width;
    if (contentOffsetX < _collectionView.contentSize.width-_collectionView.frame.size.width) {
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        _pageControl.currentPage = (index+1)%_pageControl.numberOfPages;
    } else if (contentOffsetX > 0) {
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        _pageControl.currentPage = (index-1)%_pageControl.numberOfPages;
    }
}

@end

@implementation FSBannerViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:IMAGE_PLACEHOLDER_BOOK];
        [iconImageView sizeToFit];
        iconImageView.center = imageView.center;
        iconImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        iconImageView.hidden = YES;
        [self.contentView addSubview:iconImageView];
        self.iconImageView = iconImageView;
        
        CGFloat heightOfMaskView = 40.0;
        UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(.0, self.contentView.height - heightOfMaskView, self.contentView.width, heightOfMaskView)];
        maskView.backgroundColor = RGBCOLOR(33, 33, 33, .4);
        [imageView addSubview:maskView];
        
        CGFloat titleWidth = 600;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, self.contentView.height - 20.0 - 6.0, titleWidth, 20.0)];
        titleLabel.centerX = self.width / 2;
        titleLabel.centerY = maskView.height / 2;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = FONT_WITH_16;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [maskView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UIView *overlay = [[UIView alloc] initWithFrame:self.contentView.bounds];
        overlay.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        overlay.alpha = .0;
        [self.contentView addSubview:overlay];
        self.overlay = overlay;
    }
    return self;
}

@end

