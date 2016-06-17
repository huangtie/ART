//
//  ARTLocalMinCell.m
//  ART
//
//  Created by huangtie on 16/6/17.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTLocalMinCell.h"
#import "ImageLoader.h"

@interface ARTLocalMinCell()

@property (nonatomic , strong) UIImageView *imageView;

@property (nonatomic , strong) ARTBookPhotoData *data;

@end

@implementation ARTLocalMinCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 200)];
        self.imageView.center = CGPointMake(self.width / 2, self.height / 2);
        self.imageView.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)update:(ARTBookPhotoData *)data isSelect:(BOOL)isSelect
{
    self.data = data;
    
    ImageLoader *loader = [[ImageLoader alloc] init];
    [loader displayImage:FILE_PATH_PIC(data.saveURL) inImageView:self.imageView];
    if (isSelect)
    {
        [self.imageView clipRadius:5 borderWidth:5 borderColor:COLOR_YSYC_ORANGE];
    }
    else
    {
        self.imageView.layer.cornerRadius = 0;
        self.imageView.layer.borderWidth = 0;
        self.imageView.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

- (void)tapAction
{
    [self.delegate cellDidSelect:self.data];
}

@end
