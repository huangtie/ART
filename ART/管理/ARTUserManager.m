//
//  ARTUserManager.m
//  ART
//
//  Created by huangtie on 16/5/3.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTUserManager.h"
#import "ARTLoginViewController.h"

#define FILE_NAME_ARCHIVE @"FILE_NAME_ARCHIVE"
@implementation ARTUserManager

+ (instancetype)sharedInstance
{
    static ARTUserManager *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[ARTUserManager alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        if([self loadUserData])
        {
            self.userinfo = [self loadUserData];
        }
    }
    return self;
}

- (void)setUserinfo:(ARTUserData *)userinfo
{
    _userinfo = userinfo;
    [self saveUserData:userinfo];
}

- (BOOL)isLogin
{
    return self.userinfo.c.length;
}

- (BOOL)isLogin:(ARTBaseViewController *)targe
        logined:(void (^)(ARTUserData *userInfo))logined
{
    if(self.userinfo.c.length)
    {
        if (logined)
        {
            logined(self.userinfo);
        }
        return YES;
    }
    else
    {
        if (targe)
        {
            ARTLoginViewController *loginVC = [[ARTLoginViewController alloc] init];
            loginVC.loginSuccessBlock = ^(ARTUserData * data)
            {
                if (logined)
                {
                    logined(data);
                }
            };
            [targe.navigationController pushViewController:loginVC animated:YES];
        }
        return NO;
    }
}

- (void)logout
{
    self.userinfo = nil;
    [[self class] removeFile:FILE_NAME_ARCHIVE];
}

- (void)saveUserData:(ARTUserData *)data
{
    [[self class] saveDataList:data fileName:FILE_NAME_ARCHIVE];
}

- (ARTUserData *)loadUserData
{
    return [[self class] loadDataList:FILE_NAME_ARCHIVE];
}

#pragma mark METHOD
#define FOLDER_NAME_CACHES @"FOLDER_NAME_CACHES"
+ (id)loadDataList:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0]stringByAppendingPathComponent:FOLDER_NAME_CACHES];
    NSFileManager *manager = [[NSFileManager alloc]init];
    if (![manager fileExistsAtPath:path])
    {
        NSError *error ;
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error)
        {
        }
        return nil;
    }
    
    NSString* fileDirectory = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.arc",fileName]];
    
    //解归档
    return [NSKeyedUnarchiver unarchiveObjectWithFile:fileDirectory];
}

+ (void)saveDataList:(id)object fileName:(NSString *)fileName
{
    //归档对象
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0]stringByAppendingPathComponent:FOLDER_NAME_CACHES];
    NSFileManager *manager = [[NSFileManager alloc]init];
    if (![manager fileExistsAtPath:path])
    {
        NSError *error ;
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error)
        {
            
        }
    }
    
    NSString* fileDirectory = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.arc",fileName]];
    
    BOOL success = [NSKeyedArchiver archiveRootObject:object toFile:fileDirectory];
    
    if (success)
    {
    }
    
}

+ (BOOL)removeFile:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0]stringByAppendingPathComponent:FOLDER_NAME_CACHES];
    NSFileManager *manager = [[NSFileManager alloc]init];
    if (![manager fileExistsAtPath:path])
    {
        return YES;
    }
    
    NSString* fileDirectory = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.arc",fileName]];
    
    BOOL success = [manager removeItemAtPath:fileDirectory error:nil];
    
    if (success)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
