//
//  ARTDownLoadManager.h
//  ART
//
//  Created by huangtie on 16/5/16.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARTBookData.h"
#import <FMDB.h>
#import "ARTBookLocalData.h"

@interface ARTDownLoadManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic , strong) NSMutableArray *downQueueList;

@property (nonatomic , strong) FMDatabase *db;

- (void)inserBook:(ARTBookData *)bookModel
       completion:(void (^)())completion;

- (void)inserDownURL:(NSString *)bookID
                urls:(NSArray <NSString *> *)photos
          completion:(void (^)())completion;

- (void)inserSaveURL:(NSString *)photoID
                 url:(NSString *)urlString
          completion:(void (^)())completion;

- (void)deleteBook:(NSString *)bookID
        completion:(void (^)())completion;

- (void)getBookInformation:(NSString *)bookID
                completion:(void (^)(ARTBookLocalData *data))completion;

- (void)getALLBook:(void (^)(NSMutableArray <ARTBookLocalData *> *dataList))completion;

- (BOOL)isDownLoad:(NSString *)bookID;
@end
