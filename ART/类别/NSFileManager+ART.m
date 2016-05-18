//
//  NSFileManager+ART.m
//  ART
//
//  Created by huangtie on 16/5/17.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "NSFileManager+ART.h"

@implementation NSFileManager (ART)

+ (NSString *)art_path_folder:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths firstObject] stringByAppendingPathComponent:name];
    NSFileManager *manager = [[NSFileManager alloc]init];
    if (![manager fileExistsAtPath:path])
    {
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

+ (void)art_path_delete:(NSString *)path
{
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

@end
