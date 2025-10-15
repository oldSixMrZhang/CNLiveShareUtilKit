//
//  SendMessageToWXReq+CNLiveShareWXRequest.m
//  CNLiveNetAdd
//
//  Created by 流诗语 on 2019/5/7.
//  Copyright © 2019年 cnlive. All rights reserved.
//

#import "SendMessageToWXReq+CNLiveShareWXRequest.h"

@implementation SendMessageToWXReq (CNLiveShareWXRequest)

+ (SendMessageToWXReq *)requestWithText:(NSString *)text
                         OrMediaMessage:(WXMediaMessage *)message
                                  bText:(BOOL)bText
                                InScene:(enum WXScene)scene {
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = bText;
    req.scene = scene;
    if (bText)
        req.text = text;
    else
        req.message = message;
    return req;
}

@end
