//
//  ARTAuthorCell.m
//  ART
//
//  Created by huangtie on 16/6/28.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTAuthorCell.h"

@interface ARTAuthorCell()

@property (nonatomic , strong) UIImageView *imageView;

@property (nonatomic , strong) UILabel *nameLabel;

@end

@implementation ARTAuthorCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.size = CGSizeMake(200, 260);
        self.imageView.center = CGPointMake(self.width / 2, self.height / 2 - 20);
        self.imageView.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.imageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.imageView.left, self.imageView.bottom + 10, self.imageView.width, 20)];
        self.nameLabel.font = FONT_WITH_20;
        self.nameLabel.textColor = UICOLOR_ARGB(0xff333333);
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}

- (void)bindingWithData:(ARTAuthorData *)data
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:data.authorImag] placeholderImage:IMAGE_PLACEHOLDER_BOOK];
    
    self.nameLabel.text = data.authorName;
}

@end
