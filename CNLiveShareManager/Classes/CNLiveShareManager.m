//
//  CNLiveShareManager.m
//  CNLiveShareTool
//
//  Created by 流诗语 on 2018/11/28.
//  Copyright © 2018年 group. All rights reserved.
//

#import "CNLiveShareManager.h"
#import "CNLiveShareImageManager.h"
#import "CNLiveShareToolDefine.h"
#import "CNLiveShareFuncView.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import <CNLiveEnvironment/CNLiveEnvironment.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

@implementation CNLiveShareManager

+(CNLiveShareManager *)shareDefaultsManager
{
    static CNLiveShareManager * shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[CNLiveShareManager alloc] init];
    });
    return shareManager;
}

#pragma mark -

+(void)registeredShareViewWhenDidFinishLaunch;
{
    TencentOAuth * auth = [[TencentOAuth alloc] initWithAppId:QQShareAppId_Share andDelegate:[CNLiveShareImageManager manager]];
    
    auth.sessionDelegate = [CNLiveShareImageManager manager];
    
    [WXApi registerApp:WeiChatAppId_Share];
    
    [WeiboSDK registerApp:WeiBoShareAppKey_Share];
    
    [CNLiveShareImageManager manager].auth = auth;
    
    NSLog(@"上次获取的 token => %@",[auth accessToken]);
}
#pragma mark - 默认视图
+(void)showShareViewWithParamForShareTitle:(NSString *)shareTitle
                                  ShareUrl:(NSString *)shareUrl
                                 ShareDesc:(NSString *)shareDesc
                                ShareImage:(id)shareImage
                                ScreenFull:(BOOL)isFull
                                 HiddenWjj:(BOOL)isHiddenWjj
                                  HiddenQQ:(BOOL)isHiddenQQ
                                  HiddenWB:(BOOL)isHiddenWB
                              HiddenWechat:(BOOL)isHiddenWechat
                              HiddenSafari:(BOOL)isHiddenSafari
                                  TopImage:(NSArray<NSString *> *)topImage
                                 TopTitles:(NSArray<NSString *> *)topTitle
                              PlatformType:(CNLiveSharePlatformType)platformType
                          TouchActionBlock:(void (^)(NSString *))resultBlock
                            CompleterBlock:(void (^)(CNLiveShareResultType, CNLiveSharePlatformType, NSString *))completerBlock
{
    if ([CNLiveShareManager isURL:shareUrl]) NSLog(@"CNLiveShareTool 分享链接可能不是URL");
    
    if ([shareImage isKindOfClass:[UIImage class]] || [shareImage isKindOfClass:[NSArray class]] || [shareImage isKindOfClass:[NSString class]] || [shareImage isKindOfClass:[NSURL class]]) {
        CNLiveShareFuncView * shareFuncView = [[CNLiveShareFuncView alloc] initWithShareName:shareTitle ShareUrl:shareUrl ShareDesc:shareDesc ShareImage:shareImage PlatformType:platformType isFull:isFull isWXMiniProgram:NO HiddenWjj:isHiddenWjj HiddenQQ:isHiddenQQ HiddenWB:isHiddenWB HiddenWechat:isHiddenWechat HiddenSafari:isHiddenSafari];
        [shareFuncView addTopButtomsImage:topImage Titles:topTitle CompleterBlock:resultBlock];
        completerBlock = shareFuncView.shareResultBlock;
        shareFuncView.touchNetAddBlock = ^(CNLiveSharePlatformType fromType,NSString *shareTitle, id shareImage, NSString *shareDesc, NSString *shareUrl, NSInteger number, BOOL isFull) {
            if ([[CNLiveShareManager shareDefaultsManager].delegate respondsToSelector:@selector(shareWithPlatformType:ShareName:ShareDesc:ShareUrl:ShareImage:Full:ShareType:)]) {
                [[CNLiveShareManager shareDefaultsManager].delegate shareWithPlatformType:fromType ShareName:shareTitle ShareDesc:shareDesc ShareUrl:shareUrl ShareImage:shareImage Full:isFull ShareType:number];
            }
        };
        [shareFuncView show];
    }else{
        NSLog(@"暂不支持该类型图片的分享");
    }
}

