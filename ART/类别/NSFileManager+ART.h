//
//  NSFileManager+ART.h
//  ART
//
//  Created by huangtie on 16/5/17.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (ART)

+ (NSString *)art_path_folder:(NSString *)name;

+ (void)art_path_delete:(NSString *)path;

@end
