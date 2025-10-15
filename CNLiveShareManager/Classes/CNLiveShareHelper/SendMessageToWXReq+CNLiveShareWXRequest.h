//
//  SendMessageToWXReq+CNLiveShareWXRequest.h
//  CNLiveNetAdd
//
//  Created by 流诗语 on 2019/5/7.
//  Copyright © 2019年 cnlive. All rights reserved.
//

#import "WXApiObject.h"

@interface SendMessageToWXReq (CNLiveShareWXRequest)

+ (SendMessageToWXReq *)requestWithText:(NSString *)text
                         OrMediaMessage:(WXMediaMessage *)message
                                  bText:(BOOL)bText
                                InScene:(enum WXScene)scene;
@end

