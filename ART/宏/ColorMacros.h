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

#define UICOLOR_ARGB(color) [UIColor colorWithRed: _R_COLOR(color)/255.0 green: _G_COLOR(color)/255.0 blue: _B_COLOR(color)/ 255.0 alpha:_A_COLOR(color)/ 255.0]




#endif
