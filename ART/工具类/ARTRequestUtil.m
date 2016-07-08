//
//  ARTRequestUtil.m
//  ART
//
//  Created by huangtie on 16/5/13.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTRequestUtil.h"
#import "ARTHttpServers.h"

@implementation ErrorItemd

@end

@implementation ARTRequestUtil

+ (BOOL)isSuccessCode:(id)response
{
    if (response && [[response objectForKey:@"success"] boolValue])
    {
        return YES;
    }
    else
    {
#if DEBUG
        if (response == nil)
        {
            NSLog(@"返回数据为空");
        }
        else if ([response objectForKey:@"success"] == nil)
        {
            NSLog(@"response success nil");
        }
        else if (![[response objectForKey:@"success"] boolValue] && [response objectForKey:@"errorMsg"])
        {
            NSString *error = [NSString stringWithFormat:@"%@",[response objectForKey:@"errorMsg"]];
            NSLog(@"%@",error);
        }
#endif
        return NO;
    }
}

+ (NSString *)errMsg:(NSInteger)errCode
{
    switch (errCode)
    {
        case NET_ERROR_0000:    return @"网络出错,请检查网络设置"; break;
        case NET_ERROR_9997:    return @"操作失败"; break;
        case NET_ERROR_9998:    return @"参数错误"; break;
        case NET_ERROR_9999:    return @"内部错误"; break;
        case NET_ERROR_10000:   return @"请求成功"; break;
        case NET_ERROR_10001:   return @"用户名不存在"; break;
        case NET_ERROR_10002:   return @"密码错误"; break;
        case NET_ERROR_10003:   return @"用户名重复"; break;
        case NET_ERROR_10004:   return @"该账号未绑定手机号或者手机号错误,请联系客服"; break;
        case NET_ERROR_10005:   return @"评论失败"; break;
        case NET_ERROR_10006:   return @"余额不足"; break;
        case NET_ERROR_10007:   return @"登录标识出错"; break;
        case NET_ERROR_10008:   return @"已购买过"; break;
        case NET_ERROR_10009:   return @"免费图集无需购买"; break;
        case NET_ERROR_10010:   return @"图集尚未购买"; break;
        case NET_ERROR_10011:   return @"该账号已在超过三台设备下载"; break;
        case NET_ERROR_10012:   return @"重复关注"; break;
        case NET_ERROR_10013:   return @"发表失败"; break;
        case NET_ERROR_10014:   return @"删除失败"; break;
        case NET_ERROR_10015:   return @"点赞失败"; break;
        case NET_ERROR_10016:   return @"出价失败"; break;
        case NET_ERROR_10017:   return @"成交失败"; break;
        default: return @"";
    }
}

+ (ErrorItemd *)tamp:(NSError *)error response:(id)response
{
    ErrorItemd *itemd = [[ErrorItemd alloc] init];
    if (error)
    {
        itemd.code = NET_ERROR_0000;
        itemd.errMsg = [ARTRequestUtil errMsg:NET_ERROR_0000];
    }
    else
    {
        itemd.code = [[response objectForKey:@"errorCode"] integerValue];
        itemd.errMsg = [response objectForKey:@"errorMsg"];
    }
    return itemd;
}

#pragma mark 2.1 登录
+ (NSURLSessionDataTask *)requestLogin:(ARTLoginParam *)param
                            completion:(void (^)(NSURLSessionDataTask *task, ARTUserData *data))completion
                               failure:(void (^)(ErrorItemd *error))failure
{
    return [ARTHttpServers requestWithPOST:URL_USER_LOGIN param:[param buildRequestParam] completion:^(NSURLSessionDataTask *task, id result, NSError *error) {
        if ([ARTRequestUtil isSuccessCode:result])
        {
            ARTUserData *user = [ARTUserData mj_objectWithKeyValues:[result objectForKey:@"data"]];
            completion(task , user);
        }
        else
        {
            failure([ARTRequestUtil tamp:error response:result]);
        }
    }];
}

