//
//  ARTBookGroupCell.m
//  ART
//
//  Created by huangtie on 16/5/19.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBookGroupCell.h"

@interface ARTBookGroupCell()

@property (nonatomic , strong) ARTGroupData *groupData;

@property (nonatomic , strong) UIButton *button;

@end

@implementation ARTBookGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.size = CGSizeMake(GROUP_CELL_WIDTH, GROUP_CELL_HEIGHT);

        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        self.button.titleLabel.font = FONT_WITH_15;
        [self.button setBackgroundImage:[UIImage imageNamed:@"book_item_gray"] forState:UIControlStateNormal];
        [self.button setBackgroundImage:[UIImage imageNamed:@"book_item_yellow"] forState:UIControlStateSelected];
        [self.button addTarget:self action:@selector(buttonTouchAction) forControlEvents:UIControlEventTouchUpInside];
        self.button.size = CGSizeMake(145, 30);
        self.button.right = self.width;
        
        [self.contentView addSubview:self.button];
    }
    return self;
}

- (void)bindingWithData:(ARTGroupData *)groupData isSelect:(BOOL)isSelect
{
    self.groupData = groupData;
    [self.button setTitle:groupData.groupName forState:UIControlStateNormal];
    
    self.button.selected = isSelect;
}

- (void)buttonTouchAction
{
    [self.delegate bookGroupCellDidSelect:self.groupData];
}

@end
