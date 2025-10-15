//
//  CNLiveShareManager.h
//  CNLiveShareTool
//
//  Created by 流诗语 on 2018/11/28.
//  Copyright © 2018年 group. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CNLiveShareResultType) {
    CNLiveShareResultTypeStart,
    CNLiveShareResultTypeSucc,
    CNLiveShareResultTypeCanc,
    CNLiveShareResultTypeFail,
    CNLiveShareResultTypeUnKnow,
};
typedef NS_ENUM(NSUInteger, CNLiveSharePlatformType) {
    CNLiveSharePlatformTypeAll,
    CNLiveSharePlatformTypeWjjFriend,
    CNLiveSharePlatformTypeWjjLive,
    CNLiveSharePlatformTypeWeChat,
    CNLiveSharePlatformTypeCricle,
    CNLiveSharePlatformTypeQQFriend,
    CNLiveSharePlatformTypeSina,
    CNLiveSharePlatformTypeSafari,
};

@protocol CNLiveShareManagerDelegate <NSObject>

-(void)shareWithPlatformType:(CNLiveSharePlatformType)fromType
                   ShareName:(NSString *)shareName
                   ShareDesc:(NSString *)shareDesc
                    ShareUrl:(NSString *)ShareUrl
                  ShareImage:(id)shareImage
                        Full:(BOOL)isFull
                   ShareType:(NSInteger)shareType;

@end

@interface CNLiveShareManager : NSObject

/// 初始化单利模式
+(CNLiveShareManager *)shareDefaultsManager;

@property (nonatomic, assign) BOOL isShare;

@property (nonatomic, weak) id<CNLiveShareManagerDelegate>delegate;

/**在工程初始时调用该方法进行注册*/
+(void)registeredShareViewWhenDidFinishLaunch;

/**
 调用分享界面进行分享操作
 
 @param shareTitle 分享标题
 @param shareUrl 分享的链接
 @param shareDesc 分享的描述
 @param shareImage 图片集合,传入参数可以为单张图片信息，也可以为一个NSArray，数组元素可以为UIImage、NSString（图片路径）、NSURL（图片路径）
 @param isFull 是否横屏显示分享界面
 @param isHiddenWjj 是否隐藏网加加
 @param platformType 分享平台调用某个单独方法(CNLiveSharePlatformTypeAll 类型为已实现界面,默认为此类型)
 @param completerBlock 分享结果回调
 */
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
                          TouchActionBlock:(void(^)(NSString * title))resultBlock
                            CompleterBlock:(void(^)(CNLiveShareResultType resultType,CNLiveSharePlatformType platformType,NSString * typtString))completerBlock;



/**
 添加分享视图底部栏按钮
 
 @param shareTitle 分享标题
 @param shareUrl 分享链接
 @param shareDesc 分享描述
 @param shareImage 图片集合,传入参数可以为单张图片信息，也可以为一个NSArray，数组元素可以为UIImage、NSString（图片路径）、NSURL（图片路径）
 @param isFull 是否横屏显示分享界面
 @param image 底部按钮的图片
 @param title 底部按钮的标题
 @param platformType 分享类型
 @param resultBlock 点击底部按钮回调
 @param completerBlock 分享结果回调
 */
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
                                        TouchTopActionBlock:(void(^)(NSString * title))resultTopBlock
                                           TouchActionBlock:(void(^)(NSString * title))resultBlock
                                             CompleterBlock:(void(^)(CNLiveShareResultType resultType,CNLiveSharePlatformType platformType,NSString * typtString))completerBlock;

/**
 调用分享界面进行分享操作(带微信小程序)
 
 @param shareTitle 分享标题
 @param shareUrl 分享的链接
 @param shareDesc 分享的描述
 @param mProgramId 小程序 id
 @param path 小程序地址
 @param shareImage 图片集合,传入参数可以为单张图片信息，也可以为一个NSArray，数组元素可以为UIImage、NSString（图片路径）、NSURL（图片路径）
 @param isFull 是否横屏显示分享界面
 @param isHiddenWjj 是否隐藏网加加
 @param isShareWXMiniProgram 是否可以分享微信小程序
 @param isCanShareSafari 是否可以跳转safari
 @param platformType 分享平台调用某个单独方法(CNLiveSharePlatformTypeAll 类型为已实现界面,默认为此类型)
 @param completerBlock 分享结果回调
 */
+(void)showShareWeChatMiniProgramViewWithParamForShareTitle:(NSString *)shareTitle
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
                                             CompleterBlock:(void(^)(CNLiveShareResultType resultType,CNLiveSharePlatformType platformType,NSString * typtString))completerBlock;


@end

