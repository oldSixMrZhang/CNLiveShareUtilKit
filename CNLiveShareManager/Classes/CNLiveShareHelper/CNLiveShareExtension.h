//
//  CNLiveShareExtension.h
//  CNLiveNetAdd
//
//  Created by 流诗语 on 2019/5/8.
//  Copyright © 2019年 cnlive. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CNLiveShareExtension : NSObject

/**
 调用微信分享

 @param params 参数
 @param isSession 是否分享给好友
 */
+ (void)shareWithWXFriend:(NSDictionary *)params isSession:(BOOL)isSession CompleterBlock:(void(^)(BOOL isSuccess))completerBlock;

/**
 调用 QQ 分享

 @param params 参数
 */
+ (void)shareWithQQFriend:(NSDictionary *)params CompleterBlock:(void(^)(BOOL isSuccess))completerBlock;

/**
 调用 微博 分享

 @param params 参数
 */
+ (void)shareWithWBFriend:(NSDictionary *)params CompleterBlock:(void(^)(BOOL isSuccess))completerBlock;
@end

NS_ASSUME_NONNULL_END
