//
//  ARTCityParam.h
//  ART
//
//  Created by huangtie on 16/6/20.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBaseParam.h"

@interface ARTCityParam : ARTBaseParam

//0(或不传) : 省  1: 市  2: 区  -1: 所有(不建议)
@property (nonatomic , copy) NSString *type;

//上一级ID
@property (nonatomic , copy) NSString *code;

@end
