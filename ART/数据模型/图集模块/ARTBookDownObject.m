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

@property (nonatomic , assign) id<SDWebImageOperation> downOperation;

@property (nonatomic , strong) ARTBookLocalData *readData;

@property (nonatomic , strong) ARTBookData *bookData;

@property (nonatomic , strong) ARTDownLoadManager *downManager;

@end

@implementation ARTBookDownObject

- (instancetype)initWithReadData:(ARTBookLocalData *)readData
{
    self = [super init];
    if (self)
    {
        self.readData = readData;
        self.downManager = [[ARTDownLoadManager alloc] init];
        
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
        self.downManager = [[ARTDownLoadManager alloc] init];
        
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
            [[ARTDownLoadManager sharedInstance].downQueueList removeObject:weak];
            return ;
        }
        
        for (ARTBookPhotoData *photoData in data.photoList)
        {
            if (!photoData.downed)
            {
                weak.downOperation = [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:photoData.downURL] options:SDWebImageDownloaderLowPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                    
                    NSString *fileName = FILE_NAME_IMAGE(weak.readData.bookID);
                    [UIImageJPEGRepresentation(image, 1.0) writeToFile:FILE_PATH_PIC(fileName) options:NSAtomicWrite error:nil];
                    [weak.downManager inserSaveURL:photoData.ID url:fileName completion:^(FMDatabase *db) {
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
    [[ARTDownLoadManager sharedInstance].downQueueList removeObject:self];
    [self.downOperation cancel];
}

@end
