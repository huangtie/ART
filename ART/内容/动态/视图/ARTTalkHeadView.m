//
//  ARTTalkHeadView.m
//  ART
//
//  Created by huangtie on 16/7/4.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTTalkHeadView.h"

@interface ARTTalkHeadView()

@property (nonatomic , strong) ARTTalkData *data;

@property (nonatomic , strong) UIImageView *faceView;

@property (nonatomic , strong) UILabel *nickLabel;

@property (nonatomic , strong) UILabel *contentLabel;

@property (nonatomic , strong) UIView *imageRect;

@property (nonatomic , strong) UILabel *fromLabel;

@property (nonatomic , strong) UIButton *deleteButton;

@property (nonatomic , strong) UILabel *timeLabel;

@property (nonatomic , strong) UILabel *zanLabel;

@property (nonatomic , strong) UIButton *comButton;

@property (nonatomic , strong) UIButton *zanButton;

@property (nonatomic , strong) UIView *line;

@end

@implementation ARTTalkHeadView

#define spacing 16
#define LABEL_WIDTH 600
#define LABEL_HEIGHT 20
#define FONT_NICK FONT_WITH_20
#define FONT_TEXT FONT_WITH_17
#define IMAGE_WITH 100
#define ZAN_HEIGHT 60

+ (CGFloat)viewHeight:(ARTTalkData *)data
{
    CGFloat height = 0;
    
    height += spacing;
    
    //昵称高度
    height += 25;
    
    height += spacing;
    
    //文字内容高度
    CGFloat textHeight = 0;
    if (data.talkText.length)
    {
        textHeight = [data.talkText heightForFont:FONT_TEXT width:LABEL_WIDTH];
    }
    height += textHeight;
    
    height += spacing;
    
    //图片高度
    NSInteger imageCount = data.talkImages.count;
    CGFloat imageHeight = 0;
    if (imageCount)
    {
        if (imageCount == 1)
        {
            imageHeight = IMAGE_WITH * 3;
        }
        else if(imageCount > 1 && imageCount < 4)
        {
            imageHeight = IMAGE_WITH;
        }
        else if(imageCount > 3 && imageCount < 7)
        {
            imageHeight = IMAGE_WITH * 2 + 5;
        }
        else if(imageCount > 6 && imageCount < 10)
        {
            imageHeight = IMAGE_WITH * 3 + 2 * 5;
        }
    }
    height += imageHeight;
    
    height += spacing;
    
    //来自高度
    height += LABEL_HEIGHT;
    
    height += spacing;
    
    //时间高度
    height +=LABEL_HEIGHT;
    
    height += 20;
    
    //赞区域
    if (data.zanCount.integerValue > 0)
    {
        height += ZAN_HEIGHT;
    }
    
    return height;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark GET_SET
- (UIImageView *)faceView
{
    if (!_faceView)
    {
        _faceView = [[UIImageView alloc] initWithFrame:CGRectMake(spacing, spacing, 90, 90)];
        _faceView.clipsToBounds = YES;
        _faceView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_faceView];
    }
    return _faceView;
}

