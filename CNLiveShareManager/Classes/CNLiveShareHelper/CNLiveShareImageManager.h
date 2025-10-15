//
//  CNLiveShareImageManager.h
//  CNLiveNetAdd
//
//  Created by 流诗语 on 2019/5/5.
//  Copyright © 2019年 cnlive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "CNLiveShareManager.h"
typedef enum : NSUInteger {
    CNLiveShareStatueSuccess,//成功
    CNLiveShareStatueFail,//失败
    CNLiveShareStatueCancel,//取消
} CNLiveShareStatue;

typedef enum : NSUInteger {
    CNLiveContentTypeAuto,//自动识别
    CNLiveContentTypeText,
    CNLiveContentTypeImage,
    CNLiveContentTypeWebpage,
    CNLiveContentTypeAudio,
    CNLiveContentTypeVideo,
    CNLiveContentTypeMiniProgram //仅微信好友
} CNLiveContentType;

//登录返回类型
typedef enum : NSUInteger {
    CNLiveSendAuthRespWX,
    CNLiveSendAuthRespQQ,
    CNLiveSendAuthRespWB,
} CNLiveSendAuthResp;

static NSString *const CNLiveShareName  = @"CNLiveShareName";
static NSString *const CNLiveShareDesc  = @"CNLiveShareDesc";
static NSString *const CNLiveShareURL   = @"CNLiveShareURL";
static NSString *const CNLiveShareImage = @"CNLiveShareImage";
static NSString *const CNLiveShareUName = @"CNLiveShareUName";
static NSString *const CNLiveShareTickt = @"CNLiveShareTickt";
static NSString *const CNLiveSharePath  = @"CNLiveSharePath";
static NSString *const CNLiveShareConTy = @"CNLiveShareConTy";

@interface CNLiveThirdPartyModel : NSObject

@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *faceUrl;
@property (nonatomic, copy) NSString *thirdPartyId;

- (instancetype)initWithNickName:(NSString *)nickName Gender:(NSString *)gender Location:(NSString *)location FaceUrl:(NSString *)faceUrl PartyId:(NSString *)partyId;

@end

/**分享状态返回结果*/
typedef void(^DidRecvStatueBlock)(CNLiveShareStatue statue);

/**三方登录状态返回*/
typedef void(^DidSendAuthBlock)(CNLiveSendAuthResp type,CNLiveThirdPartyModel * userInfo,NSError *error);

@interface CNLiveShareImageManager : NSObject<WXApiDelegate,QQApiInterfaceDelegate,TencentSessionDelegate,WeiboSDKDelegate>

/**初始化分享方法集合类*/
+(instancetype)manager;

@property (nonatomic, strong) TencentOAuth * auth;

#pragma mark - 构建分享参数
/**
 分享参数构建(此为连接类型分享)

 @param shareName 分享标题
 @param images 分享图片 (仅支持UIImage NSData NSURL NSString)
 @param url 分享链接
 @param desc 分享描述
 @param userName 小程序分享id (不分享小程序则不传)
 @param isTicket 小程序是否转发  (不分享小程序则不传)
 @param path 小程序分享地址  (不分享小程序则不传)
 @param contentType 分享形式
 @return 返回参数集合
 */
-(NSDictionary *)setupShareParamsByName:(NSString *)shareName
                                 images:(id)images
                                    URL:(NSString *)url
                                   Desc:(NSString *)desc
                               UserName:(NSString *)userName
                        withShareTicket:(BOOL)isTicket
                                   Path:(NSString *)path
                            ContentType:(CNLiveContentType)contentType;




#pragma mark - 调用分享方法
/**
 调用分享方法

 @param platformType 分享平台
 @param params 分享参数
 @param statueBlock 分享状态结果回调
 */
+(void)share:(CNLiveSharePlatformType)platformType
      Params:(NSDictionary *)params
RecvStatusBlock:(DidRecvStatueBlock)statueBlock;

#pragma mark - 三方登录回调

/**
 三方登录结果返回

 @param authBlock 结果 block
 */
+(void)send:(CNLiveSendAuthResp)authType authRespBlock:(DidSendAuthBlock)authBlock;


@end

