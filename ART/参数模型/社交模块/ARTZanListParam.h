//
//  ARTZanListParam.h
//  ART
//
//  Created by huangtie on 16/5/6.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBaseParam.h"

@interface ARTZanListParam : ARTBaseParam

//说说ID
@property (nonatomic , copy) NSString *talkID;

//第几条
@property (nonatomic , copy) NSString *offset;

//一页几条
@property (nonatomic , copy) NSString *limit;

@end
