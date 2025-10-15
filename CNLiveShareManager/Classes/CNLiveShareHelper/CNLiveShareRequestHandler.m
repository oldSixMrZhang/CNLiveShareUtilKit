//
//  CNLiveShareRequestHandler.m
//  CNLiveNetAdd
//
//  Created by 流诗语 on 2019/5/7.
//  Copyright © 2019年 cnlive. All rights reserved.
//

#import "CNLiveShareRequestHandler.h"
#import "WXMediaMessage+CNLiveShareWXMessage.h"
#import "SendMessageToWXReq+CNLiveShareWXRequest.h"
#import "CNLiveShareImageManager.h"
#import "WeiboSDK.h"
@implementation CNLiveShareRequestHandler

+ (BOOL)sendText:(NSString *)text
         InScene:(enum WXScene)scene {
    SendMessageToWXReq *req = [SendMessageToWXReq requestWithText:text
                                                   OrMediaMessage:nil
                                                            bText:YES
                                                          InScene:scene];
    return [WXApi sendReq:req];
}

+ (BOOL)sendImageData:(NSData *)imageData
              TagName:(NSString *)tagName
           MessageExt:(NSString *)messageExt
               Action:(NSString *)action
           ThumbImage:(UIImage *)thumbImage
              InScene:(enum WXScene)scene {
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = imageData;
    
    WXMediaMessage *message = [WXMediaMessage messageWithTitle:nil
                                                   Description:nil
                                                        Object:ext
                                                    MessageExt:messageExt
                                                 MessageAction:action
                                                    ThumbImage:thumbImage
                                                      MediaTag:tagName];
    
    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
                                                   OrMediaMessage:message
                                                            bText:NO
                                                          InScene:scene];
    
    return [WXApi sendReq:req];
}

+ (BOOL)sendLinkURL:(NSString *)urlString
            TagName:(NSString *)tagName
              Title:(NSString *)title
        Description:(NSString *)description
         ThumbImage:(UIImage *)thumbImage
            InScene:(enum WXScene)scene {
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = urlString;
    
    WXMediaMessage *message = [WXMediaMessage messageWithTitle:title
                                                   Description:description
                                                        Object:ext
                                                    MessageExt:nil
                                                 MessageAction:nil
                                                    ThumbImage:thumbImage
                                                      MediaTag:tagName];
    
    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
                                                   OrMediaMessage:message
                                                            bText:NO
                                                          InScene:scene];
    return [WXApi sendReq:req];
}

+ (BOOL)sendMusicURL:(NSString *)musicURL
             dataURL:(NSString *)dataURL
               Title:(NSString *)title
         Description:(NSString *)description
          ThumbImage:(UIImage *)thumbImage
             InScene:(enum WXScene)scene {
    WXMusicObject *ext = [WXMusicObject object];
    ext.musicUrl = musicURL;
    ext.musicDataUrl = dataURL;
    
    WXMediaMessage *message = [WXMediaMessage messageWithTitle:title
                                                   Description:description
                                                        Object:ext
                                                    MessageExt:nil
                                                 MessageAction:nil
                                                    ThumbImage:thumbImage
                                                      MediaTag:nil];
    
    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
                                                   OrMediaMessage:message
                                                            bText:NO
                                                          InScene:scene];
    
    return [WXApi sendReq:req];
}

+ (BOOL)sendVideoURL:(NSString *)videoURL
               Title:(NSString *)title
         Description:(NSString *)description
          ThumbImage:(UIImage *)thumbImage
             InScene:(enum WXScene)scene {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:thumbImage];
    
    WXVideoObject *ext = [WXVideoObject object];
    ext.videoUrl = videoURL;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
                                                   OrMediaMessage:message
                                                            bText:NO
                                                          InScene:scene];
    return [WXApi sendReq:req];
}

