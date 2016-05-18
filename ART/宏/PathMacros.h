//
//  PathMacros.h
//  ART
//
//  Created by huangtie on 16/5/17.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#ifndef PathMacros_h
#define PathMacros_h

#import "NSFileManager+ART.h"

#define FILE_PATH_FOLDER(name) [NSFileManager art_path_folder:name]

#define FILE_PATH(m,n) [FILE_PATH_FOLDER(m) stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",n]]

#define FOLDER_NAME_DB @"DB"
#define FOLDER_NAME_PIC @"PICTURE"

//数据库文件路径
#define FILE_PATH_DB(N) FILE_PATH(FOLDER_NAME_DB,N)

//本地下载图片文件路径
#define FILE_PATH_PIC(N) FILE_PATH(FOLDER_NAME_PIC,N)

//删除路径下文件
#define FILE_DELETE(P) [NSFileManager art_path_delete:P]

//图片下载后的命名
#define FILE_NAME_IMAGE(n) [NSString stringWithFormat:@"FM%@%@.jpg",n,@((NSInteger)([[NSDate date] timeIntervalSince1970] * 1000))]


#endif /* PathMacros_h */