#pragma mark 2.2 注册
+ (NSURLSessionDataTask *)requestRegister:(ARTRegisterParam *)param
                               completion:(void (^)(NSURLSessionDataTask *task, ARTUserData *data))completion
                                  failure:(void (^)(ErrorItemd *error))failure
{
    return [ARTHttpServers requestWithPOST:URL_USER_REGISTER param:[param buildRequestParam] completion:^(NSURLSessionDataTask *task, id result, NSError *error) {
        if ([ARTRequestUtil isSuccessCode:result])
        {
            ARTUserData *user = [ARTUserData mj_objectWithKeyValues:[result objectForKey:@"data"]];
            completion(task , user);
        }
        else
        {
            failure([ARTRequestUtil tamp:error response:result]);
        }
    }];
}

#pragma mark 2.3 忘记密码
+ (NSURLSessionDataTask *)requestFinepassword:(ARTForgetParam *)param
                                   completion:(void (^)(NSURLSessionDataTask *task))completion
                                      failure:(void (^)(ErrorItemd *error))failure
{
    return [ARTHttpServers requestWithPOST:URL_USER_FINEPASSWORD param:[param buildRequestParam] completion:^(NSURLSessionDataTask *task, id result, NSError *error) {
        if ([ARTRequestUtil isSuccessCode:result])
        {
            completion(task);
        }
        else
        {
            failure([ARTRequestUtil tamp:error response:result]);
        }
    }];
}

#pragma mark 2.4 获取基本资料
+ (NSURLSessionDataTask *)requestUserinfo:(NSString *)userID
                               completion:(void (^)(NSURLSessionDataTask *task, ARTUserInfo *data))completion
                                  failure:(void (^)(ErrorItemd *error))failure
{
    return [ARTHttpServers requestWithPOST:URL_USER_GETUSERINFO param:@{@"userID":userID} completion:^(NSURLSessionDataTask *task, id result, NSError *error) {
        if ([ARTRequestUtil isSuccessCode:result])
        {
            ARTUserInfo *user = [ARTUserInfo mj_objectWithKeyValues:[result objectForKey:@"data"]];
            completion(task , user);
        }
        else
        {
            failure([ARTRequestUtil tamp:error response:result]);
        }
    }];
}

#pragma mark 2.5 修改资料
+ (NSURLSessionDataTask *)requestUpdateInfo:(ARTUpsetParam *)param
                                 completion:(void (^)(NSURLSessionDataTask *task))completion
                                    failure:(void (^)(ErrorItemd *error))failure
{
    return [ARTHttpServers requestWithPOST:URL_USER_UPDATEUSERINFO param:[param buildRequestParam] completion:^(NSURLSessionDataTask *task, id result, NSError *error) {
        if ([ARTRequestUtil isSuccessCode:result])
        {
            completion(task);
        }
        else
        {
            failure([ARTRequestUtil tamp:error response:result]);
        }
    }];
}

#pragma mark 2.6 上传头像
+ (NSURLSessionDataTask *)requestUploadFace:(UIImage *)faceImage
                                 completion:(void (^)(NSURLSessionDataTask *task, NSString *userImage))completion
                                    failure:(void (^)(ErrorItemd *error))failure
{
    return [ARTHttpServers requestWithUpload:URL_USER_UPLOADPHOTO param:[[NSDictionary alloc] init] datas:@[UIImageJPEGRepresentation(faceImage, .5)] completion:^(NSURLSessionDataTask *task, id result, NSError *error) {
        if ([ARTRequestUtil isSuccessCode:result])
        {
            completion(task , [[result objectForKey:@"data"] objectForKey:@"userImage"]);
        }
        else
        {
            failure([ARTRequestUtil tamp:error response:result]);
        }
    }];
}

