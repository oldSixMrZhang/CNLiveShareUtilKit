

//
//  CNLiveShareImageManager.m
//  CNLiveNetAdd
//
//  Created by 流诗语 on 2019/5/5.
//  Copyright © 2019年 cnlive. All rights reserved.
//

#import "CNLiveShareImageManager.h"
#import "CNLiveShareRequestHandler.h"
#import "CNLiveShareExtension.h"
#import "CNLiveNetworking.h"
#import <CNLiveEnvironment/CNLiveEnvironment.h>
#import "NSString+CNLiveShareExtension.h"
@implementation CNLiveThirdPartyModel
- (instancetype)initWithNickName:(NSString *)nickName Gender:(NSString *)gender Location:(NSString *)location FaceUrl:(NSString *)faceUrl PartyId:(NSString *)partyId
{
    self = [super init];
    if (self) {
        self.nickName = nickName;
        self.gender = gender;
        self.location = location;
        self.faceUrl = faceUrl;
        self.thirdPartyId = partyId;
    }
    return self;
}
-(NSString *)description
{
    return [NSString stringWithFormat:@"%@+%@+%@+%@+%@",self.nickName,self.gender,self.location,self.faceUrl,self.thirdPartyId];
}
@end

@interface CNLiveShareImageManager ()

@property (nonatomic, copy) DidRecvStatueBlock statueBlock;
@property (nonatomic, copy) DidSendAuthBlock sendAuthBlock;

@property (nonatomic, assign) BOOL isAuthQQ;
@end

@implementation CNLiveShareImageManager

