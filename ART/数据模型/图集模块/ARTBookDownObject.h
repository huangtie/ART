//
//  ARTBookDownObject.h
//  ART
//
//  Created by huangtie on 16/5/18.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARTBookLocalData.h"
#import "ARTBookData.h"

@interface ARTBookDownObject : NSObject

+ (ARTBookDownObject *)downLoadWithReadData:(ARTBookLocalData *)readData;

- (instancetype)initWithReadData:(ARTBookLocalData *)readData;

- (instancetype)initWithBookData:(ARTBookData *)bookData urls:(NSArray <NSString *> *)urls;

- (NSString *)downLoadingBookID;

- (void)downLoadPause;

@end