#pragma mark 3.1 获取图集列表
+ (NSURLSessionDataTask *)requestBookList:(ARTBookListParam *)param
                               completion:(void (^)(NSURLSessionDataTask *task, NSArray<ARTBookData *> *datas))completion
                                  failure:(void (^)(ErrorItemd *error))failure
{
    return [ARTHttpServers requestWithPOST:URL_BOOK_GETBOOKLIST param:[param buildRequestParam] completion:^(NSURLSessionDataTask *task, id result, NSError *error) {
        if ([ARTRequestUtil isSuccessCode:result])
        {
            NSMutableArray *list = [NSMutableArray array];
            for (NSDictionary *dic in [result objectForKey:@"data"])
            {
                ARTBookData *data = [ARTBookData mj_objectWithKeyValues:dic];
                [list addObject:data];
            }
            completion(task , list);
        }
        else
        {
            failure([ARTRequestUtil tamp:error response:result]);
        }
    }];
}

#pragma mark 3.2 获取图集详情
+ (NSURLSessionDataTask *)requestBookDetail:(NSString *)bookID
                                 completion:(void (^)(NSURLSessionDataTask *task, ARTBookData *data))completion
                                    failure:(void (^)(ErrorItemd *error))failure
{
    return [ARTHttpServers requestWithPOST:URL_BOOK_GETBOOKINFORMATION param:@{@"bookID":bookID} completion:^(NSURLSessionDataTask *task, id result, NSError *error) {
        if ([ARTRequestUtil isSuccessCode:result])
        {
            ARTBookData *data = [ARTBookData mj_objectWithKeyValues:[result objectForKey:@"data"]];
            completion(task , data);
        }
        else
        {
            failure([ARTRequestUtil tamp:error response:result]);
        }
    }];
}

#pragma mark 3.3 获取图集下载资源
+ (NSURLSessionDataTask *)requestBookDowns:(NSString *)bookID
                                completion:(void (^)(NSURLSessionDataTask *task, NSArray<ARTBookDownData *> *datas))completion
                                   failure:(void (^)(ErrorItemd *error))failure
{
    return [ARTHttpServers requestWithPOST:URL_BOOK_GETBOOKDOWNDATA param:@{@"bookID":bookID} completion:^(NSURLSessionDataTask *task, id result, NSError *error) {
        if ([ARTRequestUtil isSuccessCode:result])
        {
            NSMutableArray *list = [NSMutableArray array];
            for (NSDictionary *dic in [result objectForKey:@"data"])
            {
                ARTBookDownData *data = [ARTBookDownData mj_objectWithKeyValues:dic];
                [list addObject:data];
            }
            completion(task , list);
        }
        else
        {
            failure([ARTRequestUtil tamp:error response:result]);
        }
    }];
}

#pragma mark 4.1 发表评论
+ (NSURLSessionDataTask *)requestSendComment:(ARTCommentSendParam *)param
                                  completion:(void (^)(NSURLSessionDataTask *task))completion
                                     failure:(void (^)(ErrorItemd *error))failure
{
    return [ARTHttpServers requestWithPOST:URL_COMMEN_SENDCOMMENT param:[param buildRequestParam] completion:^(NSURLSessionDataTask *task, id result, NSError *error) {
        if ([ARTRequestUtil isSuccessCode:result])
        {
            completion(task);
        }
        else
        {
            failure([ARTRequestUtil tamp:error response:result]);
        }
    }];
}

#pragma mark 4.2 获取评论列表
+ (NSURLSessionDataTask *)requestCommentList:(ARTCommentListParam *)param
                                  completion:(void (^)(NSURLSessionDataTask *task, NSArray<ARTCommentData *> *datas))completion
                                     failure:(void (^)(ErrorItemd *error))failure
{
    return [ARTHttpServers requestWithPOST:URL_COMMEN_GETBOOKCOMMENTS param:[param buildRequestParam] completion:^(NSURLSessionDataTask *task, id result, NSError *error) {
        if ([ARTRequestUtil isSuccessCode:result])
        {
            NSMutableArray *list = [NSMutableArray array];
            for (NSDictionary *dic in [result objectForKey:@"data"])
            {
                ARTCommentData *data = [ARTCommentData mj_objectWithKeyValues:dic];
                [list addObject:data];
            }
            completion(task , list);
        }
        else
        {
            failure([ARTRequestUtil tamp:error response:result]);
        }
    }];
}

