//
//  ARTPointView.m
//  ART
//
//  Created by huangtie on 16/5/25.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTPointView.h"

@implementation ARTPointView

+ (ARTPointView *)point:(CGFloat)point
{
    return [[ARTPointView alloc] initWithPoint:point];
}

- (instancetype)initWithPoint:(CGFloat)point
{
    self = [super init];
    if (self)
    {
        CGFloat padding = 0;
        CGSize pointSize = CGSizeMake(20, 20);
        self.size = CGSizeMake(pointSize.width * 5 + padding * 4, pointSize.height);
        
        //空心
        for (NSInteger i = 0; i < 5; i++)
        {
            UIImageView *xingEmpty = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"book_icon_xing"]];
            xingEmpty.size = pointSize;
            xingEmpty.left = i * (padding + pointSize.width);
            [self addSubview:xingEmpty];
        }
        
        //实心
        NSInteger ge = (NSInteger)point;
        CGFloat fen = point - (CGFloat)ge;
        for (NSInteger i = 0; i < ge; i++)
        {
            UIImageView *xingSolid = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"book_icon_xing_select"]];
            xingSolid.size = pointSize;
            xingSolid.left = i * (padding + pointSize.width);
            [self addSubview:xingSolid];
        }
        
        //半心
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(ge * (padding + pointSize.width), 0, pointSize.width * fen, pointSize.height)];
        back.clipsToBounds = YES;
        [self addSubview:back];
        UIImageView *fenView = [[UIImageView alloc] init];
        fenView.size = CGSizeMake(pointSize.width, pointSize.height);
        fenView.image = [UIImage imageNamed:@"book_icon_xing_select"];
        [back addSubview:fenView];
    }
    return self;
}

@end
