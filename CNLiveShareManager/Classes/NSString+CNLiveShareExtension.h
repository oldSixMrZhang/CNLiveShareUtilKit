//
//  NSString+CNLiveShareExtension.h
//  CNLiveShareManager_Example
//
//  Created by 流诗语 on 2019/11/9.
//  Copyright © 2019 woshiliushiyu. All rights reserved.


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

///判断是否为空字符串
#ifndef CNLiveStringIsEmpty
#define CNLiveStringIsEmpty(string) [NSString isEmpty:string]
#endif

@interface NSString (CNLiveShareExtension)
///判断是否为空字符串
+ (BOOL)isEmpty:(NSString *)string;


- (BOOL)isValidUrl;
@end

NS_ASSUME_NONNULL_END
