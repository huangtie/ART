//
//  MethodMacros.h
//  ART
//
//  Created by huangtie on 16/5/13.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#ifndef MethodMacros_h
#define MethodMacros_h

//debug开关 是否打印日志
#ifdef DEBUG
#   define LotLog(fmt, ...) {NSLog((@"%s [Line %d]\n " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#else
#   define LotLog(...)
#endif

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#endif /* MethodMacros_h */
