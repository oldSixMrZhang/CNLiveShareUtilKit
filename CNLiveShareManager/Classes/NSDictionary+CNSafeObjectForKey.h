//
//  NSDictionary+CNSafeObjectForKey.h
//  CNLiveNetAdd
//
//  Created by 流诗语 on 2019/7/6.
//  Copyright © 2019年 cnlive. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (CNSafeObjectForKey)
-(id)safeObjectForKey:(NSString*) key;

-(NSMutableDictionary *)mutableDeepCopy;
@end

NS_ASSUME_NONNULL_END
