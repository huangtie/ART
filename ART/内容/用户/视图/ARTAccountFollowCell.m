//
//  ARTAccountFollowCell.m
//  ART
//
//  Created by huangtie on 16/7/8.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTAccountFollowCell.h"

@interface ARTAccountFollowCell()

@property (nonatomic , strong) UIImageView *faceView;

@property (nonatomic , strong) UILabel *nickLabel;

@property (nonatomic , strong) UILabel *loctionLabel;

@property (nonatomic , strong) UIButton *button;

@property (nonatomic , copy) NSString *userID;
@end

@implementation ARTAccountFollowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.size = CGSizeMake(SCREEN_WIDTH, ARTACCOUNTFOLLOWCELLHEIGHT);
        
        self.faceView = [[UIImageView alloc] init];
        self.faceView.size = CGSizeMake(self.height - 20, self.height - 20);
        self.faceView.left = 20;
        self.faceView.centerY = self.height / 2;
        self.faceView.clipsToBounds = YES;
        self.faceView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.faceView];
        
        self.nickLabel = [[UILabel alloc] init];
        self.nickLabel.height = 25;
        self.nickLabel.left = self.faceView.right + 20;
        self.nickLabel.centerY = self.height / 2;
        self.nickLabel.width = 300;
        self.nickLabel.font = FONT_WITH_21;
        self.nickLabel.textColor = UICOLOR_ARGB(0xff333333);
        [self.contentView addSubview:self.nickLabel];
        
        self.loctionLabel = [[UILabel alloc] init];
        self.loctionLabel.left = self.faceView.right + 10;
        self.loctionLabel.top = self.nickLabel.bottom + 5;
        self.loctionLabel.height = 20;
        self.loctionLabel.width = 500;
        self.loctionLabel.font = FONT_WITH_17;
        self.loctionLabel.textColor = UICOLOR_ARGB(0xff666666);
        [self.contentView addSubview:self.loctionLabel];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.size = CGSizeMake(100, 45);
        self.button.centerY = self.height / 2;
        self.button.right = self.width - 20;
        [self.button setBackgroundColor:COLOR_YSYC_ORANGE];
        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.button.titleLabel.font = FONT_WITH_20;
        [self.button clipRadius:4 borderWidth:0 borderColor:nil];
        [self.button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.button];
    }
    return self;
}

- (void)bindingWithData:(ARTUserInfo *)data type:(ACCOUNT_CELL_TYPE)type
{
    self.userID = data.userID;
    
    WS(weak)
    [self.faceView.layer setImageWithURL:[NSURL URLWithString:data.userImage]
                    placeholder:IMAGE_PLACEHOLDER_MEMBER
                        options:YYWebImageOptionShowNetworkActivity
                     completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                         if (image && stage == YYWebImageStageFinished)
                         {
                             weak.faceView.layer.contentsRect = CGRectMake(0, 0, 1, 1);
                             weak.faceView.image = image;
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
    
    self.nickLabel.text = data.userNick;
    
    [self.button setTitle:type == ACCOUNT_CELL_TYPE_TALK ? @"私信TA" : @"加关注" forState:UIControlStateNormal];

}

- (void)buttonAction
{
    [self.delegate accountDidTouchButton:self.userID];
}

@end
