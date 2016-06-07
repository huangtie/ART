//
//  ColorMacros.h
//  ART
//
//  Created by huangtie on 16/5/18.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#ifndef ColorMacros_h
#define ColorMacros_h

#define RGBCOLOR(r,g,b,_alpha) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:_alpha]

/** 带颜色的文字 **/
#define UICOLOR_MAKE_TEXT_COLOR(color, text) [NSString stringWithFormat:@"<font color=\"%d,%d,%d,%d\">%@",_R_COLOR((unsigned int)color),_G_COLOR((unsigned int)color),_B_COLOR((unsigned int)color),_A_COLOR((unsigned int)color),text]

#define _R_COLOR(color) ((((unsigned int)color) >> 16)&0xFF)
#define _G_COLOR(color) ((((unsigned int)color) >> 8)&0xFF)
#define _B_COLOR(color) (((unsigned int)color) & 0xFF)
#define _A_COLOR(color) ((((unsigned int)color) >> 24)&0xFF)
/** 转换为16进制的颜色值 */
#define UICOLOR_MAKE_HEXCOLOR(r,g,b)  ((0xff<<24)|((unsigned int)(r*255)&0xff)<<16)|(((unsigned int)(g*255)&0xff)<<8)|(((unsigned int)(b*255)&0xff))////
#define UICOLOR_ARGB(color) [UIColor colorWithRed: _R_COLOR(color)/255.0 green: _G_COLOR(color)/255.0 blue: _B_COLOR(color)/ 255.0 alpha:_A_COLOR(color)/ 255.0]

//导航颜色（白色）
#define COLOR_DAOHANG_WHITE     [UIColor whiteColor]
//导航文字颜色（灰色）
#define COLOR_BARTINT_GRAY      UICOLOR_ARGB(0xff333333)

//界面默认背景颜色（白色）
#define COLOR_VIEWBG_WHITE      [UIColor whiteColor]
//橘黄色
#define COLOR_YSYC_ORANGE       UICOLOR_ARGB(0xfff4a629)
//浅灰色
#define COLOR_YSYC_GRAY         UICOLOR_ARGB(0xfffafafa)

#endif
