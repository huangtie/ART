//
//  ARTPurchasesCell.m
//  ART
//
//  Created by huangtie on 16/6/22.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTPurchasesCell.h"

@interface ARTPurchasesCell()

@property (nonatomic , strong) UILabel *titleLabel;

@property (nonatomic , strong) UIButton *item;

@end

@implementation ARTPurchasesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.size = CGSizeMake(SCREEN_WIDTH, ARTPURCHASESCELL_HEIGHT);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 300, 20)];
        self.titleLabel.centerY = self.height / 2;
        self.titleLabel.font = FONT_WITH_15;
        self.titleLabel.textColor = UICOLOR_ARGB(0xff333333);
        [self.contentView addSubview:self.titleLabel];
        
        self.item = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.item setBackgroundImage:[UIImage imageNamed:@"purchases_icon_1"] forState:UIControlStateNormal];
        [self.item setBackgroundImage:[UIImage imageNamed:@"purchases_icon_2"] forState:UIControlStateSelected];
        [self.item sizeToFit];
        self.item.centerY = self.height / 2;
        self.item.right = self.width - 15;
        [self.contentView addSubview:self.item];
    }
    return self;
}

- (void)updateData:(ARTPurchasesData *)data isSelect:(BOOL)isSelect
{
    self.titleLabel.text = data.iapRemark;
    
    self.item.selected = isSelect;
}

@end
