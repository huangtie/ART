//
//  ARTAccountDetailCell.m
//  ART
//
//  Created by huangtie on 16/7/12.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTAccountDetailCell.h"

@implementation ARTAccountDetailCell

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.size = CGSizeMake(SCREEN_WIDTH, 70);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.size = CGSizeMake(120, 30);
        self.nameLabel.font = FONT_WITH_23;
        self.nameLabel.textColor = UICOLOR_ARGB(0xff666666);
        self.nameLabel.left = 80;
        self.nameLabel.centerY = self.height / 2;
        [self.contentView addSubview:self.nameLabel];
        
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.size = CGSizeMake(self.width - self.nameLabel.right - self.nameLabel.left, 25);
        self.contentLabel.font = FONT_WITH_23;
        self.contentLabel.textColor = UICOLOR_ARGB(0xff999999);
        self.contentLabel.left = self.nameLabel.right;
        self.contentLabel.centerY = self.height / 2;
        [self.contentView addSubview:self.contentLabel];
    }
    return self;
}


@end
