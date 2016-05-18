//
//  ARTBookLocalData.h
//  ART
//
//  Created by huangtie on 16/5/16.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ARTBookPhotoData : NSObject

@property (nonatomic , copy) NSString *ID;

@property (nonatomic , copy) NSString *downURL;

@property (nonatomic , copy) NSString *saveURL;

@property (nonatomic , assign) NSInteger downed;

@end

@interface ARTBookLocalData : NSObject

@property (nonatomic , copy) NSString *bookID;

@property (nonatomic , copy) NSString *name;

@property (nonatomic , copy) NSString *face;

@property (nonatomic , assign) NSInteger bookAllCount;

@property (nonatomic , assign) NSInteger bookFinishCount;

@property (nonatomic , strong) NSMutableArray <ARTBookPhotoData *> *photoList;

@end