#pragma mark 5.1 获取充值列表
+ (NSURLSessionDataTask *)requestPurchasesList:(void (^)(NSURLSessionDataTask *task, NSArray<ARTPurchasesData *> *datas))completion
                                       failure:(void (^)(ErrorItemd *error))failure
{
    return [ARTHttpServers requestWithPOST:URL_PURCHASE_GETIAPPRICELIST param:[[NSDictionary alloc] init] completion:^(NSURLSessionDataTask *task, id result, NSError *error) {
        if ([ARTRequestUtil isSuccessCode:result])
        {
            NSMutableArray *list = [NSMutableArray array];
            for (NSDictionary *dic in [result objectForKey:@"data"])
            {
                ARTPurchasesData *data = [ARTPurchasesData mj_objectWithKeyValues:dic];
                [list addObject:data];
            }
            completion(task , list);
        }
        else
        {
            failure([ARTRequestUtil tamp:error response:result]);
        }
    }];
}

#pragma mark 5.2 购买图集
+ (NSURLSessionDataTask *)requestBuyBook:(NSString *)bookID
                              completion:(void (^)(NSURLSessionDataTask *task))completion
                                 failure:(void (^)(ErrorItemd *error))failure
{
    return [ARTHttpServers requestWithPOST:URL_PURCHASE_BUYWITHBOOK param:@{@"bookID":bookID} completion:^(NSURLSessionDataTask *task, id result, NSError *error) {
        if ([ARTRequestUtil isSuccessCode:result])
        {
            completion(task);
        }
        else
        {
            failure([ARTRequestUtil tamp:error response:result]);
        }
    }];
}

#pragma mark 5.3 获取已购买的图集
+ (NSURLSessionDataTask *)requestBuyedList:(ARTCustomParam *)param
                                completion:(void (^)(NSURLSessionDataTask *task, NSArray<ARTBookData *> *datas))completion
                                   failure:(void (^)(ErrorItemd *error))failure
{
    return [ARTHttpServers requestWithPOST:URL_PURCHASE_GETBUYEDBOOKS param:[param buildRequestParam] completion:^(NSURLSessionDataTask *task, id result, NSError *error) {
        if ([ARTRequestUtil isSuccessCode:result])
        {
            NSMutableArray *list = [NSMutableArray array];
            for (NSDictionary *dic in [result objectForKey:@"data"])
            {
                ARTBookData *data = [ARTBookData mj_objectWithKeyValues:dic];
                [list addObject:data];
            }
            completion(task , list);
        }
        else
        {
            failure([ARTRequestUtil tamp:error response:result]);
        }
    }];
}

#pragma mark 5.4 获取充值和消费记录
+ (NSURLSessionDataTask *)requestPurchaLog:(ARTCustomParam *)param
                                completion:(void (^)(NSURLSessionDataTask *task, NSArray<ARTPurchasesLogData *> *datas))completion
                                   failure:(void (^)(ErrorItemd *error))failure
{
    return [ARTHttpServers requestWithPOST:URL_PURCHASE_GETPURCHASELOGS param:[param buildRequestParam] completion:^(NSURLSessionDataTask *task, id result, NSError *error) {
        if ([ARTRequestUtil isSuccessCode:result])
        {
            NSMutableArray *list = [NSMutableArray array];
            for (NSDictionary *dic in [result objectForKey:@"data"])
            {
                ARTPurchasesLogData *data = [ARTPurchasesLogData mj_objectWithKeyValues:dic];
                [list addObject:data];
            }
            completion(task , list);
        }
        else
        {
            failure([ARTRequestUtil tamp:error response:result]);
        }
    }];
}

