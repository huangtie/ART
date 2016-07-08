//
//  ARTTalkWallpaper.m
//  ART
//
//  Created by huangtie on 16/7/7.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTTalkWallpaper.h"

@interface ARTTalkWallpaper()

@property (nonatomic , strong) UIImageView *paperImageView;

@property (nonatomic , strong) UIImageView *faceImageView;

@property (nonatomic , strong) UILabel *nickLabel;

@property (nonatomic , assign) WALL_LOAD_STAUTS status;

@property (nonatomic , assign) CGFloat offsetY;
@end

#define IMAGE_HEIGHT 450
#define BEGIN_POINT CGPointMake(30, 20)
#define LOADING_POINT CGPointMake(30, NAVIGATION_HEIGH + 60)
@implementation ARTTalkWallpaper

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.size = CGSizeMake(SCREEN_WIDTH, 550);
        self.backgroundColor = [UIColor whiteColor];
        
        self.paperImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, IMAGE_HEIGHT)];
        self.paperImageView.clipsToBounds = YES;
        self.paperImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.paperImageView.image = [UIImage imageNamed:@"user_icon_6"];
        [self addSubview:self.paperImageView];
        
        self.faceImageView = [[UIImageView alloc] init];
        self.faceImageView.size = CGSizeMake(120, 120);
        [self.faceImageView clipRadius:0 borderWidth:2 borderColor:UICOLOR_ARGB(0xffe6e6e6)];
        self.faceImageView.right = self.width - 60;
        self.faceImageView.centerY = self.paperImageView.bottom - 20;
        self.faceImageView.clipsToBounds = YES;
        self.faceImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.faceImageView.image = IMAGE_PLACEHOLDER_MEMBER;
        [self addSubview:self.faceImageView];
        
        self.nickLabel = [[UILabel alloc] init];
        self.nickLabel.size = CGSizeMake(200, 30);
        self.nickLabel.font = FONT_WITH_22;
        self.nickLabel.textColor = [UIColor whiteColor];
        self.nickLabel.textAlignment = NSTextAlignmentRight;
        self.nickLabel.right = self.faceImageView.left - 20;
        self.nickLabel.bottom = self.paperImageView.bottom - 10;
        self.nickLabel.text = @"未登录";
        [self addSubview:self.nickLabel];
        
        self.loadImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_icon_4"]];
        self.loadImageView.size = CGSizeMake(40, 40);
        self.loadImageView.origin = BEGIN_POINT;
        [self addSubview:self.loadImageView];
    }
    return self;
}

- (void)upDateData:(ARTUserInfo *)userInfo
{
    if (!userInfo)
    {
        self.faceImageView.image = IMAGE_PLACEHOLDER_MEMBER;
        self.nickLabel.text = @"未登录";
    }
    else
    {
        [self.faceImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.userImage] placeholderImage:IMAGE_PLACEHOLDER_MEMBER];
        self.nickLabel.text = userInfo.userNick;
    }
}

- (void)upDateScale:(CGFloat)offsetY
{
    CGFloat scaleW;
    CGFloat scaleH;
    if (offsetY <= 0)
    {
        CGFloat bi = (CGFloat)IMAGE_HEIGHT / (CGFloat)SCREEN_WIDTH;
        scaleH = ABS(offsetY) + IMAGE_HEIGHT;
        scaleW = scaleH / bi;
        self.paperImageView.size = CGSizeMake(scaleW, scaleH);
        self.paperImageView.bottom = IMAGE_HEIGHT;
        self.paperImageView.centerX = SCREEN_WIDTH / 2;
        
        if (self.status == WALL_LOAD_STAUTS_CUSTOM)
        {
            CGFloat loadY = [self.loadImageView convertRect:self.loadImageView.bounds toView:self.viewController.view].origin.y;
            if (loadY >= LOADING_POINT.y && self.loadImageView.superview == self)
            {
                self.offsetY = ABS(offsetY);
                self.loadImageView.transform = CGAffineTransformIdentity;
                self.loadImageView.top = LOADING_POINT.y;
                [self.viewController.view addSubview:self.loadImageView];
            }
            self.loadImageView.transform = CGAffineTransformMakeRotation(ABS(offsetY) / 10 * M_PI );
        }
    }
    if(self.status == WALL_LOAD_STAUTS_CUSTOM && ABS(offsetY) < self.offsetY && self.loadImageView.superview == self.viewController.view)
    {
        self.loadImageView.transform = CGAffineTransformIdentity;
        self.loadImageView.top = BEGIN_POINT.y;
        [self addSubview:self.loadImageView];
    }
}

- (void)beginAnimotion
{
    if (self.status == WALL_LOAD_STAUTS_LOADING)
    {
        return;
    }
    
    if (self.loadImageView.superview != self.viewController.view)
    {
        [self.viewController.view  addSubview:self.loadImageView];
        [UIView animateWithDuration:.7 animations:^{
            self.loadImageView.top = LOADING_POINT.y;
        }];
    }
    self.loadImageView.transform = CGAffineTransformIdentity;
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    shake.fromValue = [NSNumber numberWithFloat:0];
    shake.toValue = [NSNumber numberWithFloat:2 * M_PI];
    shake.duration = 1;
    shake.autoreverses = NO;
    shake.repeatCount = NSIntegerMax;
    [self.loadImageView.layer addAnimation:shake forKey:@"load"];
    
    self.status = WALL_LOAD_STAUTS_LOADING;
    
    if (self.refreshBlock)
    {
        self.refreshBlock();
    }
}

- (void)endLoad
{
    if (self.status == WALL_LOAD_STAUTS_LOADING)
    {
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.loadImageView.top = BEGIN_POINT.y;
        } completion:^(BOOL finished) {
            [self addSubview:self.loadImageView];
            self.status = WALL_LOAD_STAUTS_CUSTOM;
            [self.loadImageView.layer removeAllAnimations];
        }];
    }
}

@end
