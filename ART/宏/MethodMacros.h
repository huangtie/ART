//
//  MethodMacros.h
//  ART
//
//  Created by huangtie on 16/5/13.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#ifndef MethodMacros_h
#define MethodMacros_h

typedef enum
{
    ART_TABINDEX_HOME = 0,           //首页
    ART_TABINDEX_BOOK ,              //图集
    ART_TABINDEX_LOCAL ,             //本地
    ART_TABINDEX_SOCIAL ,            //圈子
    ART_TABINDEX_AUCTION             //拍卖
}ART_TABINDEX;


//debug开关 是否打印日志
#ifdef DEBUG
#   define LotLog(fmt, ...) {NSLog((@"%s [Line %d]\n " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#else
#   define LotLog(...)
#endif

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define STRING_FORMAT_ADC(m) [NSString stringWithFormat:@"%@",m]

#define STRING_FORMAT(m,n) [NSString stringWithFormat:@"%@%@",m,n]


#define FIRST_KEY @"FIRSTINAPP"
#define FIRST_IN_APP(m) [[NSUserDefaults standardUserDefaults] setBool:m forKey:FIRST_KEY]
#define FIRST_OUT_APP [[NSUserDefaults standardUserDefaults] boolForKey:FIRST_KEY]

#endif /* MethodMacros_h */
