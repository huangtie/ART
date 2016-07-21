//
//  EMVoiceMessageBody+ART.m
//  ART
//
//  Created by huangtie on 16/7/18.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "EMVoiceMessageBody+ART.h"

@implementation EMVoiceMessageBody (ART)

- (BOOL)art_isPlaying
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setArt_isPlaying:(BOOL)art_isPlaying
{
    objc_setAssociatedObject(self, @selector(art_isPlaying), @(art_isPlaying), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
