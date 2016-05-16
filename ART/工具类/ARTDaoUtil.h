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

- (instancetype)initWithDBName:(NSString *)dbName
                       dbForms:(NSArray <ARTForm *> *)dbForms;

//增、删、改
- (void)executeUpdate:(NSString *)SQL;

//查
- (void)executeQuery:(NSString *)SQL completion:(void (^)(FMResultSet *resultSet))completion;

@end
