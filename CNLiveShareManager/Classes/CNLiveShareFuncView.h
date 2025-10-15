//
//  CNLiveShareFuncView.h
//  CNLiveShareTool
//
//  Created by 流诗语 on 2018/11/28.
//  Copyright © 2018年 group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNLiveShareManager.h"

typedef NS_ENUM(NSInteger, CNLiveShareShowType){
    CNLiveShareShowTypeForwarding = 0, // 转发
    CNLiveShareShowTypeShare      = 1, //分享链接
    CNLiveShareShowTypeImage      = 2, //图片分享
    CNLiveShareShowTypeVideo      = 3, //视频分享
    CNLiveShareShowTypeCard       = 4, //发送个人名片
    CNLiveShareShowTypeFile       = 5, //文件分享
    CNLiveShareShowTypeGoods      = 6, //电商商品分享
};

@interface CNLiveShareFuncView : UIView

/**
 初始化f分享界面

 @param shareName 分享标题
 @param shareUrl 分享链接
 @param shareDesc 分享描述
 @param shareImage 分享图片
 @param platformType 分享类型
 @param isFull 是否全屏
 @param isWXMiniProgram 是否带微信小程序
 @param isHiddenWjj 是否全屏
 @return 返回
 */
- (instancetype)initWithShareName:(NSString *)shareName
                         ShareUrl:(NSString *)shareUrl
                        ShareDesc:(NSString *)shareDesc
                       ShareImage:(id)shareImage
                     PlatformType:(CNLiveSharePlatformType)platformType
                           isFull:(BOOL)isFull
                  isWXMiniProgram:(BOOL)isWXMiniProgram
                        HiddenWjj:(BOOL)isHiddenWjj
                         HiddenQQ:(BOOL)isHiddenQQ
                         HiddenWB:(BOOL)isHiddenWB
                     HiddenWechat:(BOOL)isHiddenWechat
                     HiddenSafari:(BOOL)isHiddenSafari;

/**
 添加底部框相关按钮

 @param images 底部按钮图片
 @param titles 底部按钮名称
 @param completerBlock 点击事件回调
 */
-(void)addBottemButtomsImage:(NSArray<NSString *> *)images
                      Titles:(NSArray<NSString *> *)titles
              CompleterBlock:(void (^)(NSString *))completerBlock;

/**
 在首行添加自定义按钮

 @param images 顶部按钮图片
 @param titles 顶部按钮名称
 @param completerBlock 点击事件回调
 */
-(void)addTopButtomsImage:(NSArray<NSString *> *)images
                      Titles:(NSArray<NSString *> *)titles
              CompleterBlock:(void (^)(NSString *))completerBlock;

/**
 添加微信小程序分享时参数

 @param mProgramId 小程序 ID
 @param path 访问路径
 @param isTicket 是否使用带 shareTicket 的转发
 @param isCanShareSafari 是否可以跳转 safari
 @param miniProgramType 分享小程序的版本（0-正式，1-开发，2-体验)
 */
-(void)addShareWeChatMiniProgramForParamDict:(NSString *)mProgramId
                                        Path:(NSString *)path
                                 ShareTicket:(BOOL)isTicket
                            isCanShareSafari:(BOOL)isCanShareSafari
                             MiniProgramType:(NSInteger)miniProgramType
                                    ShowType:(CNLiveShareShowType)showType;

@property (nonatomic, copy) void(^touchNetAddBlock)(CNLiveSharePlatformType fromType,NSString * shareTitle,id shareImage,NSString * shareDesc,NSString * shareUrl,NSInteger number,BOOL isFull);

/**
 分享调起时进行回调,一般用来统计分享功能
 */
@property (copy, nonatomic) void(^shareResultBlock)(CNLiveShareResultType resultType,CNLiveSharePlatformType platformType,NSString * typtString);

/**
 显示分享界面
 */
- (void)show;

/**
 隐藏分享界面
 */
- (void)dismiss;

@end
