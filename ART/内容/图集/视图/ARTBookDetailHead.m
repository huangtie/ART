//
//  ARTBookDetailHead.m
//  ART
//
//  Created by huangtie on 16/5/30.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBookDetailHead.h"
#import "ARTPointView.h"
#import "ARTDownLoadManager.h"

@interface ARTBookDetailHead()

@property (nonatomic , strong) UIImageView *picture;

@property (nonatomic , strong) UILabel *titleLabel;

@property (nonatomic , strong) UILabel *priceLabel;

@property (nonatomic , strong) UILabel *typeLabel;

@property (nonatomic , strong) UILabel *statusLabel;

@property (nonatomic , strong) UILabel *pageLabel;

@property (nonatomic , strong) UILabel *vipLabel;

@property (nonatomic , strong) UILabel *downLabel;

@property (nonatomic , strong) UILabel *timeLabel;

@property (nonatomic , strong) UILabel *remarkLabel;

@property (nonatomic , strong) UIButton *showButton;

@property (nonatomic , strong) UIView *itemsContrl;

@property (nonatomic , strong) UIButton *buyButton;

@property (nonatomic , strong) UIButton *downButton;

@property (nonatomic , strong) UIButton *saveButton;

@property (nonatomic , strong) UIButton *readButton;

@property (nonatomic , strong) ARTPointView *starView;

@property (nonatomic , strong) ARTBookData *bookData;

@end

@implementation ARTBookDetailHead


#define labelWidth 475
#define labelHeight 20
#define spacsing 20
#define padding 15
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.picture = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 240, 320)];
        self.picture.clipsToBounds = YES;
        self.picture.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.picture];
        
        //图集名
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.picture.right + spacsing, self.picture.top + 5, labelWidth, labelHeight)];
        self.titleLabel.font = FONT_WITH_16;
        self.titleLabel.textColor = [UIColor blackColor];
        [self addSubview:self.titleLabel];
        
        //价格
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.picture.right + spacsing, self.titleLabel.bottom + padding, labelWidth, labelHeight)];
        [self addSubview:self.priceLabel];
        
        //分类
        self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.picture.right + spacsing, self.priceLabel.bottom + padding, labelWidth, labelHeight)];
        [self addSubview:self.typeLabel];
        
        //页数
        self.pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.picture.right + spacsing, self.typeLabel.bottom + padding, labelWidth, labelHeight)];
        [self addSubview:self.pageLabel];
        
        //状态
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.picture.right + spacsing, self.pageLabel.bottom + padding, labelWidth, labelHeight)];
        [self addSubview:self.statusLabel];
        
        //是否会员
        self.vipLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.picture.right + spacsing, self.statusLabel.bottom + padding, labelWidth, labelHeight)];
        [self addSubview:self.vipLabel];
        
        //下载量
        self.downLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.picture.right + spacsing, self.vipLabel.bottom + padding, labelWidth, labelHeight)];
        [self addSubview:self.downLabel];
        
        //上架时间
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.picture.right + spacsing, self.downLabel.bottom + padding, labelWidth, labelHeight)];
        [self addSubview:self.timeLabel];
        
        //简介
        self.remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.picture.right + spacsing, self.timeLabel.bottom + padding, labelWidth, 2 * labelHeight)];
        self.remarkLabel.numberOfLines = 0;
        [self addSubview:self.remarkLabel];
        
        self.showButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.showButton.size = CGSizeMake(90, 30);
        self.showButton.left = self.picture.right + spacsing + (labelWidth - self.showButton.width) / 2;
        self.showButton.top = self.remarkLabel.bottom + padding;
        [self.showButton setTitleColor:UICOLOR_ARGB(0xff999999) forState:UIControlStateNormal];
        [self.showButton setTitleColor:UICOLOR_ARGB(0xff999999) forState:UIControlStateSelected];
        [self.showButton addTarget:self action:@selector(showRemarkClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.showButton];
        NSMutableAttributedString * attStrA = [[NSMutableAttributedString alloc]initWithString:@"展开    "];
        [attStrA addAttribute:NSFontAttributeName value:FONT_WITH_15 range:NSMakeRange(0, attStrA.length)];
        [attStrA addAttribute:NSForegroundColorAttributeName value:UICOLOR_ARGB(0xff999999) range:NSMakeRange(0, attStrA.length)];
        NSTextAttachment * textAttachmentA = [[NSTextAttachment alloc] init];
        textAttachmentA.image = [UIImage imageNamed:@"detail_icon_arrowdown"];
        textAttachmentA.bounds=CGRectMake(0, 0, 10, 10);
        NSAttributedString * imageStrA = [NSAttributedString attributedStringWithAttachment:textAttachmentA];
        [attStrA replaceCharactersInRange:NSMakeRange(2, 2) withAttributedString:imageStrA];
        [self.showButton setAttributedTitle:attStrA forState:UIControlStateNormal];
        
        NSMutableAttributedString * attStrB = [[NSMutableAttributedString alloc]initWithString:@"收起    "];
        [attStrB addAttribute:NSFontAttributeName value:FONT_WITH_15 range:NSMakeRange(0, attStrB.length)];
        [attStrB addAttribute:NSForegroundColorAttributeName value:UICOLOR_ARGB(0xff999999) range:NSMakeRange(0, attStrB.length)];
        NSTextAttachment * textAttachmentB = [[NSTextAttachment alloc] init];
        textAttachmentB.image = [UIImage imageNamed:@"detail_icon_arrowup"];
        textAttachmentB.bounds=CGRectMake(0, 0, 10, 10);
        NSAttributedString * imageStrB = [NSAttributedString attributedStringWithAttachment:textAttachmentB];
        [attStrB replaceCharactersInRange:NSMakeRange(2, 2) withAttributedString:imageStrB];
        [self.showButton setAttributedTitle:attStrB forState:UIControlStateSelected];
        
        self.itemsContrl.top = self.showButton.bottom + spacsing;
        [self addSubview:self.itemsContrl];
        
        self.size = CGSizeMake(SCREEN_WIDTH, self.itemsContrl.bottom + spacsing);
        self.backgroundColor = UICOLOR_ARGB(0xfffafafa);
    }
    return self;
}

