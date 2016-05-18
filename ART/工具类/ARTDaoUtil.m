//
//  ARTDaoUtil.m
//  ART
//
//  Created by huangtie on 16/5/13.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTDaoUtil.h"

@implementation ARTForm

@end

@interface ARTDaoUtil()

@end

@implementation ARTDaoUtil

- (instancetype)initWithDBName:(NSString *)dbName
                       dbForms:(NSArray <ARTForm *> *)dbForms
{
    self = [super init];
    if (self)
    {
        self.queue = [FMDatabaseQueue databaseQueueWithPath:FILE_PATH_DB(dbName)];
        
        [self.queue inDatabase:^(FMDatabase *db) {
            for (ARTForm *form in dbForms)
            {
                if (![db tableExists:form.formName])
                {
                    [db executeUpdate:form.formSQL];
                }
            }
        }];
    }
    return self;
}

- (void)executeUpdate:(NSString *)SQL completion:(void (^)())completion
{
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:SQL];
        if (completion)
        {
            completion();
        }
    }];
}

- (void)executeUpdateAsync:(NSString *)SQL completion:(void (^)())completion
{
    [self.queue inDatabase:^(FMDatabase *db) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [db executeUpdate:SQL];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion)
                {
                    completion();
                }
            });
        });
    }];
}

- (void)executeQuery:(NSString *)SQL completion:(void (^)(FMResultSet *resultSet))completion
{
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:SQL];
        if (completion)
        {
            completion(set);
        }
    }];
}

- (void)executeQueryAsync:(NSString *)SQL completion:(void (^)(FMResultSet *resultSet))completion
{
    [self.queue inDatabase:^(FMDatabase *db) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            FMResultSet *set = [db executeQuery:SQL];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion)
                {
                    completion(set);
                }
            });
        });
    }];
}


@end
