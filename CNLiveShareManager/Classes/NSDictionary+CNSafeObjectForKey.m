//
//  NSDictionary+CNSafeObjectForKey.m
//  CNLiveNetAdd
//
//  Created by 流诗语 on 2019/7/6.
//  Copyright © 2019年 cnlive. All rights reserved.
//

#import "NSDictionary+CNSafeObjectForKey.h"

@implementation NSDictionary (CNSafeObjectForKey)
-(id)safeObjectForKey:(NSString*) key
{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSNull class]]) {
        object = nil;
    }
    return object;
    
}
-(NSMutableDictionary *)mutableDeepCopy {
    NSMutableDictionary *copyDict = [[NSMutableDictionary alloc]initWithCapacity:self.count];
    for (id key in self.allKeys) {
        id oneCopy = nil;
        id oneValue = [self valueForKey:key];
        if ([oneValue respondsToSelector:@selector(mutableDeepCopy)]) {
            oneCopy = [oneValue mutableDeepCopy];
        }else if ([oneValue respondsToSelector:@selector(copy)]) {
            oneCopy = [oneValue copy];
        }
        [copyDict setValue:oneCopy forKey:key];
    }
    return copyDict;
}
@end