#pragma mark 5.5 验证充值
+ (NSURLSessionDataTask *)requestVerifyPurchases:(ARTPurchaParam *)param
                                      completion:(void (^)(NSURLSessionDataTask *task, PURCHA_STATUS status))completion
                                         failure:(void (^)(ErrorItemd *error))failure
{
    return [ARTHttpServers requestWithPOST:URL_PURCHASE_VERIFYPUCHA param:[param buildRequestParam] completion:^(NSURLSessionDataTask *task, id result, NSError *error) {
        if ([ARTRequestUtil isSuccessCode:result])
        {
            NSDictionary *data = [result objectForKey:@"data"];
            completion(task , [data[@"status"] integerValue]);
        }
        else
        {
            failure([ARTRequestUtil tamp:error response:result]);
        }
    }];
}

#pragma mark 6.1 加关注
+ (NSURLSessionDataTask *)requestBecomeFans:(NSString *)userID
                                 completion:(void (^)(NSURLSessionDataTask *task))completion
                                    failure:(void (^)(ErrorItemd *error))failure
{
    return [ARTHttpServers requestWithPOST:URL_TALK_BECOMEFANS param:@{@"userID":userID} completion:^(NSURLSessionDataTask *task, id result, NSError *error) {
        if ([ARTRequestUtil isSuccessCode:result])
        {
            completion(task);
        }
        else
        {
            failure([ARTRequestUtil tamp:error response:result]);
        }
    }];
}

#pragma mark 6.2 获取用户列表
+ (NSURLSessionDataTask *)requestMemberList:(ARTCustomParam *)param
                                 completion:(void (^)(NSURLSessionDataTask *task, NSArray<ARTUserData *> *datas))completion
                                    failure:(void (^)(ErrorItemd *error))failure
{
    return [ARTHttpServers requestWithPOST:URL_TALK_GETMENBERLIST param:[param buildRequestParam] completion:^(NSURLSessionDataTask *task, id result, NSError *error) {
        if ([ARTRequestUtil isSuccessCode:result])
        {
            NSMutableArray *list = [NSMutableArray array];
            for (NSDictionary *dic in [result objectForKey:@"data"])
            {
                ARTUserData *data = [ARTUserData mj_objectWithKeyValues:dic];
                [list addObject:data];
            }
            completion(task , list);
        }
        else
        {
            failure([ARTRequestUtil tamp:error response:result]);
        }
    }];
}

#pragma mark 6.3 获取我关注的人列表
+ (NSURLSessionDataTask *)requestMyFans:(void (^)(NSURLSessionDataTask *task, NSArray<ARTUserData *> *datas))completion
                                failure:(void (^)(ErrorItemd *error))failure
{
    return [ARTHttpServers requestWithPOST:URL_TALK_GETFANSLIST param:[[NSDictionary alloc] init] completion:^(NSURLSessionDataTask *task, id result, NSError *error) {
        if ([ARTRequestUtil isSuccessCode:result])
        {
            NSMutableArray *list = [NSMutableArray array];
            for (NSDictionary *dic in [result objectForKey:@"data"])
            {
                ARTUserData *data = [ARTUserData mj_objectWithKeyValues:dic];
                [list addObject:data];
            }
            completion(task , list);
        }
        else
        {
            failure([ARTRequestUtil tamp:error response:result]);
        }
    }];
}

#pragma mark 6.4 发表说说
+ (NSURLSessionDataTask *)requestSendTalk:(ARTSendTalkParam *)param
                               completion:(void (^)(NSURLSessionDataTask *task))completion
                                  failure:(void (^)(ErrorItemd *error))failure
{
    return [ARTHttpServers requestWithUpload:URL_TALK_SENDTALK param:[param buildRequestParam] datas:param.talkImages completion:^(NSURLSessionDataTask *task, id result, NSError *error) {
        if ([ARTRequestUtil isSuccessCode:result])
        {
            completion(task);
        }
        else
        {
            failure([ARTRequestUtil tamp:error response:result]);
        }
    }];
}

