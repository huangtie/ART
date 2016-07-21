//
//  ARTConversationCell.m
//  ART
//
//  Created by huangtie on 16/7/12.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTConversationCell.h"
#import "ARTConversationUtil.h"
#import "ImageLoader.h"
#import "ARTAccountViewController.h"
#import "ARTPlayAnimation.h"

@interface ARTConverVoice : UIView

@property (nonatomic , strong) UIImageView *popaoView;

@property (nonatomic , strong) ARTPlayAnimation *playAnimation;

@property (nonatomic , strong) UILabel *timeLabel;

@property (nonatomic , strong) EMVoiceMessageBody *body;

@end

@implementation ARTConverVoice

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self addSubview:self.popaoView];
        [self addSubview:self.playAnimation];
        [self addSubview:self.timeLabel];
    }
    return self;
}

- (UIImageView *)popaoView
{
    if (!_popaoView)
    {
        _popaoView = [[UIImageView alloc] init];
    }
    return _popaoView;
}

- (ARTPlayAnimation *)playAnimation
{
    if (!_playAnimation)
    {
        _playAnimation = [[ARTPlayAnimation alloc] init];
    }
    return _playAnimation;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel)
    {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.size = CGSizeMake(50, 20);
        _timeLabel.font = FONT_WITH_18;
    }
    return _timeLabel;
}


- (void)bindingVoice:(EMMessage *)message
{
    if (![message.body isKindOfClass:[EMVoiceMessageBody class]])
    {
        return;
    }
    
    BOOL isSender = [ARTConversationUtil isSender:message];
    self.popaoView.image = [ARTConversationUtil resizableImage:isSender ? POPAO_IMAGE_SENDER : POPAO_IMAGE_RECEDER];
    EMVoiceMessageBody *body = (EMVoiceMessageBody *)message.body;
    self.body = body;
    
    NSInteger duration = body.duration;
    self.size = [ARTConversationUtil converVoiceSize:duration];
    self.popaoView.frame = self.bounds;
    self.playAnimation.centerY = self.height / 2;
    self.timeLabel.centerY = self.height / 2;
    BOOL isLeft;
    if (isSender)
    {
        isLeft = NO;
        self.playAnimation.isLeft = NO;
        self.playAnimation.right = self.width - 30;
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel.right = self.playAnimation.left - 2;
        self.timeLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        isLeft = YES;
        self.playAnimation.isLeft = YES;
        self.playAnimation.left = 30;
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        self.timeLabel.left = self.playAnimation.right + 10;
        self.timeLabel.textColor = UICOLOR_ARGB(0xff333333);
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%@”",@(duration)];
    
    if (body.art_isPlaying)
    {
        [self.playAnimation beginAnimation:isLeft];
    }
    else
    {
        [self.playAnimation stopAnimation];
    }
}

@end


@interface ARTConverImage : UIView

@property (nonatomic , strong) UIImageView *imageView;

@property (nonatomic , strong) UIImageView *popaoView;

@property (nonatomic , strong) UIView *pressView;

@property (nonatomic , strong) UIActivityIndicatorView *activity;

@end

@implementation ARTConverImage

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.size = [ARTConversationUtil converImageSize];
        self.popaoView.frame = self.bounds;
        self.imageView.frame = CGRectMake(13, 10, self.width - 26, self.height - 20);
        [self addSubview:self.popaoView];
        [self addSubview:self.imageView];
        
        self.pressView = [[UIView alloc] initWithFrame:self.imageView.frame];
        self.pressView.hidden = YES;
        self.pressView.backgroundColor = RGBCOLOR(33, 33, 33, .5);
        self.activity = [[UIActivityIndicatorView alloc] init];
        self.activity.center = CGPointMake(self.pressView.width / 2, self.pressView.height / 2);
        [self.pressView addSubview:self.activity];
        
        [self addSubview:self.pressView];
    }
    return self;
}

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_imageView clipRadius:15 borderWidth:0 borderColor:nil];
    }
    return _imageView;
}

- (UIImageView *)popaoView
{
    if (!_popaoView)
    {
        _popaoView = [[UIImageView alloc] init];
    }
    return _popaoView;
}

- (void)bindingImage:(EMMessage *)message
{
    if (![message.body isKindOfClass:[EMImageMessageBody class]])
    {
        return;
    }
    
    BOOL isSender = [ARTConversationUtil isSender:message];
    self.popaoView.image = [ARTConversationUtil resizableImage:isSender ? POPAO_IMAGE_SENDER : POPAO_IMAGE_RECEDER];
    EMImageMessageBody *body = (EMImageMessageBody *)message.body;
    if (body.thumbnailLocalPath.length && [[NSFileManager defaultManager] fileExistsAtPath:body.thumbnailLocalPath])
    {
        self.imageView.image = [UIImage imageWithContentsOfFile:body.thumbnailLocalPath];
    }
    else
    {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:body.thumbnailRemotePath] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
    }
    
    if (message.status == EMMessageStatusDelivering)
    {
        self.pressView.hidden = NO;
    }
    else
    {
        self.pressView.hidden = YES;
    }
}

