//
//  ARTShareUtil.h
//  ART
//
//  Created by huangtie on 16/5/12.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"

typedef enum
{
    SHARE_DESTINATION_WEIBO = ShareTypeSinaWeibo,           //新浪微博
    SHARE_DESTINATION_QQ = ShareTypeQQ,                     //QQ好友
    SHARE_DESTINATION_ZONE = ShareTypeQQSpace,              //QQ空间
    SHARE_DESTINATION_WECHAT = ShareTypeWeixiSession,       //微信好友
    SHARE_DESTINATION_TIMELINE = ShareTypeWeixiTimeline,    //朋友圈
    SHARE_DESTINATION_EMAIL = ShareTypeMail,                //邮件
    SHARE_DESTINATION_SMS = ShareTypeSMS,                   //短信
}SHARE_DESTINATION;

@interface ARTShareUtil : NSObject

+ (void)initShareSDK;

+ (void)shareIn:(SHARE_DESTINATION)type
        content:(NSString *)content
 defaultContent:(NSString *)defaultContent
          image:(id<ISSCAttachment>)image
          title:(NSString *)title
            url:(NSString *)url
    description:(NSString *)description
      mediaType:(SSPublishContentMediaType)mediaType;

+ (void)loginThird:(SHARE_DESTINATION)type
        completion:(void (^)(id<ISSPlatformCredential> credential , id<ISSPlatformUser> userInfo))completion;

@end