+ (BOOL)sendEmotionData:(NSData *)emotionData
             ThumbImage:(UIImage *)thumbImage
                InScene:(enum WXScene)scene {
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:thumbImage];
    
    WXEmoticonObject *ext = [WXEmoticonObject object];
    ext.emoticonData = emotionData;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
                                                   OrMediaMessage:message
                                                            bText:NO
                                                          InScene:scene];
    return [WXApi sendReq:req];
}

+ (BOOL)sendFileData:(NSData *)fileData
       fileExtension:(NSString *)extension
               Title:(NSString *)title
         Description:(NSString *)description
          ThumbImage:(UIImage *)thumbImage
             InScene:(enum WXScene)scene {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:thumbImage];
    
    WXFileObject *ext = [WXFileObject object];
    ext.fileExtension = @"pdf";
    ext.fileData = fileData;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
                                                   OrMediaMessage:message
                                                            bText:NO
                                                          InScene:scene];
    return [WXApi sendReq:req];
}

+ (BOOL)sendAppContentData:(NSData *)data
                   ExtInfo:(NSString *)info
                    ExtURL:(NSString *)url
                     Title:(NSString *)title
               Description:(NSString *)description
                MessageExt:(NSString *)messageExt
             MessageAction:(NSString *)action
                ThumbImage:(UIImage *)thumbImage
                   InScene:(enum WXScene)scene {
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.extInfo = info;
    ext.url = url;
    ext.fileData = data;
    
    WXMediaMessage *message = [WXMediaMessage messageWithTitle:title
                                                   Description:description
                                                        Object:ext
                                                    MessageExt:messageExt
                                                 MessageAction:action
                                                    ThumbImage:thumbImage
                                                      MediaTag:nil];
    
    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
                                                   OrMediaMessage:message
                                                            bText:NO
                                                          InScene:scene];
    return [WXApi sendReq:req];
    
}

+ (BOOL)sendMiniProgram:(NSString *)programId
                   Path:(NSString *)path
              URLString:(NSString *)urlString
             ThumbImage:(UIImage *)image
                  Title:(NSString *)title
            Description:(NSString *)description
                 Ticket:(BOOL)ticket
{
    WXMiniProgramObject * programObject = [WXMiniProgramObject object];
    programObject.webpageUrl = urlString;
    programObject.userName = programId;
    programObject.path = path;
    programObject.hdImageData = UIImageJPEGRepresentation(image, 0.5);
    programObject.withShareTicket = ticket;
    
    WXMediaMessage *message = [WXMediaMessage messageWithTitle:title
                                                   Description:description
                                                        Object:programObject
                                                    MessageExt:nil
                                                 MessageAction:nil
                                                    ThumbImage:nil
                                                      MediaTag:nil];
    
    
    
    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
                                                   OrMediaMessage:message
                                                            bText:NO
                                                          InScene:WXSceneSession];
    
    return [WXApi sendReq:req];
}

+ (BOOL)addCardsToCardPackage:(NSArray *)cardItems {
    AddCardToWXCardPackageReq *req = [[AddCardToWXCardPackageReq alloc] init];
    req.cardAry = cardItems;
    return [WXApi sendReq:req];
}

+ (BOOL)sendAuthRequestScope:(NSString *)scope
                       State:(NSString *)state
                      OpenID:(NSString *)openID
            InViewController:(UIViewController *)viewController {
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = scope; 
    req.state = state;
    req.openID = openID;
    
    return [WXApi sendAuthReq:req
               viewController:viewController
                     delegate:[CNLiveShareImageManager manager]];
}

