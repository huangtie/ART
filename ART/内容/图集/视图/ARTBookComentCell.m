//
//  ARTBookComentCell.m
//  ART
//
//  Created by huangtie on 16/5/27.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBookComentCell.h"
#import "ARTPointView.h"

@interface ARTBookComentCell()

@property (nonatomic , strong) UIImageView *face;

@property (nonatomic , strong) UILabel *nickLabel;

@property (nonatomic , strong) UILabel *contentLabel;

@property (nonatomic , strong) UILabel *timeLabel;

@property (nonatomic , strong) ARTPointView *starView;

@end

@implementation ARTBookComentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.width = SCREEN_WIDTH;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.face];
        [self.contentView addSubview:self.nickLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.timeLabel];
    }
    return self;
}

- (UIImageView *)face
{
    if (!_face)
    {
        _face = [[UIImageView alloc] init];
        _face.size = CGSizeMake(50, 50);
        _face.contentMode = UIViewContentModeScaleAspectFit;
        [_face circleBorderWidth:2 borderColor:UICOLOR_ARGB(0xffe6e6e6)];
    }
    return _face;
}

- (UILabel *)nickLabel
{
    if (!_nickLabel)
    {
        _nickLabel = [[UILabel alloc] init];
        _nickLabel.font = FONT_WITH_15;
        _nickLabel.textColor = UICOLOR_ARGB(0xff333333);
    }
    return _nickLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel)
    {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = FONT_WITH_14;
        _contentLabel.textColor = UICOLOR_ARGB(0xff666666);
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel)
    {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = FONT_WITH_14;
        _timeLabel.textColor = UICOLOR_ARGB(0xff666666);
    }
    return _timeLabel;
}

#define LABEL_HEIGHT 20
#define CONTENT_WIDTH 670
- (void)bindingWithData:(ARTCommentData *)commentData isW:(BOOL)isW
{
    self.contentView.backgroundColor = isW ? [UIColor whiteColor] : UICOLOR_ARGB(0xfffafafa);
    
    CGFloat left = 15;
    CGFloat top = 30;
    
    //头像
    self.face.top = top;
    self.face.left = left;
    WS(weak)
    [self.face.layer setImageWithURL:[NSURL URLWithString:commentData.userImage]
                            placeholder:IMAGE_PLACEHOLDER_MEMBER(commentData.userID.integerValue)
                                options:YYWebImageOptionShowNetworkActivity
                             completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                                 if (!weak.face) return;
                                 if (image && stage == YYWebImageStageFinished)
                                 {
                                     weak.face.contentMode = UIViewContentModeScaleAspectFill;
                                     weak.face.layer.contentsRect = CGRectMake(0, 0, 1, 1);
                                     weak.face.clipsToBounds = YES;
                                     weak.face.image = image;
                                     if (from != YYWebImageFromMemoryCacheFast)
                                     {
                                         CATransition *transition = [CATransition animation];
                                         transition.duration = 0.15;
                                         transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                                         transition.type = kCATransitionFade;
                                         [weak.face.layer addAnimation:transition forKey:@"contents"];
                                     }
                                 }
                             }];
    
    //昵称
    self.nickLabel.left = self.face.right + 10;
    self.nickLabel.top = self.face.top + 10;
    self.nickLabel.text = commentData.userNick;
    [self.nickLabel sizeToFit];
    self.nickLabel.height = LABEL_HEIGHT;
    
    //评分
    [self.starView removeFromSuperview];
    self.starView = [ARTPointView point:commentData.commentPoint.floatValue];
    self.starView.top = self.nickLabel.top;
    self.starView.right = self.width - 25;
    [self.contentView addSubview:self.starView];
    
    //内容
    self.contentLabel.left = self.nickLabel.left;
    self.contentLabel.top = self.nickLabel.bottom + 10;
    self.contentLabel.width = CONTENT_WIDTH;
    self.contentLabel.height = [ARTBookComentCell labelHeight:commentData.commentText];
    self.contentLabel.text = commentData.commentText;
    
    //时间
    self.timeLabel.text = [ARTBookComentCell TIME:commentData.commentTime];
    [self.timeLabel sizeToFit];
    self.timeLabel.height = LABEL_HEIGHT;
    self.timeLabel.top = self.contentLabel.bottom + 20;
    self.timeLabel.right = self.starView.right;
    
    self.size = CGSizeMake(SCREEN_WIDTH, self.timeLabel.bottom + 20);
}

+ (NSString *)TIME:(NSString *)timeString
{
    if (!timeString || !timeString.length || timeString.length < 10)
    {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //截取前十位  （由于时间戳的时13位的  所以要截取 得到10位的）
    NSString *time = [timeString substringToIndex:10];
    // 时间戳转时间的方法   将前面nsstring的time幻化成int型之后  赋值给  nsstring  为了判断之后截取需要的时间
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[time integerValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

+ (CGFloat)cellHeight:(NSString *)text
{
    CGFloat contentHeight = [ARTBookComentCell labelHeight:text];
    return contentHeight + 70 + 20 + 20 + 20;
}

+ (CGFloat)labelHeight:(NSString *)text
{
    CGSize size = [text sizeForFont:FONT_WITH_14 size:CGSizeMake(CONTENT_WIDTH, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping];
    return size.height;
}

@end
