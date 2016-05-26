//
//  ARTBookCell.m
//  ART
//
//  Created by huangtie on 16/5/19.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBookCell.h"
#import <UIImageView+WebCache.h>
#import "ARTPointView.h"

@interface ARTBookCell()

@property (strong, nonatomic) IBOutlet UIView *contrl;

@property (strong, nonatomic) IBOutlet UIImageView *picture;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UILabel *remarkLabel;

@property (nonatomic , strong) ARTPointView *pointView;

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
    //封面
    WS(weak)
    [self.picture.layer setImageWithURL:[NSURL URLWithString:bookData.bookImage]
                         placeholder:PLACEHOLDER_IMAGE_BOOK
                             options:YYWebImageOptionAvoidSetImage
                          completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                              if (!weak.picture) return;
                              if (image && stage == YYWebImageStageFinished)
                              {
                                  weak.picture.contentMode = UIViewContentModeScaleAspectFill;
                                  weak.picture.layer.contentsRect = CGRectMake(0, 0, 1, 1);
                                  weak.picture.clipsToBounds = YES;
                                  weak.picture.image = image;
                                  if (from != YYWebImageFromMemoryCacheFast)
                                  {
                                      CATransition *transition = [CATransition animation];
                                      transition.duration = 0.15;
                                      transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                                      transition.type = kCATransitionFade;
                                      [weak.picture.layer addAnimation:transition forKey:@"contents"];
                                  }
                              }
                          }];
    
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
    [self.authorLabel sizeToFit];
    
    //评分
    [self.pointView removeFromSuperview];
    self.pointView = [ARTPointView point:bookData.bookPoint.floatValue];
    if (self.authorLabel.right > self.contrl.width - 10 - self.pointView.width)
    {
        self.authorLabel.width = self.contrl.width - self.pointView.left - 10 - self.pointView.width;
    }
    self.pointView.left = self.authorLabel.right + 10;
    self.pointView.centerY = self.authorLabel.centerY;
    [self.contrl addSubview:self.pointView];
    
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
