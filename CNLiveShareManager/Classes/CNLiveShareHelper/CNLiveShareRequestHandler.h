//
//  CNLiveShareRequestHandler.h
//  CNLiveNetAdd
//
//  Created by 流诗语 on 2019/5/7.
//  Copyright © 2019年 cnlive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
@interface CNLiveShareRequestHandler : NSObject

#pragma mark - 微信相关方法的调用

/**
 分享文字内容到微信

 @param text 文本
 @param scene 好友&朋友圈
 @return 失败&成功
 */
+ (BOOL)sendText:(NSString *)text
         InScene:(enum WXScene)scene;

/**
 分享图片内容到微信

 @param imageData 图片内容数据
 @param tagName 标签内容
 @param messageExt 消息扩展
 @param action 动作
 @param thumbImage 占位图
 @param scene 好友&朋友圈
 @return 失败&成功
 */
+ (BOOL)sendImageData:(NSData *)imageData
              TagName:(NSString *)tagName
           MessageExt:(NSString *)messageExt
               Action:(NSString *)action
           ThumbImage:(UIImage *)thumbImage
              InScene:(enum WXScene)scene;

/**
 分享链接内容到微信

 @param urlString 内容地址
 @param tagName 标签内容
 @param title 分享标题
 @param description 分享描述
 @param thumbImage 分享图片占位
 @param scene 好友&朋友圈
 @return 失败&成功
 */
+ (BOOL)sendLinkURL:(NSString *)urlString
            TagName:(NSString *)tagName
              Title:(NSString *)title
        Description:(NSString *)description
         ThumbImage:(UIImage *)thumbImage
            InScene:(enum WXScene)scene;

/**
 分享音乐内容到微信

 @param musicURL 音乐地址
 @param dataURL 音乐数据地址
 @param title 分享标题
 @param description 分享描述
 @param thumbImage 分享图片占位
 @param scene 好友&朋友圈
 @return 失败&成功
 */
+ (BOOL)sendMusicURL:(NSString *)musicURL
             dataURL:(NSString *)dataURL
               Title:(NSString *)title
         Description:(NSString *)description
          ThumbImage:(UIImage *)thumbImage
             InScene:(enum WXScene)scene;

/**
 分享视频内容到微信

 @param videoURL 视频地址
 @param title 分享标题
 @param description 分享描述
 @param thumbImage 分享图片占位
 @param scene 好友&朋友圈
 @return 失败&成功
 */
+ (BOOL)sendVideoURL:(NSString *)videoURL
               Title:(NSString *)title
         Description:(NSString *)description
          ThumbImage:(UIImage *)thumbImage
             InScene:(enum WXScene)scene;

/**
 分享表情内容到微信

 @param emotionData 表情数据
 @param thumbImage 分享图片占位
 @param scene 好友&朋友圈
 @return 失败&成功
 */
+ (BOOL)sendEmotionData:(NSData *)emotionData
             ThumbImage:(UIImage *)thumbImage
                InScene:(enum WXScene)scene;

/**
 分享文件内容到微信

 @param fileData 文件数据
 @param extension 文件数据扩展
 @param title 分享标题
 @param description 分享描述
 @param thumbImage 分享图片占位
 @param scene 好友&朋友圈
 @return 失败&成功
 */
+ (BOOL)sendFileData:(NSData *)fileData
       fileExtension:(NSString *)extension
               Title:(NSString *)title
         Description:(NSString *)description
          ThumbImage:(UIImage *)thumbImage
             InScene:(enum WXScene)scene;

/**
 分享 app 内容到微信

 @param data app 数据
 @param info 扩展附加信息
 @param url 扩展附加连接
 @param title 分享标题
 @param description 分享描述
 @param messageExt 消息扩展
 @param action 动作
 @param thumbImage 占位图
 @param scene 好友&朋友圈
 @return 失败&成功
 */