#pragma mark - 初始化消息回调方法
#pragma mark -
+(instancetype)manager
{
    static CNLiveShareImageManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[super allocWithZone:NULL] init];
    });
    return manager;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [CNLiveShareImageManager manager];
}
- (id)copyWithZone:(nullable NSZone *)zone {
    return [CNLiveShareImageManager manager];
}
- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [CNLiveShareImageManager manager];
}
#pragma mark - 构建参数
//连接类型分享
-(NSDictionary *)setupShareParamsByName:(NSString *)shareName images:(id)images URL:(NSString *)url Desc:(NSString *)desc UserName:(NSString *)userName withShareTicket:(BOOL)isTicket Path:(NSString *)path ContentType:(CNLiveContentType)contentType
{
    NSMutableDictionary * paramsDict = [[NSMutableDictionary alloc] init];
    if ([self check:shareName].length > 50) {
        [paramsDict setObject:[[self check:shareName] substringWithRange:NSMakeRange(0, 50)] forKey:CNLiveShareName];
    }else{
        [paramsDict setObject:[self check:shareName] forKey:CNLiveShareName];
    }
    if ([images isKindOfClass:[NSString class]]) [paramsDict setObject:images forKey:CNLiveShareImage];
    if ([images isKindOfClass:[UIImage class]]) [paramsDict setObject:UIImagePNGRepresentation(images) forKey:CNLiveShareImage];
    [paramsDict setObject:[self check:url] forKey:CNLiveShareURL];
    [paramsDict setObject:[self check:desc] forKey:CNLiveShareDesc];
    [paramsDict setObject:[self check:userName] forKey:CNLiveShareUName];
    [paramsDict setObject:[self check:path] forKey:CNLiveSharePath];
    [paramsDict setObject:[NSNumber numberWithBool:isTicket] forKey:CNLiveShareTickt];
    [paramsDict setObject:[NSNumber numberWithInt:contentType] forKey:CNLiveShareConTy];
    return paramsDict;
}
-(NSString *)check:(NSString *)originalString
{
    NSString * s = [originalString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString * tempString = @"";
    if (s.length == 0
        || s == nil
        || s == NULL
        || [s isEqualToString:@""]) {
        return tempString;
    }
    return originalString;
}
#pragma mark - 调起分享
+ (void)share:(CNLiveSharePlatformType)platformType Params:(NSDictionary *)params RecvStatusBlock:(DidRecvStatueBlock)statueBlock
{
    if (platformType == CNLiveSharePlatformTypeAll
        || platformType == CNLiveSharePlatformTypeSafari
        || platformType == CNLiveSharePlatformTypeWjjLive
        || platformType == CNLiveSharePlatformTypeWjjFriend) return;
    
    [CNLiveShareImageManager manager].statueBlock = ^(CNLiveShareStatue statue) {
        if (statueBlock) statueBlock(statue);
    };
    
    switch (platformType) {
        case CNLiveSharePlatformTypeWeChat:
        {
            [CNLiveShareExtension shareWithWXFriend:params isSession:YES CompleterBlock:^(BOOL isSuccess) {
                if (statueBlock && !isSuccess) statueBlock(CNLiveShareStatueFail);
            }];
        }
            break;
        case CNLiveSharePlatformTypeCricle:
        {
            [CNLiveShareExtension shareWithWXFriend:params isSession:NO CompleterBlock:^(BOOL isSuccess) {
                if (statueBlock && !isSuccess) statueBlock(CNLiveShareStatueFail);
            }];
        }
            break;
        case CNLiveSharePlatformTypeQQFriend:
        {
            [CNLiveShareExtension shareWithQQFriend:params CompleterBlock:^(BOOL isSuccess) {
                if (statueBlock && !isSuccess) statueBlock(CNLiveShareStatueFail);
            }];
        }
            break;
        case CNLiveSharePlatformTypeSina:
        {
            [CNLiveShareExtension shareWithWBFriend:params CompleterBlock:^(BOOL isSuccess) {
                if (statueBlock && !isSuccess) statueBlock(CNLiveShareStatueFail);
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 回调方法
-(void) onResp:(BaseResp*)resp
{
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        if ([resp isKindOfClass:[SendAuthResp class]]) {
            if (resp.errCode == 0) {
                SendAuthResp * authResp = (SendAuthResp *)resp;
                NSArray * keys = [NSArray arrayWithObjects:@"appid", @"secret", @"code", @"grant_type", nil];
                NSArray * values = [NSArray arrayWithObjects:WeiChatAppId_Share, WeiChatAppSecret_Share, authResp.code, @"authorization_code", nil];
                NSDictionary * param = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
                [CNLiveNetworking setAllowRequestDefaultArgument:NO];
                [CNLiveNetworking requestNetworkWithMethod:CNLiveRequestMethodGET URLString:@"https://api.weixin.qq.com/sns/oauth2/access_token" Param:param CacheType:CNLiveNetworkCacheTypeNetworkOnly CompletionBlock:^(NSURLSessionTask *requestTask, id responseObject, NSError *error) {
                    if (!error && ![responseObject isKindOfClass:[NSNull class]] && responseObject != nil && [responseObject isKindOfClass:[NSDictionary class]]) {
                        NSArray * subKeys = [NSArray arrayWithObjects:@"access_token", @"expires_in", @"refresh_token", @"openid", @"scope", nil];
                        NSArray * subValues = [NSArray arrayWithObjects:responseObject[@"access_token"], [NSString stringWithFormat:@"%@",responseObject[@"expires_in"]], responseObject[@"refresh_token"], responseObject[@"openid"], @"snsapi_userinfo", nil];
                        NSDictionary * subParam = [[NSDictionary alloc] initWithObjects:subValues forKeys:subKeys];
                        [CNLiveNetworking setAllowRequestDefaultArgument:NO];
                        [CNLiveNetworking requestNetworkWithMethod:CNLiveRequestMethodGET URLString:@"https://api.weixin.qq.com/sns/userinfo" Param:subParam CacheType:CNLiveNetworkCacheTypeNetworkOnly CompletionBlock:^(NSURLSessionTask *requestTask, id responseObject, NSError *error) {
                            if (!error) {
                                NSString * sex = @"n";
                                if ([responseObject[@"sex"] integerValue] == 1) {
                                    sex = @"m";
                                }
                                if ([responseObject[@"sex"] integerValue] == 2) {
                                    sex = @"f";
                                }
                                CNLiveThirdPartyModel * userInfo = [[CNLiveThirdPartyModel alloc] initWithNickName:responseObject[@"nickname"] Gender:sex Location:responseObject[@"city"] FaceUrl:responseObject[@"headimgurl"] PartyId:responseObject[@"unionid"]];
                                if (self.sendAuthBlock) self.sendAuthBlock(CNLiveSendAuthRespWX, userInfo, nil);
                            }else{
                                if (self.sendAuthBlock) self.sendAuthBlock(CNLiveSendAuthRespWX, nil, error);
                            }
                        }];
                    }else{
                        if (self.sendAuthBlock) self.sendAuthBlock(CNLiveSendAuthRespWX, nil, error);
                    }
                }];

            }else if (resp.errCode == WXErrCodeUserCancel) {
                NSError * error = [NSError errorWithDomain:@"用户取消登录" code:10000 userInfo:nil];
                if (self.sendAuthBlock) self.sendAuthBlock(CNLiveSendAuthRespWX, nil, error);
            }else{
                NSError * error = [NSError errorWithDomain:CNLiveStringIsEmpty(resp.errStr)?@"获取失败":resp.errStr code:resp.errCode userInfo:nil];
                if (self.sendAuthBlock) self.sendAuthBlock(CNLiveSendAuthRespWX, nil, error);
            }
        }
    }else{
        if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
            if (self.statueBlock) self.statueBlock(CNLiveShareStatueSuccess);
        } else if ([resp isKindOfClass:[SendAuthResp class]]) {
            if (self.statueBlock) self.statueBlock(CNLiveShareStatueSuccess);
        } else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {
            if (self.statueBlock) self.statueBlock(CNLiveShareStatueSuccess);
        } else if ([resp isKindOfClass:[SendMessageToQQResp class]]) {
            SendMessageToQQResp * sendQQResp = (SendMessageToQQResp *)resp;
            if ([sendQQResp.result isEqualToString:@"0"]) {
                if (self.statueBlock) self.statueBlock(CNLiveShareStatueSuccess);
                return;
            }
            if ([sendQQResp.result isEqualToString:@"-4"]) {
                if (self.statueBlock) self.statueBlock(CNLiveShareStatueCancel);
                return;
            }
            if (self.statueBlock) self.statueBlock(CNLiveShareStatueFail);
        }
    }
}
-(void) onReq:(BaseReq*)req{}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class]) {
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            NSArray * arr = [NSArray arrayWithObjects:[(WBAuthorizeResponse *)response accessToken], [(WBAuthorizeResponse *)response userID],nil];
            NSArray * arr1 = [NSArray arrayWithObjects:@"access_token",@"uid", nil];
            NSDictionary *dic = [[NSDictionary alloc]initWithObjects:arr forKeys:arr1];
            [CNLiveNetworking setAllowRequestDefaultArgument:NO];
            [CNLiveNetworking requestNetworkWithMethod:CNLiveRequestMethodGET URLString:@"https://api.weibo.com/2/users/show.json" Param:dic CacheType:CNLiveNetworkCacheTypeNetworkOnly CompletionBlock:^(NSURLSessionTask *requestTask, id responseObject, NSError *error) {
                if (!error) {
                    CNLiveThirdPartyModel * userInfo = [[CNLiveThirdPartyModel alloc] initWithNickName:responseObject[@"name"] Gender:[NSString stringWithFormat:@"%@",responseObject[@"gender"]] Location:responseObject[@"location"] FaceUrl:responseObject[@"avatar_large"] PartyId:responseObject[@"idstr"]];
                    if (self.sendAuthBlock) self.sendAuthBlock(CNLiveSendAuthRespWB, userInfo, nil);
                }else{
                    if (self.sendAuthBlock) self.sendAuthBlock(CNLiveSendAuthRespWB, nil, error);
                }
            }];
        }else if (response.statusCode == WeiboSDKResponseStatusCodeUserCancel) {
            NSError * error = [NSError errorWithDomain:@"用户取消登录" code:10000 userInfo:nil];
            self.sendAuthBlock(CNLiveSendAuthRespWB, nil, error);
        }else{
            NSError * error = [NSError errorWithDomain:@"登录失败" code:-1009 userInfo:nil];
            self.sendAuthBlock(CNLiveSendAuthRespWB, nil, error);
        }
    }else{
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            if (self.statueBlock) self.statueBlock(CNLiveShareStatueSuccess);
        }else if (response.statusCode == WeiboSDKResponseStatusCodeUserCancel) {
            if (self.statueBlock) self.statueBlock(CNLiveShareStatueCancel);
        }else{
            if (self.statueBlock) self.statueBlock(CNLiveShareStatueFail);
        }
    }
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

