//
//  ARTBookLocalData.m
//  ART
//
//  Created by huangtie on 16/5/16.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBookLocalData.h"

@implementation ARTLocalPicture

@end

@implementation ARTBookLocalData

- (CGFloat)downStatus
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"local NOT nil"];
    NSArray * downeds = [_pictures filteredArrayUsingPredicate:predicate];
    return (CGFloat)downeds.count / (CGFloat)_pictures.count;
}

@end
