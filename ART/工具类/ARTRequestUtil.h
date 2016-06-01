//
//  ARTRequestUtil.h
//  ART
//
//  Created by huangtie on 16/5/13.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>
#import "NetMacros.h"
#import "ARTCustomParam.h"
#import "ARTLoginParam.h"
#import "ARTRegisterParam.h"
#import "ARTForgetParam.h"
#import "ARTUpsetParam.h"
#import "ARTBookListParam.h"
#import "ARTCommentSendParam.h"
#import "ARTCommentListParam.h"
#import "ARTSendTalkParam.h"
#import "ARTSendTalkComParam.h"
#import "ARTTalkListParam.h"

#import "ARTUserData.h"
#import "ARTBookData.h"
#import "ARTBookDownData.h"
#import "ARTCommentData.h"
#import "ARTPurchasesData.h"
#import "ARTPurchasesLogData.h"
#import "ARTTalkData.h"
#import "ARTGroupData.h"
#import "ARTAuthorData.h"

typedef NS_ENUM(NSInteger, NET_ERROR)
{
    NET_ERROR_0000 = 0000,       // 网络出错,请检查网络设置
    NET_ERROR_9997 = 9997,       // 操作失败
    NET_ERROR_9998,              // 参数错误
    NET_ERROR_9999,              // 内部错误
    NET_ERROR_10000,             // 请求成功
    NET_ERROR_10001,             // 用户名不存在
    NET_ERROR_10002,             // 密码错误
    NET_ERROR_10003,             // 用户名重复
    NET_ERROR_10004,             // 该账号未绑定手机号或者手机号错误,请联系客服
    NET_ERROR_10005,             // 评论失败
    NET_ERROR_10006,             // 余额不足
    NET_ERROR_10007,             // 登录标识出错
    NET_ERROR_10008,             // 已购买过
    NET_ERROR_10009,             // 免费图集无需购买
    NET_ERROR_10010,             // 图集尚未购买
    NET_ERROR_10011,             // 该账号已在超过三台设备下载
    NET_ERROR_10012,             // 重复关注
    NET_ERROR_10013,             // 发表失败
    NET_ERROR_10014,             // 删除失败
    NET_ERROR_10015,             // 点赞失败
    NET_ERROR_10016,             // 出价失败
    NET_ERROR_10017,             // 成交失败
};

@interface ErrorItemd : NSObject

@property (nonatomic , assign) NET_ERROR code;

@property (nonatomic , copy) NSString *errMsg;

@end

@interface ARTRequestUtil : NSObject

#pragma mark 2.1 登录
+ (NSURLSessionDataTask *)requestLogin:(ARTLoginParam *)param
                            completion:(void (^)(NSURLSessionDataTask *task, ARTUserData *data))completion
                               failure:(void (^)(ErrorItemd *error))failure;

#pragma mark 2.2 注册
+ (NSURLSessionDataTask *)requestRegister:(ARTRegisterParam *)param
                               completion:(void (^)(NSURLSessionDataTask *task, ARTUserData *data))completion
                                  failure:(void (^)(ErrorItemd *error))failure;

#pragma mark 2.3 忘记密码
+ (NSURLSessionDataTask *)requestFinepassword:(ARTForgetParam *)param
                                   completion:(void (^)(NSURLSessionDataTask *task))completion
                                      failure:(void (^)(ErrorItemd *error))failure;

#pragma mark 2.4 获取基本资料
+ (NSURLSessionDataTask *)requestUserinfo:(NSString *)userID
                               completion:(void (^)(NSURLSessionDataTask *task, ARTUserData *data))completion
                                  failure:(void (^)(ErrorItemd *error))failure;

#pragma mark 2.5 修改资料
+ (NSURLSessionDataTask *)requestUpdateInfo:(ARTUpsetParam *)param
                                 completion:(void (^)(NSURLSessionDataTask *task))completion
                                    failure:(void (^)(ErrorItemd *error))failure;

#pragma mark 2.6 上传头像
+ (NSURLSessionDataTask *)requestUploadFace:(UIImage *)faceImage
                                 completion:(void (^)(NSURLSessionDataTask *task, NSString *userImage))completion
                                    failure:(void (^)(ErrorItemd *error))failure;


#pragma mark 3.1 获取图集列表
+ (NSURLSessionDataTask *)requestBookList:(ARTBookListParam *)param
                               completion:(void (^)(NSURLSessionDataTask *task, NSArray<ARTBookData *> *datas))completion
                                  failure:(void (^)(ErrorItemd *error))failure;

#pragma mark 3.2 获取图集详情
+ (NSURLSessionDataTask *)requestBookDetail:(NSString *)bookID
                                 completion:(void (^)(NSURLSessionDataTask *task, ARTBookData *data))completion
                                    failure:(void (^)(ErrorItemd *error))failure;

#pragma mark 3.3 获取图集下载资源
+ (NSURLSessionDataTask *)requestBookDowns:(NSString *)bookID
                                completion:(void (^)(NSURLSessionDataTask *task, NSArray<ARTBookDownData *> *datas))completion
                                   failure:(void (^)(ErrorItemd *error))failure;


#pragma mark 4.1 发表评论
+ (NSURLSessionDataTask *)requestSendComment:(ARTCommentSendParam *)param
                                  completion:(void (^)(NSURLSessionDataTask *task))completion
                                     failure:(void (^)(ErrorItemd *error))failure;