#define ITEMD_HEIGHT 35
#define buttonWidth 160
#define spasing (SCREEN_WIDTH - 30 - 4 * buttonWidth) / 3
- (UIView *)itemsContrl
{
    if (!_itemsContrl)
    {
        _itemsContrl = [[UIView alloc] init];
        _itemsContrl.size = CGSizeMake(SCREEN_WIDTH, ITEMD_HEIGHT);
        _itemsContrl.backgroundColor = [UIColor clearColor];
        
        self.buyButton = [self itemd:@"立即购买" frame:CGRectMake(15 , 0 , buttonWidth , ITEMD_HEIGHT)];
        [_itemsContrl addSubview:self.buyButton];
        
        self.downButton = [self itemd:@"立即下载" frame:CGRectMake(self.buyButton.right + spasing, 0 , buttonWidth , ITEMD_HEIGHT)];
        [_itemsContrl addSubview:self.downButton];
        
        self.saveButton = [self itemd:@"收藏" frame:CGRectMake(self.downButton.right + spasing, 0 , buttonWidth , ITEMD_HEIGHT)];
        [_itemsContrl addSubview:self.saveButton];
        
        self.readButton = [self itemd:@"开始阅读" frame:CGRectMake(self.saveButton.right + spasing, 0 , buttonWidth , ITEMD_HEIGHT)];
        [_itemsContrl addSubview:self.readButton];
    }
    return _itemsContrl;
}

