//
//  ARTNewsCell.m
//  ART
//
//  Created by huangtie on 16/6/28.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTNewsCell.h"

@interface ARTNewsCell()

@property (nonatomic , strong) UIImageView *pictureView;

@property (nonatomic , strong) UILabel *titleLabel;

@property (nonatomic , strong) UILabel *timeLabel;

@property (nonatomic , strong) UILabel *remarkLabel;

@end

@implementation ARTNewsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.size = CGSizeMake(SCREEN_WIDTH, ARTNEWSCELLHEIGHT);
        
        self.pictureView = [[UIImageView alloc] init];
        self.pictureView.size = CGSizeMake(125, 125);
        self.pictureView.left = 15;
        self.pictureView.centerY = self.height / 2;
        self.pictureView.clipsToBounds = YES;
        self.pictureView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.pictureView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.size = CGSizeMake(400, 20);
        self.titleLabel.font = FONT_WITH_18;
        self.titleLabel.textColor = UICOLOR_ARGB(0xff333333);
        self.titleLabel.left = self.pictureView.right + 20;
        self.titleLabel.top = self.pictureView.top;
        [self.contentView addSubview:self.titleLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.size = CGSizeMake(200, 20);
        self.timeLabel.font = FONT_WITH_16;
        self.timeLabel.textColor = UICOLOR_ARGB(0xff666666);
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel.right = self.width - 15;
        self.timeLabel.top = self.pictureView.top;
        [self.contentView addSubview:self.timeLabel];
        
        self.remarkLabel = [[UILabel alloc] init];
        self.remarkLabel.left = self.titleLabel.left;
        self.remarkLabel.width = self.width - self.remarkLabel.left - 15;
        self.remarkLabel.height = 20;
        self.remarkLabel.top = self.titleLabel.bottom + 10;
        self.remarkLabel.font = FONT_WITH_16;
        self.remarkLabel.textColor = UICOLOR_ARGB(0xff666666);
        self.remarkLabel.numberOfLines = 0;
        [self.contentView addSubview:self.remarkLabel];
    }
    return self;
}

- (void)updateData:(ARTNewsData *)data isWhite:(BOOL)isWhite
{
    self.contentView.backgroundColor = isWhite ? [UIColor whiteColor] : UICOLOR_ARGB(0xfffafafa);
    
    [self.pictureView sd_setImageWithURL:[NSURL URLWithString:data.newsImage] placeholderImage:IMAGE_PLACEHOLDER_BOOK];
    
    self.titleLabel.text = data.newsTitle;
    
    self.timeLabel.text = [NSString timeString:data.newsTime dateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    self.remarkLabel.text = data.newsRemark;
    
    CGFloat remarkHeight = [data.newsRemark heightForFont:self.remarkLabel.font width:self.remarkLabel.width];
    if (remarkHeight < self.pictureView.height - 30)
    {
        self.remarkLabel.height = remarkHeight;
    }
    else
    {
        self.remarkLabel.height = self.pictureView.height - 30;
    }
}

@end
