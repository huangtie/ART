//
//  ARTSendTalkParam.h
//  ART
//
//  Created by huangtie on 16/5/5.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBaseParam.h"

@interface ARTSendTalkParam : ARTBaseParam

//文字内容
@property (nonatomic , copy) NSString *talkText;

//是否所有人可见( 0 否 1 是)
@property (nonatomic , copy) NSString *talkAllLook;

//图片数组
@property (nonatomic , strong) NSMutableArray<NSData *> *talkImages;

@end
