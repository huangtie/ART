//
//  ARTPlayAnimation.m
//  ART
//
//  Created by huangtie on 16/7/15.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTPlayAnimation.h"


#define IMAGE_LEFT @[@"chat_icon_13",@"chat_icon_14",@"chat_icon_15"]
#define IMAGE_RIGHT @[@"chat_icon_16",@"chat_icon_17",@"chat_icon_18"]

@interface ARTPlayAnimation()

@property (nonatomic , strong) UIImageView *imageView;

@property (nonatomic , strong) NSTimer *timer;

@property (nonatomic , assign) NSInteger count;
@end

@implementation ARTPlayAnimation

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _isLeft = YES;
        self.size = self.imageView.size;
        [self addSubview:self.imageView];
    }
    return self;
}

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMAGE_LEFT.lastObject]];
        [_imageView sizeToFit];
    }
    return _imageView;
}

- (void)setIsLeft:(BOOL)isLeft
{
    if (isLeft)
    {
        self.imageView.image = [UIImage imageNamed:IMAGE_LEFT.lastObject];
    }
    else
    {
        self.imageView.image = [UIImage imageNamed:IMAGE_RIGHT.lastObject];
    }
    _isLeft = isLeft;
}

- (void)beginAnimation:(BOOL)isLeft
{
    [self.timer invalidate];
    self.isLeft = isLeft;
    self.count = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                  target:self
                                                selector:@selector(playAnimation)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)stopAnimation
{
    [self.timer invalidate];
    self.count = 0;
    NSArray *array = self.isLeft ? IMAGE_LEFT : IMAGE_RIGHT;
    self.imageView.image = [UIImage imageNamed:array.lastObject];
}

- (void)playAnimation
{
    NSArray *array = self.isLeft ? IMAGE_LEFT : IMAGE_RIGHT;
    NSInteger index = self.count % array.count;
    self.imageView.image = [UIImage imageNamed:array[index]];
    self.count ++;
}

@end
