//
//  NSString+CNLiveShareExtension.m
//  CNLiveShareManager_Example
//
//  Created by 流诗语 on 2019/11/9.
//  Copyright © 2019 woshiliushiyu. All rights reserved.
//

#import "NSString+CNLiveShareExtension.h"

@implementation NSString (CNLiveShareExtension)

//判断是否为空字符串
+ (BOOL)isEmpty:(NSString *)string
{
    if (!string || ![string isKindOfClass:[NSString class]] || string.length == 0 || [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        return YES;
    }
    return NO;
}
- (BOOL)isValidUrl
{
    NSString *regex =@"[a-zA-z]+://[^\\s]*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:self];
}

@end