@end

@interface ARTConverText : UIView

@property (nonatomic , strong) UIImageView *backImageView;

@property (nonatomic , strong) UILabel *textLabel;

@end

@implementation ARTConverText

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self addSubview:self.backImageView];
        [self addSubview:self.textLabel];
    }
    return self;
}

- (UIImageView *)backImageView
{
    if (!_backImageView)
    {
        _backImageView = [[UIImageView alloc] init];
    }
    return _backImageView;
}

- (UILabel *)textLabel
{
    if (!_textLabel)
    {
        _textLabel = [[UILabel alloc] init];
        _textLabel.numberOfLines = 0;
    }
    return _textLabel;
}

- (void)bindingText:(EMMessage *)message
{
    if (![message.body isKindOfClass:[EMTextMessageBody class]])
    {
        return;
    }
    EMTextMessageBody *body = (EMTextMessageBody *)message.body;
    NSMutableAttributedString *attribuText = [ARTConversationUtil conText:body.text];
    
    self.textLabel.size = [ARTConversationUtil converTextSize:attribuText];
    self.size = [ARTConversationUtil popaoTextSize:attribuText];
    self.backImageView.size = self.size;
    if ([ARTConversationUtil isSender:message])
    {
        self.backImageView.image = POPAO_IMAGE_SENDER;
        [attribuText addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attribuText.length)];
    }
    else
    {
        self.backImageView.image = POPAO_IMAGE_RECEDER;
        [attribuText addAttribute:NSForegroundColorAttributeName value:UICOLOR_ARGB(0xff333333) range:NSMakeRange(0, attribuText.length)];
    }
    self.backImageView.image = [ARTConversationUtil resizableImage:self.backImageView.image];
    self.textLabel.attributedText = attribuText;
    self.textLabel.center = CGPointMake(self.width / 2, self.height / 2 + 2);
}


@end

@interface ARTConversationCell()

@property (nonatomic , strong) UIImageView *faceView;

@property (nonatomic , strong) ARTConverText *converText;

@property (nonatomic , strong) ARTConverImage *converImage;

@property (nonatomic , strong) ARTConverVoice *converVoice;

@property (nonatomic , strong) ARTUserInfo *info;

@property (nonatomic , strong) EMMessage *message;

@property (nonatomic , strong) UIButton *errorButton;
@end

@implementation ARTConversationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.width = SCREEN_WIDTH;
        [self.contentView addSubview:self.faceView];
        [self.contentView addSubview:self.converText];
        [self.contentView addSubview:self.converImage];
        [self.contentView addSubview:self.converVoice];
        [self.contentView addSubview:self.errorButton];
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#define FACE_TOP 20
#define FACE_LEFT 20
- (void)bindingData:(EMMessage *)message info:(ARTUserInfo *)info
{
    self.info = info;
    self.message = message;
    
    self.faceView.top = FACE_TOP;
    self.converText.top = self.faceView.top;
    self.converImage.top = self.faceView.top;
    self.converVoice.top = self.faceView.top;
    
    self.converText.hidden = YES;
    self.converImage.hidden = YES;
    self.converVoice.hidden = YES;
    if ([message.body isKindOfClass:[EMTextMessageBody class]])
    {
        self.converText.hidden = NO;
        [self.converText bindingText:message];
    }
    
    if ([message.body isKindOfClass:[EMImageMessageBody class]])
    {
        self.converImage.hidden = NO;
        [self.converImage bindingImage:message];
        
        [self.converImage removeGestureRecognizer:self.converImage.gestureRecognizers.lastObject];
        WS(weak)
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [weak.delegate cellDidClickImage:message];
        }];
        [self.converImage addGestureRecognizer:imageTap];
        self.converImage.userInteractionEnabled = YES;
    }
    if ([message.body isKindOfClass:[EMVoiceMessageBody class]])
    {
        self.converVoice.hidden = NO;
        [self.converVoice bindingVoice:message];
        
        [self.converVoice removeGestureRecognizer:self.converVoice.gestureRecognizers.lastObject];
        WS(weak)
        UITapGestureRecognizer *voiceTap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [weak.delegate cellDidClickVoice:message];
        }];
        [self.converVoice addGestureRecognizer:voiceTap];
        self.converVoice.userInteractionEnabled = YES;
    }
    
    NSString *faceURL;
    BOOL isSender = [ARTConversationUtil isSender:message];
    if (isSender)
    {
        faceURL = [ARTUserManager sharedInstance].userinfo.userInfo.userImage;
        self.faceView.right = self.width - FACE_LEFT;
        self.converText.right = self.faceView.left - 10;
        self.converImage.right = self.faceView.left - 10;
        self.converVoice.right = self.faceView.left - 10;
    }
    else
    {
        faceURL = info.userImage;
        self.faceView.left = FACE_LEFT;
        self.converText.left = self.faceView.right + 10;
        self.converImage.left = self.faceView.right + 10;
        self.converVoice.left = self.faceView.right + 10;
    }
    [self.faceView sd_setImageWithURL:[NSURL URLWithString:faceURL] placeholderImage:IMAGE_PLACEHOLDER_MEMBER(info.userID.integerValue)];
    
    //点击头像
    [self.faceView removeGestureRecognizer:self.faceView.gestureRecognizers.lastObject];
    WS(weak)
    UITapGestureRecognizer *faceTap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [ARTAccountViewController launchViewController:weak.viewController userID:[ARTConversationUtil isSender:message] ? [ARTUserManager sharedInstance].userinfo.userInfo.userID : info.userID info:[ARTConversationUtil isSender:message] ? [ARTUserManager sharedInstance].userinfo.userInfo : info];
    }];
    [self.faceView addGestureRecognizer:faceTap];
    
    //发送失败的按钮
    self.errorButton.hidden = YES;
    if (message.status == EMMessageStatusFailed || message.status == EMMessageStatusPending)
    {
        self.errorButton.hidden = NO;
    }
    if ([message.body isKindOfClass:[EMTextMessageBody class]])
    {
        if (isSender)
        {
            self.errorButton.right = self.converText.left - 10;
        }
        else
        {
            self.errorButton.left = self.converText.right + 10;
        }
        self.errorButton.centerY = self.converText.centerY;
    }
    
    if ([message.body isKindOfClass:[EMImageMessageBody class]])
    {
        if (isSender)
        {
            self.errorButton.right = self.converImage.left - 10;
        }
        else
        {
            self.errorButton.left = self.converImage.right + 10;
        }
        self.errorButton.centerY = self.converImage.centerY;
    }
    if ([message.body isKindOfClass:[EMVoiceMessageBody class]])
    {
        if (isSender)
        {
            self.errorButton.right = self.converVoice.left - 10;
        }
        else
        {
            self.errorButton.left = self.converVoice.right + 10;
        }
        self.errorButton.centerY = self.converVoice.centerY;
    }

}