+ (BOOL)jumpToBizWebviewWithAppID:(NSString *)appID
                      Description:(NSString *)description
                        tousrname:(NSString *)tousrname
                           ExtMsg:(NSString *)extMsg {
    JumpToBizWebviewReq *req = [[JumpToBizWebviewReq alloc]init];
    req.tousrname = tousrname;
    req.extMsg = extMsg;
    req.webType = WXMPWebviewType_Ad;
    return [WXApi sendReq:req];
}
#pragma mark - 对 QQ 的相关方法d进行封装
+ (BOOL)sendQQText:(NSString *)text
{
    QQApiTextObject * textObj = [QQApiTextObject objectWithText:text];
    
    SendMessageToQQReq * message = [SendMessageToQQReq reqWithContent:textObj];
    
    return [QQApiInterface sendReq:message] == EQQAPISENDSUCESS;
}
+ (BOOL)sendQQImageData:(NSData *)imageData
         ThumbImageData:(NSData *)thumbData
                  title:(NSString*)title
            description:(NSString*)description
{
    QQApiImageObject * imageObj = [QQApiImageObject objectWithData:imageData previewImageData:thumbData title:title description:description];
    SendMessageToQQReq * message = [SendMessageToQQReq reqWithContent:imageObj];
    return [QQApiInterface sendReq:message] == EQQAPISENDSUCESS;
}

+ (BOOL)sendQQLinkWithURL:(NSURL*)url
                    title:(NSString*)title
              description:(NSString*)description
         previewImageData:(NSData*)data
        targetContentType:(QQApiURLTargetType)targetContentType
{
    QQApiURLObject * linkObj = [QQApiURLObject objectWithURL:url title:title description:description previewImageData:data targetContentType:targetContentType];
    SendMessageToQQReq * message = [SendMessageToQQReq reqWithContent:linkObj];
    return [QQApiInterface sendReq:message] == EQQAPISENDSUCESS;
}

+ (BOOL)sendQQMusicWithURL:(NSURL*)url
                     title:(NSString*)title
               description:(NSString*)description
          previewImageData:(NSData*)data
{
    QQApiAudioObject * audioObj = [QQApiAudioObject objectWithURL:url title:title description:description previewImageData:data];
    SendMessageToQQReq * message = [SendMessageToQQReq reqWithContent:audioObj];
    return [QQApiInterface sendReq:message] == EQQAPISENDSUCESS;
}

+ (BOOL)sendQQVideoWithURL:(NSURL*)url
                     title:(NSString*)title
               description:(NSString*)description
          previewImageData:(NSData*)data
{
    QQApiVideoObject * videoObj = [QQApiVideoObject objectWithURL:url title:title description:description previewImageData:data];
    SendMessageToQQReq * message = [SendMessageToQQReq reqWithContent:videoObj];
    return [QQApiInterface sendReq:message] == EQQAPISENDSUCESS;
}
#pragma mark - 微博的相关方法调用

+(BOOL)sendWBText:(NSString *)text
{
    WBMessageObject * message = [WBMessageObject message];
    message.text = text;
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = @"http://wjjh5.cnlive.com/apkdownload.php";
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
    return [WeiboSDK sendRequest:request];
}
+ (BOOL)sendWBImageData:(NSData *)imageData
         ThumbImageData:(NSData *)thumbData
                  title:(NSString*)title
            description:(NSString*)description
{
    WBImageObject * imageMessage = [WBImageObject object];
    imageMessage.imageData = imageData;
    
    WBMessageObject * message = [WBMessageObject message];
    message.text = [NSString stringWithFormat:@"%@",title];
    message.imageObject = imageMessage;
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = @"http://wjjh5.cnlive.com/apkdownload.php";
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
    return [WeiboSDK sendRequest:request];
}
+ (BOOL)sendWBLinkWithURL:(NSString*)url
                    title:(NSString*)title
              description:(NSString*)description
         previewImageData:(NSData*)data
{
    WBImageObject * imageMessage = [WBImageObject object];
    imageMessage.imageData = data;
    
//    WBWebpageObject * webpageMessage = [WBWebpageObject object];
//    webpageMessage.objectID = url;
//    webpageMessage.webpageUrl = url;
//    webpageMessage.title = title;
//    webpageMessage.thumbnailData = data;
//    webpageMessage.description = description;
    
    WBMessageObject * message = [WBMessageObject message];
    message.text = [NSString stringWithFormat:@"%@%@",title,url];
    message.imageObject = imageMessage;
//    message.mediaObject = webpageMessage;

    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = @"http://wjjh5.cnlive.com/apkdownload.php";
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
    return [WeiboSDK sendRequest:request];
}
@end
