//
//  ARTLocalPageViewController.h
//  ART
//
//  Created by huangtie on 16/6/8.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBaseViewController.h"
#import "ARTBookLocalData.h"

@interface ARTLocalPageViewController : ARTBaseViewController

@property (nonatomic , strong) ARTBookPhotoData *photoData;

@property (nonatomic , assign) NSInteger pageNo;

@property (nonatomic , assign) NSInteger pageCount;

+ (ARTLocalPageViewController *)lunch:(ARTBookPhotoData *)photoData;

@end
