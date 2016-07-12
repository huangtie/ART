//
//  QHPageContainerBackView.m
//  TestPageContainer
//
//  Created by wuzhikun on 15/12/16.
//  Copyright © 2015年 qihoo. All rights reserved.
//

#import "QHPageContainerBackView.h"

@interface QHPageContainerBackView ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation QHPageContainerBackView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        
        [self addSubview:_backgroundImageView];
        
    }
    return self;
}

- (void)setImageName:(NSString *)imageName
{
    _backgroundImageView.image = [UIImage imageNamed:imageName];
}

#pragma mark - QHPageContainerHeaderProtocol
- (void)updateBackgroundImageViewWithOffsetY:(CGFloat)y
{
    CGFloat originWidth = self.frame.size.width;
    CGFloat originHeight = self.frame.size.height;
    
    if (y <= 0) {
        
        CGRect imageFrame = _backgroundImageView.frame;
        imageFrame.origin.x = .0 + y;
        imageFrame.origin.y = .0 + y;
        imageFrame.size.width = originWidth - y * 2;
        imageFrame.size.height = originHeight - y;
        _backgroundImageView.frame = imageFrame;
    }
}

@end
