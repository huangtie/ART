//
//  ARTDaoUtil.h
//  ART
//
//  Created by huangtie on 16/5/13.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

@interface ARTForm : NSObject

@property (nonatomic , copy) NSString *formName;

@property (nonatomic , copy) NSString *formSQL;

@end

@interface ARTDaoUtil : NSObject

@property (nonatomic , strong) FMDatabaseQueue *queue;

- (instancetype)initWithDBName:(NSString *)dbName
                       dbForms:(NSArray <ARTForm *> *)dbForms;

//增、删、改
- (void)executeUpdate:(NSString *)SQL completion:(void (^)())completion;

//增、删、改(异步)
- (void)executeUpdateAsync:(NSString *)SQL completion:(void (^)())completion;

//查
- (void)executeQuery:(NSString *)SQL completion:(void (^)(FMResultSet *resultSet))completion;

//查(异步)
- (void)executeQueryAsync:(NSString *)SQL completion:(void (^)(FMResultSet *resultSet))completion;

@end
