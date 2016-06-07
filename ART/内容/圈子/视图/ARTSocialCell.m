//
//  ARTSocialCell.m
//  ART
//
//  Created by huangtie on 16/6/6.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTSocialCell.h"

@interface ARTSocialCell()

@property (nonatomic , strong) UILabel *noreadLabel;

@end

@implementation ARTSocialCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.size = CGSizeMake(SCREEN_WIDTH, ARTSocialCellHeight);
        self.separatorInset = UIEdgeInsetsZero;
        
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"talk_icon_arrow"]];
        [arrow sizeToFit];
        arrow.right = self.width - 30;
        arrow.centerY = self.height / 2;
        [self.contentView addSubview:arrow];
    }
    return self;
}

- (UILabel *)noreadLabel
{
    if (!_noreadLabel)
    {
        _noreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _noreadLabel.font = FONT_WITH_12;
        _noreadLabel.textColor = [UIColor whiteColor];
        _noreadLabel.backgroundColor = UICOLOR_ARGB(0xfffc0d1b);
        _noreadLabel.textAlignment = NSTextAlignmentCenter;
        [_noreadLabel circleBorderWidth:0 borderColor:[UIColor clearColor]];
        _noreadLabel.centerY = self.height / 2;
        _noreadLabel.right = self.width - 60;
        _noreadLabel.hidden = YES;
        [self.contentView addSubview:_noreadLabel];
    }
    return _noreadLabel;
}

- (void)updateData:(NSString *)iconName
         titleName:(NSString *)titleName
           isWhite:(BOOL)isWhite
{
    self.imageView.image = [UIImage imageNamed:iconName];
    
    self.textLabel.text = titleName;
    self.textLabel.font = FONT_WITH_15;
    self.textLabel.textColor = UICOLOR_ARGB(0xff333333);
    
    self.contentView.backgroundColor = isWhite ? [UIColor whiteColor] : COLOR_YSYC_GRAY;
}

- (void)upDateNoRead:(NSInteger)count
{
    if (count == 0)
    {
        self.noreadLabel.hidden = YES;
    }
    else
    {
        self.noreadLabel.hidden = NO;
        self.noreadLabel.text = STRING_FORMAT_ADC(@(count));
        if (count > 99)
        {
            self.noreadLabel.text = @"99";
        }
    }
}

@end
