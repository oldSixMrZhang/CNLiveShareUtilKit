//
//  CNLiveShareExtension.m
//  CNLiveNetAdd
//
//  Created by 流诗语 on 2019/5/8.
//  Copyright © 2019年 cnlive. All rights reserved.
//

#import "CNLiveShareExtension.h"
#import <SDWebImage/SDWebImage.h>
#import "CNLiveShareImageManager.h"
#import "CNLiveShareRequestHandler.h"
#import <QMUIKit/QMUIKit.h>
#import <CNLiveCommonCategory/UIImage+zipData.h>
@implementation CNLiveShareExtension
+ (void)requestNetImage:(id)images CompleterBlock:(void(^)(UIImage * image,NSError * error))completerBlock
{
    if (completerBlock) {
        if (images == nil) {
            completerBlock(nil,nil);
            return;
        }
        if ([images isKindOfClass:[NSData class]]) {
            completerBlock([UIImage imageWithData:(NSData *)images],nil);
            return;
        }
        if ([images isKindOfClass:[UIImage class]]) {
            completerBlock([UIImage imageWithData:images],nil);
            return;
        }
        NSURL * imageURL = nil;
        if ([images isKindOfClass:[NSString class]]) {
            imageURL = [NSURL URLWithString:images];
        }
        
        if ([images isKindOfClass:[NSURL class]]) {
            imageURL = images;
        }
        [QMUITips showLoadingInView:[UIApplication sharedApplication].windows.firstObject];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:imageURL options:SDWebImageDownloaderLowPriority | SDWebImageDownloaderUseNSURLCache progress:NULL completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            [QMUITips hideAllTipsInView:[UIApplication sharedApplication].windows.firstObject];
            if (image) {
                if (completerBlock) completerBlock(image,nil);
            }else{
                if (completerBlock) completerBlock([UIImage imageNamed:@"logofont"],nil);
            }
        }];
    }
}
#pragma mark - 微信分享
+ (void)shareWithWXFriend:(NSDictionary *)params isSession:(BOOL)isSession CompleterBlock:(void(^)(BOOL isSuccess))completerBlock
{
    __block BOOL isSuccess = NO;
    if (isSession &&![params[CNLiveSharePath] isEqualToString:@""]
        && ![params[CNLiveShareUName] isEqualToString:@""]
        && [params[CNLiveShareConTy] integerValue] == CNLiveContentTypeMiniProgram) {
        [CNLiveShareExtension requestNetImage:params[CNLiveShareImage] CompleterBlock:^(UIImage *image,NSError * error) {
            UIImage * tempImage = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.5)];
            isSuccess = [CNLiveShareRequestHandler sendMiniProgram:params[CNLiveShareUName] Path:params[CNLiveSharePath] URLString:params[CNLiveShareURL] ThumbImage:tempImage Title:params[CNLiveShareName] Description:params[CNLiveShareDesc] Ticket:params[CNLiveShareTickt]];
            if ((!isSuccess && completerBlock) || error) completerBlock(NO);
        }];
    }else{
        if ([params[CNLiveShareName] isEqualToString:@""] || [params[CNLiveShareURL] isEqualToString:@""]) {
            [CNLiveShareExtension requestNetImage:params[CNLiveShareImage] CompleterBlock:^(UIImage *image,NSError * error) {
                if (image) {
                    isSuccess = [CNLiveShareRequestHandler sendImageData:UIImagePNGRepresentation(image) TagName:@"" MessageExt:params[CNLiveShareDesc] Action:params[CNLiveShareURL] ThumbImage:[UIImage imageWithData:[UIImage zip_1080_NSDataAndScaleWithImage:image size:300]] InScene:isSession?WXSceneSession:WXSceneTimeline];
                }else{
                    isSuccess = [CNLiveShareRequestHandler sendText:params[CNLiveShareName] InScene:isSession?WXSceneSession:WXSceneTimeline];
                }
                if ((!isSuccess && completerBlock) || error) completerBlock(NO);
            }];
        }
        
        if ([params[CNLiveShareImage] isKindOfClass:[UIImage class]] && params[CNLiveShareImage]==nil) {
            isSuccess = [CNLiveShareRequestHandler sendText:params[CNLiveShareName] InScene:isSession?WXSceneSession:WXSceneTimeline];
            if (!isSuccess && completerBlock) completerBlock(NO);
        }
        
        if ([params[CNLiveShareImage] isKindOfClass:[NSString class]] && [params[CNLiveShareImage] isEqualToString:@""]) {
            isSuccess = [CNLiveShareRequestHandler sendText:params[CNLiveShareName] InScene:isSession?WXSceneSession:WXSceneTimeline];
            if (!isSuccess && completerBlock) completerBlock(NO);
        }
        
        if (![params[CNLiveShareURL] isEqualToString:@""] && ![params[CNLiveShareName] isEqualToString:@""]) {
            [CNLiveShareExtension requestNetImage:params[CNLiveShareImage] CompleterBlock:^(UIImage *image,NSError * error) {
                if (image) {
                      isSuccess =[CNLiveShareRequestHandler sendLinkURL:params[CNLiveShareURL] TagName:@"" Title:params[CNLiveShareName] Description:params[CNLiveShareDesc] ThumbImage:[UIImage imageWithData:[UIImage zip_1080_NSDataAndScaleWithImage:image size:300]] InScene:isSession?WXSceneSession:WXSceneTimeline];
                }else{
                    isSuccess =[CNLiveShareRequestHandler sendText:params[CNLiveShareName] InScene:isSession?WXSceneSession:WXSceneTimeline];
                }
                if ((!isSuccess && completerBlock) || error) completerBlock(NO);
            }];
        }
    }
}
#pragma mark - QQ 分享
+ (void)shareWithQQFriend:(NSDictionary *)params CompleterBlock:(void(^)(BOOL isSuccess))completerBlock
{
    __block BOOL isSuccess = NO;
    if ([params[CNLiveShareName] isEqualToString:@""] || [params[CNLiveShareURL] isEqualToString:@""]) {
        [CNLiveShareExtension requestNetImage:params[CNLiveShareImage] CompleterBlock:^(UIImage *image,NSError * error) {
            if (image) {
                isSuccess =[CNLiveShareRequestHandler sendQQImageData:UIImagePNGRepresentation(image) ThumbImageData:[UIImage zip_1080_NSDataAndScaleWithImage:image size:300] title:params[CNLiveShareName] description:params[CNLiveShareDesc]];
            }else{
                isSuccess =[CNLiveShareRequestHandler sendQQText:params[CNLiveShareName]];
            }
            if ((!isSuccess && completerBlock) || error) completerBlock(NO);
        }];
        return;
    }
    
    if ([params[CNLiveShareImage] isEqualToString:@""]) {
        isSuccess =[CNLiveShareRequestHandler sendQQText:params[CNLiveShareName]];
        if (!isSuccess && completerBlock) completerBlock(NO);
        return;
    }
    
    if (![params[CNLiveShareURL] isEqualToString:@""] && ![params[CNLiveShareName] isEqualToString:@""]) {
        [CNLiveShareExtension requestNetImage:params[CNLiveShareImage] CompleterBlock:^(UIImage *image,NSError * error) {
            if (image) {
                isSuccess =[CNLiveShareRequestHandler sendQQLinkWithURL:[NSURL URLWithString:params[CNLiveShareURL]] title:params[CNLiveShareName] description:params[CNLiveShareDesc] previewImageData:[UIImage zip_1080_NSDataAndScaleWithImage:image size:300] targetContentType:QQApiURLTargetTypeNews];
            }else{
                isSuccess =[CNLiveShareRequestHandler sendQQText:params[CNLiveShareName]];
            }
            if ((!isSuccess && completerBlock) || error) completerBlock(NO);
        }];
        return;
    }
}
#pragma mark - 微博 分享
+ (void)shareWithWBFriend:(NSDictionary *)params CompleterBlock:(void(^)(BOOL isSuccess))completerBlock
{
    __block BOOL isSuccess = NO;
    if ([params[CNLiveShareName] isEqualToString:@""] || [params[CNLiveShareURL] isEqualToString:@""]) {
        [CNLiveShareExtension requestNetImage:params[CNLiveShareImage] CompleterBlock:^(UIImage *image,NSError * error) {
            if (image) {
                isSuccess =[CNLiveShareRequestHandler sendWBImageData:UIImagePNGRepresentation(image) ThumbImageData:UIImagePNGRepresentation(image) title:params[CNLiveShareName] description:params[CNLiveShareDesc]];
            }else{
                isSuccess =[CNLiveShareRequestHandler sendWBText:params[CNLiveShareName]];
            }
            if ((!isSuccess && completerBlock) || error) completerBlock(NO);
        }];
        return;
    }
    
    if ([params[CNLiveShareImage] isEqualToString:@""]) {
        isSuccess =[CNLiveShareRequestHandler sendWBText:params[CNLiveShareName]];
        if (!isSuccess && completerBlock) completerBlock(NO);
        return;
    }
    
    if (![params[CNLiveShareURL] isEqualToString:@""] && ![params[CNLiveShareName] isEqualToString:@""]) {
        [CNLiveShareExtension requestNetImage:params[CNLiveShareImage] CompleterBlock:^(UIImage *image,NSError * error) {
            if (image) {
                isSuccess =[CNLiveShareRequestHandler sendWBLinkWithURL:params[CNLiveShareURL] title:params[CNLiveShareName] description:params[CNLiveShareDesc] previewImageData:UIImagePNGRepresentation(image)];
            }else{
                isSuccess =[CNLiveShareRequestHandler sendWBText:params[CNLiveShareName]];
            }
            if ((!isSuccess && completerBlock) || error) completerBlock(NO);
        }];
        return;
    }
}
@end
