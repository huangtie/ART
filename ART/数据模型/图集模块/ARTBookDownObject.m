//
//  ARTBookDownObject.m
//  ART
//
//  Created by huangtie on 16/5/18.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTBookDownObject.h"
#import <SDWebImageOperation.h>
#import <SDWebImageDownloader.h>
#import "ARTDownLoadManager.h"

@interface ARTBookDownObject()

@property (nonatomic , strong) id<SDWebImageOperation> downOperation;

@property (nonatomic , strong) ARTBookLocalData *readData;

@property (nonatomic , strong) ARTBookData *bookData;

@property (nonatomic , strong) ARTDownLoadManager *downManager;

@end

@implementation ARTBookDownObject

+ (ARTBookDownObject *)downLoadWithReadData:(ARTBookLocalData *)readData
{
    return [[ARTBookDownObject alloc] initWithReadData:readData];
}

- (instancetype)initWithReadData:(ARTBookLocalData *)readData
{
    self = [super init];
    if (self)
    {
        self.readData = readData;
        [[ARTDownLoadManager sharedInstance].downQueueList addObject:self];
        [self downLoadBegan];
    }
    return self;
}

- (instancetype)initWithBookData:(ARTBookData *)bookData urls:(NSArray <NSString *> *)urls;
{
    self = [super init];
    if (self)
    {
        self.bookData = bookData;
        [self.downManager deleteBook:bookData.bookID completion:^{
            [self.downManager inserBook:bookData completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DOWNLOAD_STATUSCHANGE object:bookData.bookID];
                
                [self.downManager inserDownURL:bookData.bookID urls:urls completion:^{
                    [self.downManager getBookInformation:bookData.bookID completion:^(ARTBookLocalData *data) {
                        self.readData = data;
                        [[ARTDownLoadManager sharedInstance].downQueueList addObject:self];
                        [self downLoadBegan];
                    }];
                }];
            }];
        }];
    }
    return self;
}

- (void)dealloc
{
    
}

- (void)downLoadBegan
{
    WS(weak)
    [self.downManager getBookInformation:self.readData.bookID completion:^(ARTBookLocalData *data) {
        weak.readData = data;
        if (data.bookAllCount == data.bookFinishCount && data.bookAllCount != 0)
        {
            [weak downLoadPause];
            return ;
        }
        
        for (ARTBookPhotoData *photoData in data.photoList)
        {
            if (!photoData.downed)
            {
                weak.downOperation = [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:photoData.downURL] options:SDWebImageDownloaderLowPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                    if(!weak) return;
                    NSString *fileName = [NSString stringWithFormat:@"FM%@%@%@.jpg",weak.readData.bookID,photoData.ID,@((NSInteger)[[NSDate date] timeIntervalSince1970])];
                    NSString *filePath = FILE_PATH_PIC(fileName);
                    BOOL isDone = [UIImageJPEGRepresentation(image, 1.0) writeToFile:filePath options:NSAtomicWrite error:nil];
                    if (!isDone)
                    {
                        [weak downLoadBegan];
                        return;
                    }
                    [weak.downManager inserSaveURL:photoData.ID url:fileName completion:^() {
                        if(!weak) return;
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DOWNLOAD_STATUSCHANGE object:weak.readData.bookID];
                        [weak downLoadBegan];
                    }];
                }];
                return;
            }
        }
    }];
}

- (NSString *)downLoadingBookID
{
    return self.readData.bookID;
}

- (void)downLoadPause
{
    if(self.downOperation)
    {
        [self.downOperation cancel];
    }
    [[ARTDownLoadManager sharedInstance].downQueueList removeObject:self];
}

- (ARTDownLoadManager *)downManager
{
    if (!_downManager)
    {
        _downManager = [[ARTDownLoadManager alloc] init];
    }
    return _downManager;
}

@end
