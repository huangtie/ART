//
//  ARTBookLocalData.m
//  ART
//
//  Created by huangtie on 16/5/16.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBookLocalData.h"
#import <SDWebImageOperation.h>
#import <SDWebImageDownloader.h>
#import "ARTDaoUtil.h"

@implementation ARTBookPhotoData

@end

@interface ARTBookLocalData()

@end

@implementation ARTBookLocalData

- (NSMutableArray *)photoList
{
    if (!_photoList)
    {
        _photoList = [NSMutableArray array];
    }
    return _photoList;
}

@end
