//
//  ARTBookCell.m
//  ART
//
//  Created by huangtie on 16/5/19.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBookCell.h"
#import <UIImageView+WebCache.h>

@interface ARTBookCell()

@property (strong, nonatomic) IBOutlet UIView *contrl;

@property (strong, nonatomic) IBOutlet UIImageView *picture;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UILabel *remarkLabel;

@end

@implementation ARTBookCell


- (instancetype)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"ARTBookCell" owner:self options:nil] lastObject];
    if (self)
    {
        
    }
    return self;
}



- (void)bindingWithData:(ARTBookData *)bookData
{
    //封面名
    self.picture.clipsToBounds = YES;
    [self.picture sd_setImageWithURL:[NSURL URLWithString:bookData.bookImage] placeholderImage:[UIImage imageNamed:@"book_bg_placeholder"]];
    
    //图集名
    self.titleLabel.text = bookData.bookName;
    
    //价格
    if (bookData.bookPrice.integerValue == 0)
    {
        self.priceLabel.text = @"价格：免费";
    }
    else
    {
        self.priceLabel.text = STRING_FORMAT(@"价格：",STRING_FORMAT(bookData.bookPrice,@"金币"));
    }
    
    //藏家
    self.authorLabel.text = STRING_FORMAT(@"藏家：",bookData.author.authorName);
    
    //简介
    NSString *string = bookData.bookRemark.length ? STRING_FORMAT(@"简介：",bookData.bookRemark) : @"简介：暂无简介...";
    CGSize size = [string sizeForFont:self.remarkLabel.font size:CGSizeMake(self.remarkLabel.width, 100) mode:NSLineBreakByWordWrapping];
    if (size.height > 60)
    {
        self.remarkLabel.height = 60;
    }
    else
    {
        self.remarkLabel.height = size.height;
    }
    self.remarkLabel.text = string;
}


@end