- (UILabel *)nickLabel
{
    if (!_nickLabel)
    {
        _nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.faceView.right + spacing, self.faceView.top, LABEL_WIDTH, 25)];
        _nickLabel.font = FONT_NICK;
        _nickLabel.textColor = COLOR_YSYC_ORANGE;
        [self addSubview:_nickLabel];
    }
    return _nickLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel)
    {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nickLabel.left, self.nickLabel.bottom + spacing, LABEL_WIDTH, 0)];
        _contentLabel.font = FONT_TEXT;
        _contentLabel.textColor = UICOLOR_ARGB(0xff333333);
        _contentLabel.numberOfLines = 0;
        [self addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (UIView *)imageRect
{
    if (!_imageRect)
    {
        _imageRect = [[UIView alloc] init];
        [self addSubview:_imageRect];
    }
    return _imageRect;
}

- (UILabel *)fromLabel
{
    if (!_fromLabel)
    {
        _fromLabel = [[UILabel alloc] init];
        _fromLabel.left = self.nickLabel.left;
        _fromLabel.height = LABEL_HEIGHT;
        _fromLabel.width = 200;
        self.fromLabel.font = FONT_WITH_16;
        self.fromLabel.textColor = COLOR_YSYC_ORANGE;
        [self addSubview:self.fromLabel];
    }
    return _fromLabel;
}

- (UIButton *)deleteButton
{
    if (!_deleteButton)
    {
//        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
//        [_deleteButton setTitleColor:UICOLOR_ARGB(0xff5dadff) forState:UIControlStateNormal];
//        _deleteButton.titleLabel.font = FONT_WITH_16;
//        _deleteButton.size = CGSizeMake(40, 40);
//        [_deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_deleteButton];
    }
    return _deleteButton;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel)
    {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.left = self.nickLabel.left;
        _timeLabel.height = LABEL_HEIGHT;
        _timeLabel.width = 200;
        _timeLabel.font = FONT_WITH_16;
        _timeLabel.textColor = UICOLOR_ARGB(0xff888888);
        [self addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UIButton *)comButton
{
    if (!_comButton)
    {
        _comButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_comButton setBackgroundImage:[UIImage imageNamed:@"talk_icon_12"] forState:UIControlStateNormal];
        [_comButton sizeToFit];
        [_comButton addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_comButton];
    }
    return _comButton;
}

- (UIButton *)zanButton
{
    if (!_zanButton)
    {
        _zanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zanButton setBackgroundImage:[UIImage imageNamed:@"talk_icon_11"] forState:UIControlStateNormal];
        [_zanButton sizeToFit];
        [_zanButton addTarget:self action:@selector(zanAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_zanButton];
    }
    return _zanButton;
}

- (UIView *)line
{
    if (!_line)
    {
        _line = [[UIView alloc] init];
        _line.left = self.nickLabel.left;
        _line.width = self.nickLabel.width;
        _line.height = ONE_POINT_LINE_WIDTH;
        _line.backgroundColor = UICOLOR_ARGB(0xffe5e5e5);
        [self addSubview:_line];
    }
    return _line;
}

- (UILabel *)zanLabel
{
    if (!_zanLabel)
    {
        _zanLabel = [[UILabel alloc] init];
        _zanLabel.left = self.nickLabel.left;
        _zanLabel.height = ZAN_HEIGHT;
        _zanLabel.width = LABEL_WIDTH;
        _zanLabel.font = FONT_WITH_15;
        _zanLabel.textColor = COLOR_YSYC_ORANGE;
        _zanLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [self addSubview:_zanLabel];
    }
    return _zanLabel;
}

#pragma mark LAYOUT
- (void)bindingWithData:(ARTTalkData *)data index:(NSInteger)index
{
    self.data = data;
    self.size = CGSizeMake(SCREEN_WIDTH, [ARTTalkHeadView viewHeight:data]);
    self.backgroundColor = index % 2 == 0 ? [UIColor whiteColor] : UICOLOR_ARGB(0xfffafafa);
    
    //头像
    WS(weak)
    [self.faceView.layer setImageWithURL:[NSURL URLWithString:data.sender.userImage]
                             placeholder:IMAGE_PLACEHOLDER_BOOK
                                 options:YYWebImageOptionShowNetworkActivity
                              completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                                  if (!weak.faceView) return;
                                  if (image && stage == YYWebImageStageFinished)
                                  {
                                      weak.faceView.layer.contentsRect = CGRectMake(0, 0, 1, 1);
                                      weak.faceView.image = [UIImage imageWithData:UIImageJPEGRepresentation(image, .5)];
                                      if (from != YYWebImageFromMemoryCacheFast)
                                      {
                                          CATransition *transition = [CATransition animation];
                                          transition.duration = 0.15;
                                          transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                                          transition.type = kCATransitionFade;
                                          [weak.faceView.layer addAnimation:transition forKey:@"contents"];
                                      }
                                  }
                              }];
    
    
    //昵称
    self.nickLabel.text = data.sender.userNick;
    
    //文字
    self.contentLabel.height = data.talkText.length ? [data.talkText heightForFont:FONT_TEXT width:LABEL_WIDTH] : 0;
    self.contentLabel.text = data.talkText;
    
    //图片
    NSInteger imageCount = data.talkImages.count;
    CGFloat imageHeight = 0;
    CGFloat imageWidth = IMAGE_WITH * 3 + 2 * 5;
    if (imageCount)
    {
        if (imageCount == 1)
        {
            imageHeight = IMAGE_WITH * 3;
            imageWidth = IMAGE_WITH * 3;
        }
        else if(imageCount > 1 && imageCount < 4)
        {
            imageHeight = IMAGE_WITH;
        }
        else if(imageCount > 3 && imageCount < 7)
        {
            imageHeight = IMAGE_WITH * 2 + 5;
        }
        else if(imageCount > 6 && imageCount < 10)
        {
            imageHeight = IMAGE_WITH * 3 + 2 * 5;
        }
    }
    self.imageRect.left = self.nickLabel.left;
    self.imageRect.top = self.contentLabel.bottom + spacing;
    self.imageRect.size = CGSizeMake(imageWidth, imageHeight);
    [self.imageRect.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (imageCount == 1)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.imageRect.bounds];
        [self.imageRect addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        NSString *url = data.talkImages.firstObject;
        [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:IMAGE_PLACEHOLDER_BOOK];
    }
    else
    {
        NSMutableArray *data2D = [[NSMutableArray alloc] init];
        NSMutableArray *tmps = [[NSMutableArray alloc] init];
        for (NSInteger i = 1; i <= imageCount; i++)
        {
            [tmps addObject:data.talkImages[i - 1]];
            if ((i % 3 == 0) || i == imageCount)
            {
                [data2D addObject:tmps];
                tmps = [[NSMutableArray alloc] init];
            }
        }
        for (NSInteger i = 0; i < data2D.count; i++)
        {
            NSArray *images = data2D[i];
            for (NSInteger j = 0 ; j < images.count; j++)
            {
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.size = CGSizeMake(IMAGE_WITH, IMAGE_WITH);
                imageView.top = i * (IMAGE_WITH + 5);
                imageView.left = j * (IMAGE_WITH + 5);
                [self.imageRect addSubview:imageView];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.clipsToBounds = YES;
                NSString *url = images[j];
                [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:IMAGE_PLACEHOLDER_BOOK];
            }
        }
    }
    
    for (UIView *view in self.imageRect.subviews)
    {
        if ([view isKindOfClass:[UIImageView class]])
        {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
                NSInteger index = [weak.imageRect.subviews indexOfObject:view];
                [weak.delegate headDidTouchImage:weak.data index:index];
            }];
            [view addGestureRecognizer:tap];
            view.userInteractionEnabled = YES;
        }
    }
    
    //来自
    self.fromLabel.top = self.imageRect.bottom + spacing;
    self.fromLabel.text = STRING_FORMAT(@"来自: ", data.talkFrom);
    
    //删除按钮
    self.deleteButton.hidden = YES;
    if ([[ARTUserManager sharedInstance] isLogin]
        && [[ARTUserManager sharedInstance].userinfo.userInfo.userID isEqualToString:data.sender.userID])
    {
        self.deleteButton.centerY = self.fromLabel.centerY;
        self.deleteButton.right = self.imageRect.right;
        self.deleteButton.hidden = NO;
    }
    
    //时间
    self.timeLabel.top = self.fromLabel.bottom + spacing;
    self.timeLabel.text = [NSString timeString:data.talkTime dateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //评论按钮
    self.comButton.centerY = self.timeLabel.centerY;
    self.comButton.right = self.nickLabel.right - 10;
    
    //点赞按钮
    self.zanButton.centerY = self.comButton.centerY;
    self.zanButton.right = self.comButton.left - 20;
    
    //横线
    self.line.hidden = YES;
    self.zanLabel.hidden = YES;
    if (data.zanCount.integerValue > 0 || data.comCount.integerValue > 0)
    {
        self.line.hidden = NO;
        self.line.top = self.timeLabel.bottom + 20;
        
        //赞的人列表
        if (data.zanCount.integerValue > 0)
        {
            self.zanLabel.hidden = NO;
            self.zanLabel.top = self.line.bottom;
            self.zanLabel.attributedText = [self zanString];
        }
    }
}