- (void)isOnlineResponse:(NSDictionary *)response {
    NSLog(@"qq");
}

- (void)tencentDidLogin {
    if ([CNLiveShareImageManager manager].auth.accessToken.length > 0) {
        // 获取用户信息
        self.isAuthQQ = [[CNLiveShareImageManager manager].auth getUserInfo];
    } else {
        self.isAuthQQ = NO;
    }
}
- (void)getUserInfoResponse:(APIResponse *)response
{
    if (response && response.retCode == URLREQUEST_SUCCEED && self.sendAuthBlock) {

        if (self.isAuthQQ) {
            NSString * sex = [NSString stringWithFormat:@"%@",[response jsonResponse][@"gender"]];
            if ([sex isEqualToString:@"男"]) {
                sex = @"m";
            }
            if ([sex isEqualToString:@"女"]) {
                sex = @"f";
            }
            if (![sex isEqualToString:@"男"] && ![sex isEqualToString:@"女"]) {
                sex = @"n";
            }
            CNLiveThirdPartyModel * userInfo = [[CNLiveThirdPartyModel alloc] initWithNickName:[response jsonResponse][@"nickname"] Gender:sex Location:[response jsonResponse][@"city"] FaceUrl:[response jsonResponse][@"figureurl_qq_1"] PartyId:[[CNLiveShareImageManager manager].auth openId]];
            if (self.sendAuthBlock) self.sendAuthBlock(CNLiveSendAuthRespQQ, userInfo, nil);
        }else{
            NSError * error = [NSError errorWithDomain:response.errorMsg code:response.detailRetCode userInfo:nil];
            if (self.sendAuthBlock) self.sendAuthBlock(CNLiveSendAuthRespQQ, nil, error);
        }
    } else {
        if (self.sendAuthBlock) {
            NSError * error = [NSError errorWithDomain:response.errorMsg code:response.detailRetCode userInfo:nil];
            if (self.sendAuthBlock) self.sendAuthBlock(CNLiveSendAuthRespQQ, nil, error);
        }
    }
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    if (cancelled) {
        NSError * error = [NSError errorWithDomain:@"用户取消登录" code:10000 userInfo:nil];
        if (self.sendAuthBlock) self.sendAuthBlock(CNLiveSendAuthRespQQ, nil, error);
    } else {
        NSError * error = [NSError errorWithDomain:@"登录失败" code:-1009 userInfo:nil];
        if (self.sendAuthBlock) self.sendAuthBlock(CNLiveSendAuthRespQQ, nil, error);
    }
}