#pragma mark 6.5 删除说说
+ (NSURLSessionDataTask *)requestDeleteTalk:(NSString *)talkID
                                 completion:(void (^)(NSURLSessionDataTask *task))completion
                                    failure:(void (^)(ErrorItemd *error))failure
{
    return [ARTHttpServers requestWithPOST:URL_TALK_DELETETALK param:@{@"talkID":talkID} completion:^(NSURLSessionDataTask *task, id result, NSError *error) {
        if ([ARTRequestUtil isSuccessCode:result])
        {
            completion(task);
        }
        else
        {
            failure([ARTRequestUtil tamp:error response:result]);
        }
    }];
}

#pragma mark 6.6 评论说说
+ (NSURLSessionDataTask *)requestSendTalkCom:(ARTSendTalkComParam *)param
                                  completion:(void (^)(NSURLSessionDataTask *task))completion
                                     failure:(void (^)(ErrorItemd *error))failure
{
    return [ARTHttpServers requestWithPOST:URL_TALK_COMMENTTALK param:[param buildRequestParam] completion:^(NSURLSessionDataTask *task, id result, NSError *error) {
        if ([ARTRequestUtil isSuccessCode:result])
        {
            completion(task);
        }
        else
        {
            failure([ARTRequestUtil tamp:error response:result]);
        }
    }];
}

#pragma mark 6.7 点赞说说
+ (NSURLSessionDataTask *)requestZanTalk:(NSString *)talkID
                              completion:(void (^)(NSURLSessionDataTask *task))completion
                                 failure:(void (^)(ErrorItemd *error))failure
{
    return [ARTHttpServers requestWithPOST:URL_TALK_ZANTALK param:@{@"talkID":talkID} completion:^(NSURLSessionDataTask *task, id result, NSError *error) {
        if ([ARTRequestUtil isSuccessCode:result])
        {
            completion(task);
        }
        else
        {
            failure([ARTRequestUtil tamp:error response:result]);
        }
    }];
}

#pragma mark 6.8 获取说说详情
+ (NSURLSessionDataTask *)requestTalkDetail:(NSString *)talkID
                                 completion:(void (^)(NSURLSessionDataTask *task, ARTTalkData *data))completion
                                    failure:(void (^)(ErrorItemd *error))failure
{
    return [ARTHttpServers requestWithPOST:URL_TALK_GETTALKDETAIL param:@{@"talkID":talkID} completion:^(NSURLSessionDataTask *task, id result, NSError *error) {
        if ([ARTRequestUtil isSuccessCode:result])
        {
            ARTTalkData *data = [ARTTalkData mj_objectWithKeyValues:[result objectForKey:@"data"]];
            completion(task , data);
        }
        else
        {
            failure([ARTRequestUtil tamp:error response:result]);
        }
    }];
}

#pragma mark 6.9 查看某条说说所有赞
+ (NSURLSessionDataTask *)requestZanList:(ARTCustomParam *)param
                              completion:(void (^)(NSURLSessionDataTask *task, NSArray<ARTUserData *> *datas))completion
                                 failure:(void (^)(ErrorItemd *error))failure
{
    return [ARTHttpServers requestWithPOST:URL_TALK_GETZANSWITHTALK param:[param buildRequestParam] completion:^(NSURLSessionDataTask *task, id result, NSError *error) {
        if ([ARTRequestUtil isSuccessCode:result])
        {
            NSMutableArray *list = [NSMutableArray array];
            for (NSDictionary *dic in [result objectForKey:@"data"])
            {
                ARTUserData *data = [ARTUserData mj_objectWithKeyValues:dic];
                [list addObject:data];
            }
            completion(task , list);
        }
        else
        {
            failure([ARTRequestUtil tamp:error response:result]);
        }
    }];
}