- (UIImageView *)faceView
{
    if (!_faceView)
    {
        _faceView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        _faceView.clipsToBounds = YES;
        _faceView.contentMode = UIViewContentModeScaleAspectFill;
        [_faceView circleBorderWidth:1 borderColor:[UIColor whiteColor]];
        
        _faceView.userInteractionEnabled = YES;
    }
    return _faceView;
}

- (ARTConverText *)converText
{
    if (!_converText)
    {
        _converText = [[ARTConverText alloc] init];
    }
    return _converText;
}

- (ARTConverImage *)converImage
{
    if (!_converImage)
    {
        _converImage = [[ARTConverImage alloc] init];
    }
    return _converImage;
}

- (ARTConverVoice *)converVoice
{
    if (!_converVoice)
    {
        _converVoice = [[ARTConverVoice alloc] init];
    }
    return _converVoice;
}

- (UIButton *)errorButton
{
    if (!_errorButton)
    {
        _errorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _errorButton.size = CGSizeMake(80, 60);
        [_errorButton setImage:[UIImage imageNamed:@"chat_7"] forState:UIControlStateNormal];
        [_errorButton setTitle:@"点击重发" forState:UIControlStateNormal];
        [_errorButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [_errorButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_errorButton setTitleColor:RGBCOLOR(245, 99, 79, 1) forState:UIControlStateNormal];
        _errorButton.titleLabel.font = FONT_WITH_13;
        [_errorButton addTarget:self action:@selector(errorButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _errorButton;
}

- (void)errorButtonClickAction
{
    [self.delegate cellDidClickResend:self.message];
}

+ (CGFloat)cellHeight:(EMMessage *)message
{
    if ([message.body isKindOfClass:[EMTextMessageBody class]])
    {
        EMTextMessageBody *body = (EMTextMessageBody *)message.body;
        CGSize popaoSize = [ARTConversationUtil popaoTextSize:[ARTConversationUtil conText:body.text]];
        return popaoSize.height + FACE_TOP + 30;
    }
    if ([message.body isKindOfClass:[EMImageMessageBody class]])
    {
        CGSize imageSize = [ARTConversationUtil converImageSize];
        return imageSize.height + FACE_TOP + 30;
    }
    if ([message.body isKindOfClass:[EMVoiceMessageBody class]])
    {
        EMVoiceMessageBody *body = (EMVoiceMessageBody *)message.body;
        CGSize voiceSize = [ARTConversationUtil converVoiceSize:body.duration];
        return voiceSize.height + FACE_TOP + 30;
    }
    return 0;
}

@end
