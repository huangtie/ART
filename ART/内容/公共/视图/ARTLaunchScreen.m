//
//  ARTLaunchScreen.m
//  ART
//
//  Created by huangtie on 16/7/1.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTLaunchScreen.h"

@interface ARTLaunchScreen()

@property (strong, nonatomic) IBOutlet UIImageView *leftUp;
@property (strong, nonatomic) IBOutlet UIImageView *rightUp;
@property (strong, nonatomic) IBOutlet UIImageView *leftDown;
@property (strong, nonatomic) IBOutlet UIImageView *rightDown;

@property (strong, nonatomic) IBOutlet UIImageView *textImage;

@property (strong, nonatomic) IBOutlet UIImageView *classImage;

@property (nonatomic , assign) CGPoint classCanter;
@end

@implementation ARTLaunchScreen

+ (void)launchIn:(UIView *)view completion:(void (^)())completion
{
    ARTLaunchScreen *luanchScreen = [[ARTLaunchScreen alloc] init];
    luanchScreen.launchDismissBlock = completion;
    [view addSubview:luanchScreen];
    [luanchScreen beginAnimotion];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (instancetype)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"ARTLaunchScreen" owner:self options:nil] lastObject];
    if (self)
    {
        self.classCanter = self.classImage.center;
    }
    return self;
}

- (void)dealloc
{
    
}

- (void)beginAnimotion
{
    CGRect leftUpRect = self.leftUp.frame;
    CGRect rightUpRect = self.rightUp.frame;
    CGRect leftDownRect = self.leftDown.frame;
    CGRect rightDownRect = self.rightDown.frame;
    
    self.leftUp.right = 0;
    self.leftUp.bottom = 0;
    
    self.rightUp.left = self.width;
    self.rightUp.bottom = 0;
    
    self.leftDown.right = 0;
    self.leftDown.top = self.height;
    
    self.rightDown.top = 0;
    self.rightDown.left = self.width;
    
    self.classImage.right = 0;
    self.classImage.bottom = 0;
    
    self.textImage.hidden = YES;
    self.textImage.transform = CGAffineTransformScale(self.textImage.transform, 0, 0);
    
    CGFloat duration = .4;
    
    [UIView animateWithDuration:duration delay:.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.leftUp.frame = leftUpRect;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.rightUp.frame = rightUpRect;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.leftDown.frame = leftDownRect;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self.rightDown.frame = rightDownRect;
                } completion:^(BOOL finished) {
                    self.textImage.hidden = NO;
                    [self beginClassAnimotion];
                    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        self.textImage.transform = CGAffineTransformIdentity;
                    } completion:^(BOOL finished) {
                        [self performSelector:@selector(dismiss) withObject:nil afterDelay:3];
                    }];
                }];
            }];
        }];
    }];

    
//    [UIView animateWithDuration:duration delay:.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        self.leftUp.frame = leftUpRect;
//        self.rightUp.frame = rightUpRect;
//        self.rightDown.frame = rightDownRect;
//        self.leftDown.frame = leftDownRect;
//    } completion:^(BOOL finished) {
//        [self.leftUp rock];
//        [self.rightUp rock];
//        [self.rightDown rock];
//        [self.leftDown rock];
//        self.textImage.hidden = NO;
//        [self beginClassAnimotion];
//        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//            self.textImage.transform = CGAffineTransformIdentity;
//        } completion:^(BOOL finished) {
//            [self performSelector:@selector(dismiss) withObject:nil afterDelay:3];
//        }];
//    }];
}

- (void)beginClassAnimotion
{
    [self.classImage parabola:CGPointMake(self.leftUp.centerX - 50,self.leftUp.top - 20)];
    
    WS(weak)
    [self performBlock:^{
        [weak.classImage parabola:weak.classCanter];
    } afterDelay:.7];
    
    [self performBlock:^{
        [weak.classImage.layer addAnimation:[weak breatheAnimation] forKey:@"class"];
    } afterDelay:.7];
}

- (void)dismiss
{
    [UIView animateWithDuration:.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [self.classImage.layer removeAllAnimations];
        if (self.launchDismissBlock)
        {
            self.launchDismissBlock();
        }
        [self removeFromSuperview];
    }];
}

- (CABasicAnimation *)breatheAnimation
{
    CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    pulse.duration = .8;
    pulse.repeatCount = MAXFLOAT;
    pulse.autoreverses = YES;
    pulse.fromValue = [NSNumber numberWithFloat:.84];
    pulse.toValue = [NSNumber numberWithFloat:1.14];
    return pulse;
}

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
    block = [block copy];
    
    [self performSelector:@selector(fireBlockAfterDelay:) withObject:block afterDelay:delay];
}

- (void)fireBlockAfterDelay:(void (^)(void))block
{
    block();
}








@end