#pragma mark - 底部添加按钮视图视图
+(void)showShareViewWithBottemViewButtonsParamForShareTitle:(NSString *)shareTitle
                                                   ShareUrl:(NSString *)shareUrl
                                                  ShareDesc:(NSString *)shareDesc
                                                 ShareImage:(id)shareImage
                                                 ScreenFull:(BOOL)isFull
                                                  HiddenWjj:(BOOL)isHiddenWjj
                                                   HiddenQQ:(BOOL)isHiddenQQ
                                                   HiddenWB:(BOOL)isHiddenWB
                                               HiddenWechat:(BOOL)isHiddenWechat
                                               HiddenSafari:(BOOL)isHiddenSafari
                                                   TopImage:(NSArray<NSString *> *)topImage
                                                  TopTitles:(NSArray<NSString *> *)topTitle
                                                      Image:(NSArray<NSString *> *)image
                                                     Titles:(NSArray<NSString *> *)title
                                               PlatformType:(CNLiveSharePlatformType)platformType
                                        TouchTopActionBlock:(void (^)(NSString *))resultTopBlock TouchActionBlock:(void (^)(NSString *))resultBlock
                                             CompleterBlock:(void (^)(CNLiveShareResultType, CNLiveSharePlatformType, NSString *))completerBlock
{
    if ([CNLiveShareManager isURL:shareUrl]) NSLog(@"CNLiveShareTool 分享链接可能不是URL");
    
    if ([shareImage isKindOfClass:[UIImage class]] || [shareImage isKindOfClass:[NSArray class]] || [shareImage isKindOfClass:[NSString class]] || [shareImage isKindOfClass:[NSURL class]]) {
        
        CNLiveShareFuncView * shareFuncView = [[CNLiveShareFuncView alloc] initWithShareName:shareTitle ShareUrl:shareUrl ShareDesc:shareDesc ShareImage:shareImage PlatformType:platformType isFull:isFull isWXMiniProgram:NO HiddenWjj:isHiddenWjj HiddenQQ:isHiddenQQ HiddenWB:isHiddenWB HiddenWechat:isHiddenWechat HiddenSafari:isHiddenSafari];
        [shareFuncView addTopButtomsImage:topImage Titles:topTitle CompleterBlock:resultTopBlock];
        [shareFuncView addBottemButtomsImage:image Titles:title CompleterBlock:resultBlock];
        completerBlock = shareFuncView.shareResultBlock;
        shareFuncView.touchNetAddBlock = ^(CNLiveSharePlatformType fromType,NSString *shareTitle, id shareImage, NSString *shareDesc, NSString *shareUrl, NSInteger number, BOOL isFull) {
            if ([[CNLiveShareManager shareDefaultsManager].delegate respondsToSelector:@selector(shareWithPlatformType:ShareName:ShareDesc:ShareUrl:ShareImage:Full:ShareType:)]) {
                [[CNLiveShareManager shareDefaultsManager].delegate shareWithPlatformType:fromType ShareName:shareTitle ShareDesc:shareDesc ShareUrl:shareUrl ShareImage:shareImage Full:isFull ShareType:number];
            }
        };
        [shareFuncView show];
    }else{
        NSLog(@"暂不支持该类型图片的分享");
    }
}
+ (void)showShareWeChatMiniProgramViewWithParamForShareTitle:(NSString *)shareTitle
                                                    ShareUrl:(NSString *)shareUrl
                                                   ShareDesc:(NSString *)shareDesc
                                               MiniProgramId:(NSString *)mProgramId
                                                        Path:(NSString *)path
                                                  ShareImage:(id)shareImage
                                                  ScreenFull:(BOOL)isFull
                                                   ShareType:(NSInteger)shareType
                                                   HiddenWjj:(BOOL)isHiddenWjj
                                        isShareWXMiniProgram:(BOOL)isShareWXMiniProgram
                                            isCanShareSafari:(BOOL)isCanShareSafari
                                                PlatformType:(CNLiveSharePlatformType)platformType
                                              CompleterBlock:(void (^)(CNLiveShareResultType, CNLiveSharePlatformType, NSString *))completerBlock
{
    //    if ([[DSCnliveShopSDKManager sharedManager].skip checkShareTypeByShareUrl:self.shareUrl] == 1
    //        || [[DSCnliveShopSDKManager sharedManager].skip checkShareTypeByShareUrl:self.shareUrl] == 2) {
    //        self.shareType = CNTypeShareGoods;
    //    }else{
    //        self.shareType = CNTypeShare;
    //    }
    
    if ([CNLiveShareManager isURL:shareUrl]) NSLog(@"CNLiveShareTool 分享链接可能不是URL");
    
    if ([shareImage isKindOfClass:[UIImage class]] || [shareImage isKindOfClass:[NSArray class]] || [shareImage isKindOfClass:[NSString class]] || [shareImage isKindOfClass:[NSURL class]]) {
        
        CNLiveShareFuncView * shareFuncView = [[CNLiveShareFuncView alloc] initWithShareName:shareTitle ShareUrl:shareUrl ShareDesc:shareDesc ShareImage:shareImage PlatformType:platformType isFull:isFull isWXMiniProgram:isShareWXMiniProgram HiddenWjj:isHiddenWjj HiddenQQ:NO HiddenWB:NO HiddenWechat:NO HiddenSafari:isCanShareSafari];
        CNLiveShareShowType showType = CNLiveShareShowTypeShare;
        if (shareType == 0) {
            showType =  CNLiveShareShowTypeGoods;
        }
        [shareFuncView addShareWeChatMiniProgramForParamDict:mProgramId Path:path ShareTicket:YES isCanShareSafari:isCanShareSafari MiniProgramType:0 ShowType:showType];
        completerBlock = shareFuncView.shareResultBlock;
        shareFuncView.touchNetAddBlock = ^(CNLiveSharePlatformType fromType,NSString *shareTitle, id shareImage, NSString *shareDesc, NSString *shareUrl, NSInteger number, BOOL isFull) {
            if ([[CNLiveShareManager shareDefaultsManager].delegate respondsToSelector:@selector(shareWithPlatformType:ShareName:ShareDesc:ShareUrl:ShareImage:Full:ShareType:)]) {
                [[CNLiveShareManager shareDefaultsManager].delegate shareWithPlatformType:fromType ShareName:shareTitle ShareDesc:shareDesc ShareUrl:shareUrl ShareImage:shareImage Full:isFull ShareType:number];
            }
        };
        [shareFuncView show];
    }else{
        NSLog(@"暂不支持该类型图片的分享");
    }
}
#pragma mark - 判断是不是链接
+(BOOL)isURL:(NSString *)urlString
{
    if (urlString == nil) return NO;
    
    NSString *regulaUrlStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regexURL = [NSRegularExpression regularExpressionWithPattern:regulaUrlStr
                                                                              options:NSRegularExpressionCaseInsensitive
                                                                                error:nil];
    
    NSArray *arrayOfAllMatchesURL = [regexURL matchesInString:urlString options:0 range:NSMakeRange(0, urlString.length)];
    
    return arrayOfAllMatchesURL.count > 0;
}


@end