#pragma mark 6.10 查看某条说说所有评论
+ (NSURLSessionDataTask *)requestTalkComList:(ARTCustomParam *)param
                                  completion:(void (^)(NSURLSessionDataTask *task, NSArray<ARTTalkComData *> *datas))completion
                                     failure:(void (^)(ErrorItemd *error))failure
{
    return [ARTHttpServers requestWithPOST:URL_TALK_GETCOMMENTSTALK param:[param buildRequestParam] completion:^(NSURLSessionDataTask *task, id result, NSError *error) {
        if ([ARTRequestUtil isSuccessCode:result])
        {
            NSMutableArray *list = [NSMutableArray array];
            for (NSDictionary *dic in [result objectForKey:@"data"])
            {
                ARTTalkComData *data = [ARTTalkComData mj_objectWithKeyValues:dic];
                [list addObject:data];
            }
            completion(task , list);
        }
        else
        {
            failure([ARTRequestUtil tamp:error response:result]);
        }
    }];
}

#pragma mark 6.11 获取说说列表
+ (NSURLSessionDataTask *)requestTalkList:(ARTTalkListParam *)param
                               completion:(void (^)(NSURLSessionDataTask *task, NSArray<ARTTalkData *> *datas))completion
                                  failure:(void (^)(ErrorItemd *error))failure
{
    return [ARTHttpServers requestWithPOST:URL_TALK_GETTALKLIST param:[param buildRequestParam] completion:^(NSURLSessionDataTask *task, id result, NSError *error) {
        if ([ARTRequestUtil isSuccessCode:result])
        {
            NSMutableArray *list = [NSMutableArray array];
            for (NSDictionary *dic in [result objectForKey:@"data"])
            {
                ARTTalkData *data = [ARTTalkData mj_objectWithKeyValues:dic];
                [list addObject:data];
                NSArray *images = dic[@"talkImages"];
                data.talkImages = images;
            }
            completion(task , list);
        }
        else
        {
            failure([ARTRequestUtil tamp:error response:result]);
        }
    }];
}

#pragma mark 7.1 获取图集分类列表
+ (NSURLSessionDataTask *)requestGroups:(void (^)(NSURLSessionDataTask *task, NSArray<ARTGroupData *> *datas))completion
                                failure:(void (^)(ErrorItemd *error))failure
{
    return [ARTHttpServers requestWithPOST:URL_OT_GETGROUPLIST param:[[NSDictionary alloc] init] completion:^(NSURLSessionDataTask *task, id result, NSError *error) {
        if ([ARTRequestUtil isSuccessCode:result])
        {
            NSMutableArray *list = [NSMutableArray array];
            for (NSDictionary *dic in [result objectForKey:@"data"])
            {
                ARTGroupData *data = [ARTGroupData mj_objectWithKeyValues:dic];
                [list addObject:data];
            }
            completion(task , list);
        }
        else
        {
            failure([ARTRequestUtil tamp:error response:result]);
        }
    }];
}

#pragma mark 7.2 获取藏家列表
+ (NSURLSessionDataTask *)requestAuthorList:(ARTCustomParam *)param
                                 completion:(void (^)(NSURLSessionDataTask *task, NSArray<ARTAuthorData *> *datas))completion
                                    failure:(void (^)(ErrorItemd *error))failure
{
    return [ARTHttpServers requestWithPOST:URL_OT_GETAUTHORLIST param:[param buildRequestParam] completion:^(NSURLSessionDataTask *task, id result, NSError *error) {
        if ([ARTRequestUtil isSuccessCode:result])
        {
            NSMutableArray *list = [NSMutableArray array];
            for (NSDictionary *dic in [result objectForKey:@"data"])
            {
                ARTAuthorData *data = [ARTAuthorData mj_objectWithKeyValues:dic];
                [list addObject:data];
            }
            completion(task , list);
        }
        else
        {
            failure([ARTRequestUtil tamp:error response:result]);
        }
    }];
}

#pragma mark 7.3 获取藏家详情
+ (NSURLSessionDataTask *)requestAuthorDetail:(NSString *)authorID
                                   completion:(void (^)(NSURLSessionDataTask *task, ARTAuthorData *data))completion
                                      failure:(void (^)(ErrorItemd *error))failure
{
    return [ARTHttpServers requestWithPOST:URL_OT_GETAUTHORDETAIL param:@{@"authorID":authorID} completion:^(NSURLSessionDataTask *task, id result, NSError *error) {
        if ([ARTRequestUtil isSuccessCode:result])
        {
            ARTAuthorData *data = [ARTAuthorData mj_objectWithKeyValues:[result objectForKey:@"data"]];
            completion(task , data);
        }
        else
        {
            failure([ARTRequestUtil tamp:error response:result]);
        }
    }];
}