- (void)deleteAction
{
    [self.delegate headDidTouchDelete:self.data];
}

- (void)commentAction
{
    [self.delegate headDidTouchComment:self.data];
}

- (void)zanAction
{
    [self.delegate headDidTouchZan:self.data];
}

- (NSMutableAttributedString *)zanString
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    NSTextAttachment * textAttachment = [[NSTextAttachment alloc] init];//添加附件,图片
    textAttachment.image = [UIImage imageNamed:@"talk_icon_13"];
    textAttachment.bounds = CGRectMake(0, -6 , 25, 22);
    NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [text appendAttributedString:imageStr];
    [text appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"  "]];

    for (ARTUserInfo *info in self.data.zanList)
    {
        if (info != self.data.zanList.firstObject)
        {
            [text appendAttributedString:[self interval]];
        }
        [text appendAttributedString:[self nickString:info.userNick]];
    }
    [text appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"  "]];
    [text appendAttributedString:[self nickString:STRING_FORMAT(self.data.zanCount, @"人觉得赞")]];
    return text;
}

- (NSMutableAttributedString *)nickString:(NSString *)string
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    [text addAttribute:NSFontAttributeName value:FONT_WITH_15 range:NSMakeRange(0, text.length)];
    [text addAttribute:NSForegroundColorAttributeName value:COLOR_YSYC_ORANGE range:NSMakeRange(0, text.length)];
    return text;
}

- (NSMutableAttributedString *)interval
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"、"];
    [text addAttribute:NSFontAttributeName value:FONT_WITH_15 range:NSMakeRange(0, text.length)];
    [text addAttribute:NSForegroundColorAttributeName value:UICOLOR_ARGB(0xff666666) range:NSMakeRange(0, text.length)];
    return text;
}




@end