+ (BOOL)sendAppContentData:(NSData *)data
                   ExtInfo:(NSString *)info
                    ExtURL:(NSString *)url
                     Title:(NSString *)title
               Description:(NSString *)description
                MessageExt:(NSString *)messageExt
             MessageAction:(NSString *)action
                ThumbImage:(UIImage *)thumbImage
                   InScene:(enum WXScene)scene;

/**
 分享小程序内容到微信

 @param programId 小程序 ID
 @param path 连接
 @param urlString 地址
 @param image 图片
 @param title 标题
 @param description 描述
 @param ticket 是否转发
 @return 失败&成功
 */
+ (BOOL)sendMiniProgram:(NSString *)programId
                   Path:(NSString *)path
              URLString:(NSString *)urlString
             ThumbImage:(UIImage *)image
                  Title:(NSString *)title
            Description:(NSString *)description
                 Ticket:(BOOL)ticket;

+ (BOOL)addCardsToCardPackage:(NSArray *)cardIds;

+ (BOOL)sendAuthRequestScope:(NSString *)scope
                       State:(NSString *)state
                      OpenID:(NSString *)openID
            InViewController:(UIViewController *)viewController;

+ (BOOL)jumpToBizWebviewWithAppID:(NSString *)appID
                      Description:(NSString *)description
                        tousrname:(NSString *)tousrname
                           ExtMsg:(NSString *)extMsg;

#pragma mark - QQ的相关方法调用

/**
 分享文字内容到 QQ

 @param text 文字内容
 @return 成功&失败
 */
+ (BOOL)sendQQText:(NSString *)text;

/**
 分享图片内容到 QQ

 @param imageData 真是图片资源
 @param thumbData 预览图
 @param title 标题
 @param description 描述
 @return 成功&失败
 */
+ (BOOL)sendQQImageData:(NSData *)imageData
         ThumbImageData:(NSData *)thumbData
                  title:(NSString*)title
            description:(NSString*)description;

/**
 分享链接内容到 QQ

 @param url 内容地址
 @param title 标题
 @param description 描述
 @param data 预览图片
 @param targetContentType 分享显示类型
 @return 成功&失败
 */
+ (BOOL)sendQQLinkWithURL:(NSURL*)url
                    title:(NSString*)title
              description:(NSString*)description
         previewImageData:(NSData*)data
        targetContentType:(QQApiURLTargetType)targetContentType;

/**
 分享音乐内容到 QQ

 @param url 音频内容的目标URL
 @param title 分享内容的标题
 @param description 分享内容的描述
 @param data 分享内容的预览图像
 */
+ (BOOL)sendQQMusicWithURL:(NSURL*)url
                     title:(NSString*)title
               description:(NSString*)description
          previewImageData:(NSData*)data;

/**
 分享视频内容到 QQ

 @param url 视频内容的目标URL
 @param title 分享内容的标题
 @param description 分享内容的描述
 @param data 分享内容的预览图像
 @return 成功&失败
 */
+ (BOOL)sendQQVideoWithURL:(NSURL*)url
                     title:(NSString*)title
               description:(NSString*)description
          previewImageData:(NSData*)data;

#pragma mark - 微博的相关方法调用

/**
  分享文字内容到 微博

 @param text 分享文字内容
 @return 成功&失败
 */
+(BOOL)sendWBText:(NSString *)text;

/**
 分享图片内容到 微博
 
 @param imageData 真是图片资源
 @param thumbData 预览图
 @param title 标题
 @param description 描述
 @return 成功&失败
 */
+ (BOOL)sendWBImageData:(NSData *)imageData
         ThumbImageData:(NSData *)thumbData
                  title:(NSString*)title
            description:(NSString*)description;

/**
 分享链接内容到 微博
 
 @param url 内容地址
 @param title 标题
 @param description 描述
 @param data 预览图片
 @return 成功&失败
 */
+ (BOOL)sendWBLinkWithURL:(NSString*)url
                    title:(NSString*)title
              description:(NSString*)description
         previewImageData:(NSData*)data;
@end
