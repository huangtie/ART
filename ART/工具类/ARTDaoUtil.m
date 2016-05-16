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

@property (nonatomic , strong) FMDatabaseQueue *queue;

@end

@implementation ARTDaoUtil

- (instancetype)initWithDBName:(NSString *)dbName
                       dbForms:(NSArray <ARTForm *> *)dbForms
{
    self = [super init];
    if (self)
    {
        self.queue = [FMDatabaseQueue databaseQueueWithPath:[[self class] dbPath:dbName]];
        
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

- (void)executeUpdate:(NSString *)SQL
{
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:SQL];
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

+ (NSString *)dbPath:(NSString *)dbName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"DB"];
    NSFileManager *manager = [[NSFileManager alloc]init];
    if (![manager fileExistsAtPath:path])
    {
        NSError *error ;
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error)
        {
            
        }
    }
    NSString* fileDirectory = [path stringByAppendingPathComponent:dbName];
    return fileDirectory;
}

@end
