//
//  UIImage+ART.h
//  ART
//
//  Created by huangtie on 16/6/7.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ART)

- (UIImage *)safeResizableImageWithCapInsets:(UIEdgeInsets)capInsets;

- (UIImage *)safeResizableImageWithCapInsets:(UIEdgeInsets)capInsets
                                resizingMode:(UIImageResizingMode)resizingMode;

//获取纯色图片
+ (UIImage *)getPureImage:(UIColor *)color size:(CGSize)size;

+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *	@brief	缩略图
 *
 *	@param 	image 	原始图片大小
 *	@param 	asize 	CGSizeMake(200,200)
 *
 *	@return
 */
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

- (UIImage *)drawInImage:(UIImage *)parentImage placedAt:(CGRect)frame;

/**
	加半透明水印
	@param useImage 需要加水印的图片
	@param addImage1 水印
	@returns 加好水印的图片
 */
+ (UIImage *)addImage:(UIImage *)useImage addMsakImage:(UIImage *)maskImage maskRect:(CGRect)rect;
/**
 *	@brief	截屏 用于分享
 *
 *	@return
 */
+ (UIImage *)screenshot;


- (UIImage *)imageOfOrientationUp;

@end
