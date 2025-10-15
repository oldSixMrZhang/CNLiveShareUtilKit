//
//  CNLiveShareHelper.h
//  CNLiveShareTool
//
//  Created by 流诗语 on 2018/11/29.
//  Copyright © 2018年 group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CNLiveShareHelper : NSObject

+ (instancetype _Nonnull)sharedInstance;

@end

@interface CNLiveShareHelper (Bundle)

+ (nullable NSBundle *)resourcesBundle;
+ (nullable UIImage *)imageWithName:(nullable NSString *)name;

+ (nullable NSBundle *)resourcesBundleWithName:(nullable NSString *)bundleName;
+ (nullable UIImage *)imageInBundle:(nullable NSBundle *)bundle withName:(nullable NSString *)name;

+(NSDictionary *)requestURLParameters:(NSString *)urlStr;

@end

