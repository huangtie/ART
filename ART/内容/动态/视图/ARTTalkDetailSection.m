//
//  ARTTalkDetailSection.m
//  ART
//
//  Created by huangtie on 16/7/6.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTTalkDetailSection.h"

@interface ARTTalkDetailSection()

@property (nonatomic , strong) ARTTalkComData *comData;

@end

@implementation ARTTalkDetailSection

#define spacing 8
#define LABEL_WIDTH 600
#define LABEL_HEIGHT 20
#define LEFT 120
#define FONT_NICK FONT_WITH_18
#define FONT_TEXT FONT_WITH_16
+ (CGFloat)viewHeight:(ARTTalkComData *)comData
{
    CGFloat height = 0;
    
    height += spacing;
    
    //昵称高度
    height += LABEL_HEIGHT;
    
    height += spacing;
    
    //时间高度
    height += LABEL_HEIGHT;
    
    height += spacing;
    
    //内容高度
    CGFloat textHeight = [comData.comText heightForFont:FONT_TEXT width:LABEL_WIDTH];
    height += textHeight;
    
    height += spacing;
    
    return height;
}

+ (ARTTalkDetailSection *)crate:(ARTTalkComData *)comData
{
    ARTTalkDetailSection *view = [[ARTTalkDetailSection alloc] initWithData:comData];
    return view;
}

- (instancetype)initWithData:(ARTTalkComData *)comData
{
    self = [super init];
    if (self)
    {
        self.comData = comData;
        self.backgroundColor = [UIColor whiteColor];
        self.width = SCREEN_WIDTH;
        self.height = [ARTTalkDetailSection viewHeight:comData];
        
        WS(weakself)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            ARTSendTalkComParam *param = [[ARTSendTalkComParam alloc] init];
            param.replayID = comData.comID;
            param.accept = comData.comUser;
            param.replayNick = comData.comNick;
            [weakself.delegate sectionWillReplay:param];
        }];
        [self addGestureRecognizer:tap];
        self.userInteractionEnabled = YES;
        
        //头像
        UIImageView *face = [[UIImageView alloc] init];
        face.size = CGSizeMake(55, 55);
        face.contentMode = UIViewContentModeScaleAspectFill;
        face.clipsToBounds = YES;
        face.top = spacing;
        face.right = LEFT - 15;
        [face circleBorderWidth:1 borderColor:[UIColor whiteColor]];
        [self addSubview:face];
        __weak __typeof(face) weak = face;
        [face.layer setImageWithURL:[NSURL URLWithString:comData.comImage]
                        placeholder:IMAGE_PLACEHOLDER_MEMBER
                            options:YYWebImageOptionShowNetworkActivity
                         completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                                      if (image && stage == YYWebImageStageFinished)
                                      {
                                          weak.layer.contentsRect = CGRectMake(0, 0, 1, 1);
                                          weak.image = image;
                                          if (from != YYWebImageFromMemoryCacheFast)
                                          {
                                              CATransition *transition = [CATransition animation];
                                              transition.duration = 0.15;
                                              transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                                              transition.type = kCATransitionFade;
                                              [weak.layer addAnimation:transition forKey:@"contents"];
                                          }
                                      }
                                  }];
        
        //昵称
        UILabel *nick = [[UILabel alloc] init];
        nick.size = CGSizeMake(LABEL_WIDTH, LABEL_HEIGHT);
        nick.left = LEFT;
        nick.top = spacing;
        nick.textColor = UICOLOR_ARGB(0xff333333);
        nick.font = FONT_WITH_19;
        nick.text = comData.comNick;
        [self addSubview:nick];
        
        //时间
        UILabel *time = [[UILabel alloc] init];
        time.size = CGSizeMake(LABEL_WIDTH, LABEL_HEIGHT);
        time.left = LEFT;
        time.top = nick.bottom + spacing;
        time.textColor = UICOLOR_ARGB(0xff999999);
        time.font = FONT_WITH_15;
        time.text = [NSString timeString:comData.comTime dateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [self addSubview:time];
        
        //内容
        UILabel *text = [[UILabel alloc] init];
        text.size = CGSizeMake(LABEL_WIDTH, [comData.comText heightForFont:FONT_TEXT width:LABEL_WIDTH]);
        text.left = LEFT;
        text.top = time.bottom + spacing;
        text.textColor = UICOLOR_ARGB(0xff666666);
        text.font = FONT_TEXT;
        text.text = comData.comText;
        text.numberOfLines = 0;
        [self addSubview:text];
    }
    return self;
}


@end
