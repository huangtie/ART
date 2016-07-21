//
//  ImageMacros.h
//  ART
//
//  Created by huangtie on 16/5/27.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#ifndef ImageMacros_h
#define ImageMacros_h

#define IMAGE_EMPTY_ONE [UIImage imageNamed:@"emoji_icon_1"]
#define IMAGE_EMPTY_TWO [UIImage imageNamed:@"emoji_icon_5"]

#define IMAGE_PLACEHOLDER_BOOK [UIImage imageNamed:@"book_bg_placeholder"]
#define IMAGE_PLACEHOLDER_MEMBERTWO [UIImage imageNamed:@"user_icon_2"]
#define IMAGE_PLACEHOLDER_MEMBER(m) [UIImage imageNamed:IMAGE_DEFULT_MEMBERS[m % IMAGE_DEFULT_MEMBERS.count]]
#define IMAGE_DEFULT_MEMBERS @[@"user_icon_7",@"user_icon_8",@"user_icon_9",@"user_icon_10",@"user_icon_11"]

#endif
