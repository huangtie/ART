//
//  ARTDownLoadManager.m
//  ART
//
//  Created by huangtie on 16/5/16.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTDownLoadManager.h"
#import <SDWebImageOperation.h>
#import <SDWebImageDownloader.h>

@interface ARTDownLoadManager()

@property (nonatomic , strong) FMDatabaseQueue *queue;

@end

@implementation ARTDownLoadManager

+ (instancetype)sharedInstance
{
    static ARTDownLoadManager *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[ARTDownLoadManager alloc] init];
        instance.downQueueList = [NSMutableArray array];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self openDB];
    }
    return self;
}

- (void)openDB
{
    self.queue = [FMDatabaseQueue databaseQueueWithPath:FILE_PATH_DB(@"BookDB.sqlite")];
    [self crateTable];
}

- (void)closeDB
{
    
}

- (void)crateTable
{
    [self.queue inDatabase:^(FMDatabase *db) {
        if(![db tableExists:@"books"])
        {
            [db open];
            NSString *bookTB = @"CREATE TABLE books (id integer NOT NULL PRIMARY KEY AUTOINCREMENT,faceurl text,bookID integer,title text)";
            [db executeUpdate:bookTB];
            [db close];
        }
        
        if(![db tableExists:@"photos"])
        {
            [db open];
            NSString *photosTB = @"CREATE TABLE photos (id integer NOT NULL PRIMARY KEY AUTOINCREMENT,bookID integer,downURL text,saveURL text,downed boolean DEFAULT 0)";
            [db executeUpdate:photosTB];
            [db close];
        }
        self.db = db;
    }];
}

- (void)dealloc
{
    [self.db close];
}

- (void)inserBook:(ARTBookData *)bookModel
       completion:(void (^)())completion
{
    [self deleteBook:bookModel.bookID completion:^() {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:bookModel.bookImage] options:SDWebImageDownloaderLowPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *filename = FILE_NAME_IMAGE(bookModel.bookID);
                [UIImageJPEGRepresentation(image, 1.0) writeToFile:FILE_PATH_PIC(filename) options:NSAtomicWrite error:nil];
                NSString *sql = @"insert into books (bookID,title,faceurl) values (?,?,?)";
                [self.db open];
                [self.db executeUpdate:sql, bookModel.bookID,bookModel.bookName,filename];
                [self.db close];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion)
                    {
                        completion();
                    }
                });
            });
        }];
    }];
}

- (void)inserDownURL:(NSString *)bookID
                urls:(NSArray <NSString *> *)photos
          completion:(void (^)())completion;
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSString *urlString in photos)
        {
            [self.db open];
            [self.db executeUpdate:@"insert into photos (bookID,downURL) values (?,?)", bookID,urlString];
            [self.db close];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion)
            {
                completion();
            }
        });
    });
}

- (void)inserSaveURL:(NSString *)photoID
                 url:(NSString *)urlString
          completion:(void (^)())completion
{
    NSString *sql = @"update photos SET saveURL=?,downed=1 where id=?";
    [self.db open];
    [self.db executeUpdate:sql,urlString,photoID];
    [self.db close];
    if (completion)
    {
        completion();
    }
}

- (void)deleteBook:(NSString *)bookID
        completion:(void (^)())completion;
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //删除Book表
        [self.db open];
        FMResultSet *deboSet = [self.db executeQuery:@"select faceurl from books where bookID=?",bookID];
        while (deboSet.next)
        {
            FILE_DELETE(FILE_PATH_PIC([deboSet stringForColumn:@"faceurl"]));
        }
        [deboSet close];
        [self.db executeUpdate:@"delete from books where bookID = ?",bookID];
        //删除photo表
        FMResultSet *depoSet = [self.db executeQuery:@"select saveURL from photos where bookID=?",bookID];
        while (depoSet.next)
        {
            FILE_DELETE(FILE_PATH_PIC([depoSet stringForColumn:@"saveURL"]));
        }
        [depoSet close];
        [self.db executeUpdate:@"delete from photos where bookID = ?",bookID];
        [self.db close];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion)
            {
                completion();
            }
        });
    });
}

- (void)getBookInformation:(NSString *)bookID completion:(void (^)(ARTBookLocalData *data))completion
{
    ARTBookLocalData *readData = [[ARTBookLocalData alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.db open];
        FMResultSet *infoSet = [self.db executeQuery:@"select * from books where bookID=?",bookID];
        while ([infoSet next])
        {
            readData.bookID = [infoSet stringForColumn:@"bookID"];
            readData.name = [infoSet stringForColumn:@"title"];
            readData.face = [infoSet stringForColumn:@"faceurl"];
        }
        [infoSet close];
        
        FMResultSet *imgSet = [self.db executeQuery:@"select * from photos where bookID=?",bookID];
        while ([imgSet next])
        {
            ARTBookPhotoData *photo = [[ARTBookPhotoData alloc] init];
            photo.ID = [imgSet stringForColumn:@"id"];
            photo.downURL = [imgSet stringForColumn:@"downURL"];
            photo.saveURL = [imgSet stringForColumn:@"saveURL"];
            photo.downed = [imgSet intForColumn:@"downed"];
            [readData.photoList addObject:photo];
        }
        [imgSet close];
        
        //查询图片总数
        readData.bookAllCount = [self.db intForQuery:@"select count(*) from photos where bookID=?",bookID];
        readData.bookFinishCount = [self.db intForQuery:@"select count(*) from photos where bookID=? and downed=1",bookID];
        [self.db close];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion)
            {
                completion(readData);
            }
        });
    });
}

- (void)getALLBook:(void (^)(NSMutableArray <ARTBookLocalData *> *dataList))completion
{
    NSMutableArray *datas = [[NSMutableArray alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.db open];
        FMResultSet *infoSet = [self.db executeQuery:@"select * from books"];
        while ([infoSet next])
        {
            NSString *bookID = [infoSet stringForColumn:@"bookID"];
            ARTBookLocalData *readData = [[ARTBookLocalData alloc] init];
            readData.bookID = bookID;
            readData.name = [infoSet stringForColumn:@"title"];
            readData.face = [infoSet stringForColumn:@"faceurl"];
            readData.bookAllCount = [self.db intForQuery:@"select count(*) from photos where bookID=?",bookID];
            readData.bookFinishCount = [self.db intForQuery:@"select count(*) from photos where bookID=? and downed=1",bookID];
            [datas addObject:readData];
        }
        [infoSet close];
        [self.db close];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion)
            {
                completion(datas);
            }
        });
    });
}

- (BOOL)isDownLoad:(NSString *)bookID
{
    [self.db open];
    NSInteger allCount = [self.db intForQuery:@"select count(*) from photos where bookID=?",bookID];
    NSInteger fishCount = [self.db intForQuery:@"select count(*) from photos where bookID=? and downed=1",bookID];
    [self.db close];
    if (allCount == 0 || allCount != fishCount)
    {
        return NO;
    }
    return YES;
}



@end