#pragma mark 4.2 获取评论列表
+ (NSURLSessionDataTask *)requestCommentList:(ARTCommentListParam *)param
                                  completion:(void (^)(NSURLSessionDataTask *task, NSArray<ARTCommentData *> *datas))completion
                                     failure:(void (^)(ErrorItemd *error))failure;


#pragma mark 5.1 获取充值列表
+ (NSURLSessionDataTask *)requestPurchasesList:(void (^)(NSURLSessionDataTask *task, NSArray<ARTPurchasesData *> *datas))completion
                                       failure:(void (^)(ErrorItemd *error))failure;

#pragma mark 5.2 购买图集
+ (NSURLSessionDataTask *)requestBuyBook:(NSString *)bookID
                              completion:(void (^)(NSURLSessionDataTask *task))completion
                                 failure:(void (^)(ErrorItemd *error))failure;

#pragma mark 5.3 获取已购买的图集
+ (NSURLSessionDataTask *)requestBuyedList:(ARTCustomParam *)param
                                completion:(void (^)(NSURLSessionDataTask *task, NSArray<ARTBookData *> *datas))completion
                                   failure:(void (^)(ErrorItemd *error))failure;

#pragma mark 5.4 获取充值和消费记录
+ (NSURLSessionDataTask *)requestPurchaLog:(ARTCustomParam *)param
                                completion:(void (^)(NSURLSessionDataTask *task, NSArray<ARTPurchasesLogData *> *datas))completion
                                   failure:(void (^)(ErrorItemd *error))failure;


#pragma mark 6.1 加关注
+ (NSURLSessionDataTask *)requestBecomeFans:(NSString *)userID
                                 completion:(void (^)(NSURLSessionDataTask *task))completion
                                    failure:(void (^)(ErrorItemd *error))failure;

#pragma mark 6.2 获取用户列表
+ (NSURLSessionDataTask *)requestMemberList:(ARTCustomParam *)param
                                 completion:(void (^)(NSURLSessionDataTask *task, NSArray<ARTUserData *> *datas))completion
                                    failure:(void (^)(ErrorItemd *error))failure;

#pragma mark 6.3 获取我关注的人列表
+ (NSURLSessionDataTask *)requestMyFans:(void (^)(NSURLSessionDataTask *task, NSArray<ARTUserData *> *datas))completion
                                failure:(void (^)(ErrorItemd *error))failure;

#pragma mark 6.4 发表说说
+ (NSURLSessionDataTask *)requestSendTalk:(ARTSendTalkParam *)param
                               completion:(void (^)(NSURLSessionDataTask *task))completion
                                  failure:(void (^)(ErrorItemd *error))failure;

#pragma mark 6.5 删除说说
+ (NSURLSessionDataTask *)requestDeleteTalk:(NSString *)talkID
                                 completion:(void (^)(NSURLSessionDataTask *task))completion
                                    failure:(void (^)(ErrorItemd *error))failure;

#pragma mark 6.6 评论说说
+ (NSURLSessionDataTask *)requestSendTalkCom:(ARTSendTalkComParam *)param
                                  completion:(void (^)(NSURLSessionDataTask *task))completion
                                     failure:(void (^)(ErrorItemd *error))failure;

#pragma mark 6.7 点赞说说
+ (NSURLSessionDataTask *)requestZanTalk:(NSString *)talkID
                              completion:(void (^)(NSURLSessionDataTask *task))completion
                                 failure:(void (^)(ErrorItemd *error))failure;

#pragma mark 6.8 获取说说详情
+ (NSURLSessionDataTask *)requestTalkDetail:(NSString *)talkID
                                 completion:(void (^)(NSURLSessionDataTask *task, ARTTalkData *data))completion
                                    failure:(void (^)(ErrorItemd *error))failure;

#pragma mark 6.9 查看某条说说所有赞
+ (NSURLSessionDataTask *)requestZanList:(ARTCustomParam *)param
                              completion:(void (^)(NSURLSessionDataTask *task, NSArray<ARTUserData *> *datas))completion
                                 failure:(void (^)(ErrorItemd *error))failure;

#pragma mark 6.10 查看某条说说所有评论
+ (NSURLSessionDataTask *)requestTalkComList:(ARTCustomParam *)param
                                  completion:(void (^)(NSURLSessionDataTask *task, NSArray<ARTTalkComData *> *datas))completion
                                     failure:(void (^)(ErrorItemd *error))failure;

#pragma mark 6.11 获取说说列表
+ (NSURLSessionDataTask *)requestTalkList:(ARTTalkListParam *)param
                                  completion:(void (^)(NSURLSessionDataTask *task, NSArray<ARTTalkData *> *datas))completion
                                     failure:(void (^)(ErrorItemd *error))failure;


#pragma mark 7.1 获取图集分类列表
+ (NSURLSessionDataTask *)requestGroups:(void (^)(NSURLSessionDataTask *task, NSArray<ARTGroupData *> *datas))completion
                                failure:(void (^)(ErrorItemd *error))failure;

#pragma mark 7.2 获取藏家列表
+ (NSURLSessionDataTask *)requestAuthorList:(ARTCustomParam *)param
                                 completion:(void (^)(NSURLSessionDataTask *task, NSArray<ARTAuthorData *> *datas))completion
                                    failure:(void (^)(ErrorItemd *error))failure;
#pragma mark 7.3 获取藏家详情
+ (NSURLSessionDataTask *)requestAuthorDetail:(NSString *)authorID
                                   completion:(void (^)(NSURLSessionDataTask *task, ARTAuthorData *data))completion
                                      failure:(void (^)(ErrorItemd *error))failure;

@end
