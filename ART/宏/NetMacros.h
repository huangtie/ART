//
//  NetMacros.h
//  ART
//
//  Created by huangtie on 16/4/21.
//  Copyright © 2016年 huangtie. All rights reserved.
//

#ifndef NetMacros_h
#define NetMacros_h

#if DEBUG
#define HOST @"http://yishangyacang.top"
#else
#define HOST @"http://yishangyacang.top"
#endif

#if DEBUG
#define PORT @"8888"
#else
#define PORT @"8888"
#endif

#define APPHOST(path) [NSString stringWithFormat:@"%@:%@%@",HOST,PORT,path]

//2.1 登录
#define URL_USER_LOGIN               APPHOST(@"/sjwlv3/script/login")

//2.2 注册
#define URL_USER_REGISTER            APPHOST(@"/sjwlv3/script/register")

//2.3 忘记密码
#define URL_USER_FINEPASSWORD        APPHOST(@"/sjwlv3/script/finepassword")

//2.4 获取基本资料
#define URL_USER_GETUSERINFO         APPHOST(@"/sjwlv3/script/getUserInfo")

//2.5 修改资料
#define URL_USER_UPDATEUSERINFO      APPHOST(@"/sjwlv3/script/updateUserInfo")

//2.6 上传头像
#define URL_USER_UPLOADPHOTO         APPHOST(@"/sjwlv3/script/uploadPhoto")


//3.1 获取图集列表
#define URL_BOOK_GETBOOKLIST         APPHOST(@"/sjwlv3/script/getBookList")

//3.2 获取图集详情
#define URL_BOOK_GETBOOKINFORMATION  APPHOST(@"/sjwlv3/script/getBookInformation")

//3.3 获取图集下载资源
#define URL_BOOK_GETBOOKDOWNDATA     APPHOST(@"/sjwlv3/script/getBookDownData")


//4.1 发表评论
#define URL_COMMEN_SENDCOMMENT       APPHOST(@"/sjwlv3/script/sendComment")

//4.2 获取评论列表
#define URL_COMMEN_GETBOOKCOMMENTS   APPHOST(@"/sjwlv3/script/getBookComments")


//5.1 获取充值列表
#define URL_PURCHASE_GETIAPPRICELIST APPHOST(@"/sjwlv3/script/getiapPriceList")

//5.2 购买图集
#define URL_PURCHASE_BUYWITHBOOK     APPHOST(@"/sjwlv3/script/buyWithBook")

//5.3 获取已购买的图集
#define URL_PURCHASE_GETBUYEDBOOKS   APPHOST(@"/sjwlv3/script/getBuyedBooks")

//5.4 获取充值和消费记录
#define URL_PURCHASE_GETPURCHASELOGS APPHOST(@"/sjwlv3/script/getPurchaseLogs")

//5.5 验证充值
#define URL_PURCHASE_VERIFYPUCHA     APPHOST(@"/sjwlv3/script/verifyPurchases")


//6.1 加关注
#define URL_TALK_BECOMEFANS          APPHOST(@"/sjwlv3/script/becomeFans")

//6.2 获取用户列表
#define URL_TALK_GETMENBERLIST       APPHOST(@"/sjwlv3/script/getMemberList")

//6.3 获取我关注的人列表
#define URL_TALK_GETFANSLIST         APPHOST(@"/sjwlv3/script/getFansList")

//6.4 发表说说
#define URL_TALK_SENDTALK            APPHOST(@"/sjwlv3/script/sendTalk")

//6.5 删除说说
#define URL_TALK_DELETETALK          APPHOST(@"/sjwlv3/script/deleteTalk")

//6.6 评论说说
#define URL_TALK_COMMENTTALK         APPHOST(@"/sjwlv3/script/commentTalk")

//6.7 点赞说说
#define URL_TALK_ZANTALK             APPHOST(@"/sjwlv3/script/zanTalk")

//6.8 获取说说详情
#define URL_TALK_GETTALKDETAIL       APPHOST(@"/sjwlv3/script/getTalkDetail")

//6.9 查看某条说说所有赞
#define URL_TALK_GETZANSWITHTALK     APPHOST(@"/sjwlv3/script/getZansWithTalk")

//6.10 查看某条说说所有评论
#define URL_TALK_GETCOMMENTSTALK     APPHOST(@"/sjwlv3/script/getCommentsWithTalk")

//6.11 获取说说列表
#define URL_TALK_GETTALKLIST         APPHOST(@"/sjwlv3/script/getTalkList")


//7.1 获取图集分类列表
#define URL_OT_GETGROUPLIST          APPHOST(@"/sjwlv3/script/getGroupList")

//7.2 获取藏家列表
#define URL_OT_GETAUTHORLIST         APPHOST(@"/sjwlv3/script/getAuthorList")

//7.3 获取藏家详情
#define URL_OT_GETAUTHORDETAIL       APPHOST(@"/sjwlv3/script/getAuthorDetail")

//7.4 获取文章列表
#define URL_OT_GETNEWSLIST           APPHOST(@"/sjwlv3/script/getNewsList")

//7.5 获取文章详情
#define URL_OT_GETNEWSDETAIL         APPHOST(@"/sjwlv3/script/getNewsDetail")

//7.6 获取通知公告(Banner)
#define URL_OT_GETBANNERLIST         APPHOST(@"/sjwlv3/script/getBannerList")

//7.7 获取省市区列表
#define URL_OT_GETCITYLIST           APPHOST(@"/sjwlv3/script/getCityList")


//8.1 拍卖列表
#define URL_GOOD_GETGOODSLIST        APPHOST(@"/sjwlv3/script/getGoodsList")

//8.2 获取拍品详情
#define URL_GOOD_GETGOODDETAIL       APPHOST(@"/sjwlv3/script/getGoodDetail")

//8.3 发布拍卖
#define URL_GOOD_SENDGOODS           APPHOST(@"/sjwlv3/script/sendGoods")

//8.4 出价
#define URL_GOOD_GOODPAY             APPHOST(@"/sjwlv3/script/goodPay")

//8.5 获取拍品的出价列表
#define URL_GOOD_GETGOODPAYLIST      APPHOST(@"/sjwlv3/script/getGoodPayList")

//8.6 成交拍卖
#define URL_GOOD_FINISHGOODPAY       APPHOST(@"/sjwlv3/script/finishGoodPay")

//8.7 拍品上架/下架
#define URL_GOOD_CHANGEGOODSTATUS    APPHOST(@"/sjwlv3/script/changeGoodStatus")


//9.1 上传认证
#define URL_GOOD_SENDIDCAR           APPHOST(@"/sjwlv3/script/sendIdCar")

//9.2 获取认证状态
#define URL_GOOD_GETIDCARSTATUS      APPHOST(@"/sjwlv3/script/getIdcarStatus")















#endif /* NetMacros_h */