#define DISA_COLOR UICOLOR_ARGB(0xff999999)
- (UIButton *)itemd:(NSString *)text frame:(CGRect)frame
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button clipRadius:2 borderWidth:1 borderColor:COLOR_YSYC_ORANGE];
    [button setTitleColor:COLOR_YSYC_ORANGE forState:UIControlStateNormal];
    [button setTitleColor:DISA_COLOR forState:UIControlStateDisabled];
    button.titleLabel.font = FONT_WITH_15;
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setTitle:text forState:UIControlStateNormal];
    [button addTarget:self action:@selector(itemsClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (NSAttributedString *)title:(NSString *)title text:(NSString *)text
{
    if (!title.length)
    {
        return nil;
    }
    
    NSMutableAttributedString * attStrA = [[NSMutableAttributedString alloc]initWithString:title];
    [attStrA addAttribute:NSFontAttributeName value:FONT_WITH_15 range:NSMakeRange(0, attStrA.length)];
    [attStrA addAttribute:NSForegroundColorAttributeName value:UICOLOR_ARGB(0xff666666) range:NSMakeRange(0, attStrA.length)];
    
    if (!text.length)
    {
        return attStrA;
    }
    
    NSMutableAttributedString * attStrB = [[NSMutableAttributedString alloc]initWithString:text];
    [attStrB addAttribute:NSFontAttributeName value:FONT_WITH_15 range:NSMakeRange(0, attStrB.length)];
    [attStrB addAttribute:NSForegroundColorAttributeName value:UICOLOR_ARGB(0xff333333) range:NSMakeRange(0, attStrB.length)];
    
    [attStrA appendAttributedString:attStrB];
    return attStrA;
}

#pragma mark LAYOUT
- (void)updateSubviews:(ARTBookData *)bookData
{
    self.bookData = bookData;
    
    //封面
    [self.picture setImageWithURL:[NSURL URLWithString:bookData.bookImage] placeholder:IMAGE_PLACEHOLDER_BOOK];
    
    //标题
    self.titleLabel.text = bookData.bookName;
    [self.titleLabel sizeToFit];
    self.titleLabel.height = labelHeight;
    
    //评分
    [self.starView removeFromSuperview];
    self.starView = [ARTPointView point:bookData.bookPoint.floatValue];
    self.starView.left = self.titleLabel.right + 10;
    self.starView.centerY = self.titleLabel.centerY;
    [self addSubview:self.starView];
    
    //价格
    self.priceLabel.attributedText = [self title:@"价格：" text:bookData.bookFree.boolValue ? STRING_FORMAT(STRING_FORMAT_ADC(bookData.bookPrice), @"金币") : @"免费"];
    
    //分类
    self.typeLabel.attributedText = [self title:@"分类：" text:bookData.bookGroupName];
    
    //页数
    self.pageLabel.attributedText = [self title:@"页数：" text:bookData.bookPage];
    
    //状态
    self.statusLabel.attributedText = [self title:@"完成状态：" text:STRING_FORMAT(bookData.bookState, @"%")];
    
    //是否会员
    self.vipLabel.attributedText = [self title:@"是否会员：" text:bookData.bookVIP.boolValue ? @"是" : @"否"];
    
    //下载次数
    self.downLabel.attributedText = [self title:@"下载次数：" text:bookData.bookDowns];
    
    //添加时间
    self.timeLabel.attributedText = [self title:@"添加时间：" text:[NSString timeString:bookData.bookTime dateFormat:@"yyyy-MM-dd HH:mm:ss"]];
    
    //简介
    NSAttributedString *remarkString = [self title:@"简介：" text:bookData.bookRemark];
    self.remarkLabel.attributedText = remarkString;
    CGFloat textHeight = [remarkString.string heightForFont:FONT_WITH_15 width:self.remarkLabel.width];
    if (textHeight > 2 * labelHeight)
    {
        self.showButton.hidden = NO;
        if (self.showButton.selected)
        {
            self.remarkLabel.height = textHeight;
        }
        else
        {
            self.remarkLabel.height = 2 * labelHeight;
        }
        
    }
    else
    {
        self.showButton.hidden = YES;
        self.remarkLabel.height = textHeight;
    }
    
    self.showButton.top = self.remarkLabel.bottom + padding;
    if (self.showButton.hidden)
    {
        if (textHeight < 2 * labelHeight)
        {
            self.itemsContrl.top = self.remarkLabel.top + 2 * labelHeight + padding;
        }
        else
        {
            self.itemsContrl.top = self.remarkLabel.bottom + padding;
        }
    }
    else
    {
        self.itemsContrl.top = self.showButton.bottom + padding;
    }

    self.height = self.itemsContrl.bottom + 2 * padding;
    
    //暂时不要收藏
    self.saveButton.hidden = YES;
    
    //是否能点击够买
    if (!bookData.bookFree.boolValue || bookData.isBuy.boolValue)
    {
        self.buyButton.hidden = YES;
    }
    else
    {
        self.buyButton.hidden = NO;
    }
    
    //是否能点击下载
    if (bookData.bookFree.boolValue && !bookData.isBuy.boolValue)
    {
        self.downButton.hidden = YES;
    }
    else
    {
        self.downButton.hidden = NO;
    }
    
    //是否能点击阅读
    if ([[ARTDownLoadManager sharedInstance] isDownLoad:bookData.bookID])
    {
        self.readButton.hidden = NO;
    }
    else
    {
        self.readButton.hidden = YES;
    }
    
    //重新设置按钮坐标
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.itemsContrl.subviews.count; i++)
    {
        UIButton *button = self.itemsContrl.subviews[i];
        if (!button.hidden)
        {
            button.left = index * (button.width + spasing);
            self.itemsContrl.width = button.right;
            index += 1;
        }
    }
    self.itemsContrl.centerX = self.width / 2;
}

#pragma mark ACTION
- (void)showRemarkClick
{
    self.showButton.selected = !self.showButton.selected;
    [self updateSubviews:self.bookData];
    
    [self.delegate detailHeadDidChangeFrame];
}

- (void)itemsClick:(UIButton *)button
{
    if (button == self.buyButton)
    {
        [self.delegate detailHeadDidTouchBuy];
    }
    if (button == self.downButton)
    {
        [self.delegate detailHeadDidTouchDown];
    }
    if (button == self.saveButton)
    {
        [self.delegate detailHeadDidTouchSave];
    }
    if (button == self.readButton)
    {
        [self.delegate detailHeadDidTouchRead];
    }
}

@end
