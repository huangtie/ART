//
//  ARTMemberLogCell.m
//  ART
//
//  Created by huangtie on 16/6/27.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTMemberLogCell.h"

@interface ARTMemberLogCell()

@property (nonatomic , strong) UILabel *remarkLabel;

@property (nonatomic , strong) UILabel *priceLabel;

@property (nonatomic , strong) UILabel *timeLabel;

@end

@implementation ARTMemberLogCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.size = CGSizeMake(SCREEN_WIDTH, ARTMEMBERLOGCELLHEIGHT);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;

        self.remarkLabel = [[UILabel alloc] init];
        self.remarkLabel.size = CGSizeMake(400, 20);
        self.remarkLabel.left = 20;
        self.remarkLabel.centerY = self.height / 2;
        self.remarkLabel.font = FONT_WITH_18;
        self.remarkLabel.textColor = UICOLOR_ARGB(0xff333333);
        [self.contentView addSubview:self.remarkLabel];
        
        self.priceLabel = [[UILabel alloc] init];
        self.priceLabel.font = FONT_WITH_16;
        self.priceLabel.textAlignment = NSTextAlignmentRight;
        self.priceLabel.size = CGSizeMake(200, 20);
        self.priceLabel.right = self.width - 20;
        self.priceLabel.top = (self.height - 45) / 2;
        [self.contentView addSubview:self.priceLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.font = FONT_WITH_16;
        self.timeLabel.textColor = UICOLOR_ARGB(0xff888888);
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel.size = CGSizeMake(200, 20);
        self.timeLabel.right = self.width - 20;
        self.timeLabel.top = self.priceLabel.bottom + 5;
        [self.contentView addSubview:self.timeLabel];
        
    }
    return self;
}

- (void)updateData:(ARTPurchasesLogData *)data
{
    self.remarkLabel.text = data.logRemark;
    
    self.timeLabel.text = [NSString timeString:data.logTime dateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    if (data.logType.boolValue)
    {
        self.priceLabel.textColor = UICOLOR_ARGB(0xff17bc33);
        self.priceLabel.text = STRING_FORMAT(@"+", data.logPrice);
    }
    else
    {
        self.priceLabel.textColor = UICOLOR_ARGB(0xfffe0606);
        self.priceLabel.text = STRING_FORMAT(@"-", data.logPrice);
    }
}


@end
