//
//  ARTShareView.m
//  ART
//
//  Created by huangtie on 16/6/1.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTShareView.h"

@interface ARTShareView()

@property (nonatomic , strong) NSMutableArray <NSDictionary *> *shareItems;

@end

@implementation ARTShareView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.size = CGSizeMake(SCREEN_WIDTH, 120);
        self.backgroundColor = [UIColor whiteColor];
        self.shareItems = [NSMutableArray array];
        
        NSMutableDictionary *qq = [[NSMutableDictionary alloc] init];
        [qq setObject:@"share_icon_qqfriend" forKey:@"image"];
        [qq setObject:@(SHARE_DESTINATION_QQ) forKey:@"type"];
        [self.shareItems addObject:qq];
        
        NSMutableDictionary *qqzon = [[NSMutableDictionary alloc] init];
        [qqzon setObject:@"share_icon_qqzone" forKey:@"image"];
        [qqzon setObject:@(SHARE_DESTINATION_ZONE) forKey:@"type"];
        [self.shareItems addObject:qqzon];
        
        NSMutableDictionary *wechat = [[NSMutableDictionary alloc] init];
        [wechat setObject:@"share_icon_wechat" forKey:@"image"];
        [wechat setObject:@(SHARE_DESTINATION_WECHAT) forKey:@"type"];
        [self.shareItems addObject:wechat];
        
        NSMutableDictionary *wechatZone = [[NSMutableDictionary alloc] init];
        [wechatZone setObject:@"share_icon_wechatzone" forKey:@"image"];
        [wechatZone setObject:@(SHARE_DESTINATION_TIMELINE) forKey:@"type"];
        [self.shareItems addObject:wechatZone];
        
//        NSMutableDictionary *message = [[NSMutableDictionary alloc] init];
//        [message setObject:@"share_icon_message" forKey:@"image"];
//        [message setObject:@(SHARE_DESTINATION_EMAIL) forKey:@"type"];
//        [self.shareItems addObject:message];
        
        if (![QQApiInterface isQQInstalled])
        {
            [self.shareItems removeObject:qq];
            [self.shareItems removeObject:qqzon];
        }
        
        if (![WXApi isWXAppInstalled])
        {
            [self.shareItems removeObject:wechat];
            [self.shareItems removeObject:wechatZone];
        }
        
        UILabel *title = [[UILabel alloc] init];
        title.font = FONT_WITH_15;
        title.textColor = UICOLOR_ARGB(0xff333333);
        title.text = @"分享到：";
        [title sizeToFit];
        title.left = 40;
        title.centerY = self.height / 2;
        [self addSubview:title];
        
        UIView *contrl = [[UIView alloc] init];
        
        for (NSInteger i = 0; i < self.shareItems.count; i++)
        {
            NSDictionary *dic = self.shareItems[i];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[UIImage imageNamed:dic[@"image"]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(itemsClick:) forControlEvents:UIControlEventTouchUpInside];
            [button sizeToFit];
            button.left = i * button.width;
            contrl.height = button.height;
            contrl.width += button.width;
            [contrl addSubview:button];
        }
        contrl.left = title.right + 10;
        contrl.centerY = self.height / 2;
        [self addSubview:contrl];
    }
    return self;
}

- (void)itemsClick:(UIButton *)button
{
    NSInteger index = [button.superview.subviews indexOfObject:button];
    NSDictionary *dic = self.shareItems[index];
    
    SHARE_DESTINATION dest = (SHARE_DESTINATION)[dic[@"type"] integerValue];
    if (self.shareChoseeBlock)
    {
        self.shareChoseeBlock(dest);
    }
}

@end