- (void)tencentDidNotNetWork {
    NSError * error = [NSError errorWithDomain:@"登录失败" code:-1009 userInfo:nil];
    if (self.sendAuthBlock) self.sendAuthBlock(CNLiveSendAuthRespQQ, nil, error);
}
#pragma mark - 调起三方登录
+(void)send:(CNLiveSendAuthResp)authType authRespBlock:(DidSendAuthBlock)authBlock
{
    if (authType == CNLiveSendAuthRespWX) {
        SendAuthReq* req =[[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo" ;
        req.state = @"123" ;
        [WXApi sendReq:req];
    }
    if (authType == CNLiveSendAuthRespQQ) {
        NSArray * permissions = [NSArray arrayWithObjects:@"get_user_info",@"get_simple_userinfo", @"add_t", nil];
        [[CNLiveShareImageManager manager].auth authorize:permissions];
    }
    if (authType == CNLiveSendAuthRespWB) {
        WBAuthorizeRequest * request = [WBAuthorizeRequest request];
        request.redirectURI = @"http://wjjh5.cnlive.com/apkdownload.php";
        request.scope = @"all";
        [WeiboSDK sendRequest:request];
    }
    
    [CNLiveShareImageManager manager].sendAuthBlock = authBlock;
}
-(void)setAuth:(TencentOAuth *)auth
{
    _auth = auth;
}
@end
