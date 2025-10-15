//
//  WXMediaMessage+CNLiveShareWXMessage.h
//  CNLiveNetAdd
//
//  Created by 流诗语 on 2019/5/7.
//  Copyright © 2019年 cnlive. All rights reserved.
//

#import "WXApiObject.h"

@interface WXMediaMessage (CNLiveShareWXMessage)

+ (WXMediaMessage *)messageWithTitle:(NSString *)title
                         Description:(NSString *)description
                              Object:(id)mediaObject
                          MessageExt:(NSString *)messageExt
                       MessageAction:(NSString *)action
                          ThumbImage:(UIImage *)thumbImage
                            MediaTag:(NSString *)tagName;
@end
