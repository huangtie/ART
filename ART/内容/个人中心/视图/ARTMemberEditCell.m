//
//  ARTMemberEditCell.m
//  ART
//
//  Created by huangtie on 16/6/23.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTMemberEditCell.h"

@implementation ARTMemberEditCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.height = frame.size.height;
        self.width = frame.size.width;
        self.separatorInset = UIEdgeInsetsZero;
        self.textLabel.font = FONT_WITH_16;
        self.textLabel.textColor = UICOLOR_ARGB(0xff333333);
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.contenLabel = [[UILabel alloc] init];
        self.contenLabel.size = CGSizeMake(400, 20);
        self.contenLabel.centerY = self.height / 2;
        self.contenLabel.right = self.width - 70;
        self.contenLabel.font = FONT_WITH_15;
        self.contenLabel.textColor = UICOLOR_ARGB(0xff333333);
        self.contenLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.contenLabel];
        
        self.faceView = [[UIImageView alloc] init];
        self.faceView.size = CGSizeMake(60, 60);
        self.faceView.centerY = self.height / 2;
        self.faceView.right = self.width - 70;
        self.faceView.clipsToBounds = YES;
        self.faceView.contentMode = UIViewContentModeScaleAspectFill;
        self.faceView.hidden = YES;
        [self.faceView circleBorderWidth:0 borderColor:[UIColor clearColor]];
        [self.contentView addSubview:self.faceView];
        
    }
    return self;
}

@end
