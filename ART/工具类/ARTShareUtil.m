//
//  ARTShareUtil.m
//  ART
//
//  Created by huangtie on 16/5/12.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import "ARTShareUtil.h"

#define SHARESDK_APPKEY @"2846da3a48d2"

#define SHARESDK_WEIBO_KEY @"2590093815"
#define SHARESDK_WEIBO_SECRET @"2958b8d8ffa15db6bd6c93c1d8ac467b"

#define SHARESDK_QQ_KEY @"1103522252"
#define SHARESDK_QQ_SECRET @"0524729e0cd106d8aa43063d524cef27"

#define SHARESDK_ZONE_KEY @"1103522252"
#define SHARESDK_ZONE_SECRET @"0524729e0cd106d8aa43063d524cef27"

#define SHARESDK_WECHAT_KEY @"wx36cbc0d570035131"
#define SHARESDK_WECHAT_SECRET @"acbc4f9688307c0b3f5c5fe3b9e4f2b8"

@implementation ARTShareUtil

+ (void)initShareSDK
{
    [ShareSDK registerApp:SHARESDK_APPKEY];
    
    [ShareSDK connectSinaWeiboWithAppKey:SHARESDK_WEIBO_KEY
                               appSecret:SHARESDK_WEIBO_SECRET
                             redirectUri:@"http://www.js-china.com"];
    
    [ShareSDK  connectSinaWeiboWithAppKey:SHARESDK_WEIBO_KEY
                                appSecret:SHARESDK_WEIBO_SECRET
                              redirectUri:@"http://www.js-china.com"
                              weiboSDKCls:[WeiboSDK class]];
    
    [ShareSDK connectQZoneWithAppKey:SHARESDK_ZONE_KEY
                           appSecret:SHARESDK_ZONE_SECRET
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //添加QQ应用  注册网址  http://mobile.qq.com/api/
    [ShareSDK connectQQWithQZoneAppKey:SHARESDK_ZONE_KEY
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    [ShareSDK connectQQWithAppId:SHARESDK_QQ_KEY qqApiCls:[QQApiInterface class]];
    
    //添加微信应用
    [ShareSDK connectWeChatWithAppId:SHARESDK_WECHAT_KEY appSecret:SHARESDK_WECHAT_SECRET wechatCls:[WXApi class]];
}

+ (void)shareIn:(SHARE_DESTINATION)type
        content:(NSString *)content
 defaultContent:(NSString *)defaultContent
          image:(id<ISSCAttachment>)image
          title:(NSString *)title
            url:(NSString *)url
    description:(NSString *)description
      mediaType:(SSPublishContentMediaType)mediaType
{
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:defaultContent
                                                image:image
                                                title:title
                                                  url:url
                                          description:description
                                            mediaType:mediaType];
    [ShareSDK clientShareContent:publishContent
                            type:(ShareType)type
                   statusBarTips:YES
                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                              
                              if (state == SSPublishContentStateSuccess)
                              {
                                  NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功!"));
                              }
                              else if (state == SSPublishContentStateFail)
                              {
                                  NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败!"), [error errorCode], [error errorDescription]);
                              }
                          }];
}

+ (void)loginThird:(SHARE_DESTINATION)type
        completion:(void (^)(id<ISSPlatformCredential> credential , id<ISSPlatformUser> userInfo))completion
{
    [ShareSDK getUserInfoWithType:(ShareType)type authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        if (result)
        {
            id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:ShareTypeWeixiSession];
            
            if(completion)
            {
                completion(credential , userInfo);
            }
        }
    }];
}

@end