#pragma mark 7.4 获取文章列表
+ (NSURLSessionDataTask *)requestNewsList:(ARTCustomParam *)param
                               completion:(void (^)(NSURLSessionDataTask *task, NSArray<ARTNewsData *> *datas))completion
                                  failure:(void (^)(ErrorItemd *error))failure
{
    return [ARTHttpServers requestWithPOST:URL_OT_GETNEWSLIST param:[param buildRequestParam] completion:^(NSURLSessionDataTask *task, id result, NSError *error) {
        if ([ARTRequestUtil isSuccessCode:result])
        {
            NSMutableArray *list = [NSMutableArray array];
            for (NSDictionary *dic in [result objectForKey:@"data"])
            {
                ARTNewsData *data = [ARTNewsData mj_objectWithKeyValues:dic];
                [list addObject:data];
            }
            completion(task , list);
        }
        else
        {
            failure([ARTRequestUtil tamp:error response:result]);
        }
    }];
}

#pragma mark 7.5 获取新闻详情
+ (NSURLSessionDataTask *)requestNewsDetail:(NSString *)newsID
                                 completion:(void (^)(NSURLSessionDataTask *task, ARTNewsData *data))completion
                                    failure:(void (^)(ErrorItemd *error))failure
{
    return [ARTHttpServers requestWithPOST:URL_OT_GETNEWSDETAIL param:@{@"newsID":newsID} completion:^(NSURLSessionDataTask *task, id result, NSError *error) {
        if ([ARTRequestUtil isSuccessCode:result])
        {
            ARTNewsData *data = [ARTNewsData mj_objectWithKeyValues:[result objectForKey:@"data"]];
            completion(task , data);
        }
        else
        {
            failure([ARTRequestUtil tamp:error response:result]);
        }
    }];
}

#pragma mark 7.6 获取通知公告(Banner)
+ (NSURLSessionDataTask *)requestNotices:(void (^)(NSURLSessionDataTask *task, NSArray<ARTNoticeData *> *datas))completion
                                 failure:(void (^)(ErrorItemd *error))failure
{
    return [ARTHttpServers requestWithPOST:URL_OT_GETBANNERLIST param:[[NSDictionary alloc] init] completion:^(NSURLSessionDataTask *task, id result, NSError *error) {
        if ([ARTRequestUtil isSuccessCode:result])
        {
            NSMutableArray *list = [NSMutableArray array];
            for (NSDictionary *dic in [result objectForKey:@"data"])
            {
                ARTNoticeData *data = [ARTNoticeData mj_objectWithKeyValues:dic];
                [list addObject:data];
            }
            completion(task , list);
        }
        else
        {
            failure([ARTRequestUtil tamp:error response:result]);
        }
    }];
}

#pragma mark 7.7 获取省市区列表
+ (NSURLSessionDataTask *)requestCityList:(ARTCityParam *)param
                               completion:(void (^)(NSURLSessionDataTask *task, NSArray<ARTCityData *> *datas))completion
                                  failure:(void (^)(ErrorItemd *error))failure
{
    return [ARTHttpServers requestWithPOST:URL_OT_GETCITYLIST param:[param buildRequestParam] completion:^(NSURLSessionDataTask *task, id result, NSError *error) {
        if ([ARTRequestUtil isSuccessCode:result])
        {
            NSMutableArray *list = [NSMutableArray array];
            for (NSDictionary *dic in [result objectForKey:@"data"])
            {
                ARTCityData *data = [ARTCityData mj_objectWithKeyValues:dic];
                [list addObject:data];
            }
            completion(task , list);
        }
        else
        {
            failure([ARTRequestUtil tamp:error response:result]);
        }
    }];
}

@end
