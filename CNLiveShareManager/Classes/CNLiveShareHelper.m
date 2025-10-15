//
//  CNLiveShareHelper.m
//  CNLiveShareTool
//
//  Created by 流诗语 on 2018/11/29.
//  Copyright © 2018年 group. All rights reserved.
//

#import "CNLiveShareHelper.h"

NSString *const QMUIResourcesMainBundleName = @"CNLiveShareTool.bundle";

@implementation CNLiveShareHelper

+(instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static CNLiveShareHelper *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    
    return [self sharedInstance];
}
@end

@implementation CNLiveShareHelper (Bundle)

+ (NSBundle *)resourcesBundle {
    return [CNLiveShareHelper resourcesBundleWithName:QMUIResourcesMainBundleName];
}

+ (NSBundle *)resourcesBundleWithName:(NSString *)bundleName {
    NSBundle *bundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Frameworks/CNLiveShareTool.framework"]];
    if (!bundle) {
        // 不能走到这里  这只是以防万一的地方
        NSBundle *frameworkBundle = [NSBundle bundleForClass:[self class]];
        NSDictionary *bundleData = [self parseBundleName:bundleName];
        if (bundleData) {
            bundle = [NSBundle bundleWithPath:[frameworkBundle pathForResource:[bundleData objectForKey:@"name"] ofType:[bundleData objectForKey:@"type"]]];
        }
    }
    return bundle;
}

+ (UIImage *)imageWithName:(NSString *)name {
//    NSBundle *bundle = [NSBundle bundleWithPath:[[[CNLiveShareHelper resourcesBundle] resourcePath] stringByAppendingPathComponent:QMUIResourcesMainBundleName]];
    return [CNLiveShareHelper imageInBundle:[CNLiveShareHelper resourcesBundle] withName:name];
}

+ (UIImage *)imageInBundle:(NSBundle *)bundle withName:(NSString *)name {
    if (bundle && name) {
        if ([UIImage respondsToSelector:@selector(imageNamed:inBundle:compatibleWithTraitCollection:)]) {
            return [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", name] inBundle:bundle compatibleWithTraitCollection:nil];
        } else {
            NSString *imagePath = [[bundle resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", name]];
            return [UIImage imageWithContentsOfFile:imagePath];
        }
    }
    return nil;
}

+ (NSDictionary *)parseBundleName:(NSString *)bundleName {
    NSArray *bundleData = [bundleName componentsSeparatedByString:@"."];
    if (bundleData.count == 2) {
        return @{@"name":bundleData[0], @"type":bundleData[1]};
    }
    return nil;
}

//参数的跳转逻辑
+(NSDictionary *)requestURLParameters:(NSString *)urlStr
{
    // 查找参数
    NSRange range = [urlStr rangeOfString:@":"];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    // 以字典形式将参数返回
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSRange tempRang = [urlStr rangeOfString:@"?"];
    
    // 截取参数
    NSString *parametersString = [urlStr substringFromIndex:tempRang.location + 1];
    
    // 判断参数是单个参数还是多个参数
    if ([parametersString containsString:@"&"]) {
        
        // 多个参数，分割参数
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in urlComponents) {
            // 生成Key/Value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = pairComponents.firstObject;
            NSString *value = pairComponents.lastObject;
            
            // Key不能为nil
            if (key == nil || value == nil) {
                continue;
            }
            
            id existValue = [params valueForKey:key];
            
            if (existValue != nil) {
                
                // 已存在的值，生成数组
                if ([existValue isKindOfClass:[NSArray class]]) {
                    // 已存在的值生成数组
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    
                    [params setValue:items forKey:key];
                } else {
                    
                    // 非数组
                    [params setValue:@[existValue, value] forKey:key];
                }
                
            } else {
                
                // 设置值
                [params setValue:value forKey:key];
            }
        }
    } else {
        // 单个参数
        
        // 生成Key/Value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        
        // 只有一个参数，没有值
        if (pairComponents.count == 1) {
            return nil;
        }
        
        // 分隔值
        NSString *key = pairComponents.firstObject;
        NSString *value = pairComponents.lastObject;
        
        // Key不能为nil
        if (key == nil || value == nil) {
            return nil;
        }
        
        // 设置值
        [params setValue:value forKey:key];
    }
    
    return params;
}


@end
