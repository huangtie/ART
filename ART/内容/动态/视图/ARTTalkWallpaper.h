//
//  ARTTalkWallpaper.h
//  ART
//
//  Created by huangtie on 16/7/7.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ARTUserInfo;

typedef enum
{
    WALL_LOAD_STAUTS_CUSTOM = 0,           //闲置
    WALL_LOAD_STAUTS_LOADING ,             //加载中
}WALL_LOAD_STAUTS;


typedef void(^ARTTalkRefreshBlock)();
@interface ARTTalkWallpaper : UIView

@property (nonatomic , strong) UIImageView *loadImageView;

@property (nonatomic , copy) ARTTalkRefreshBlock refreshBlock;

- (void)upDateData:(ARTUserInfo *)userInfo;

- (void)upDateScale:(CGFloat)offsetY;

- (void)beginAnimotion;

- (void)endLoad;
@end
