
//
//  CNLiveShareToolDefine.h
//  CNLiveShareTool
//
//  Created by 流诗语 on 2018/11/27.
//  Copyright © 2018年 group. All rights reserved.
//

#ifndef CNLiveShareToolDefine_h
#define CNLiveShareToolDefine_h

////////////////////////////////////////////////////////
////////////          SCreen
////////////////////////////////////////////////////////
#define KScreenWidth_Share ([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width)
#define KScreenHeight_Share ([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height)

#define IS_IPhoneX_All_Share (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375, 812)) ||CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(812, 375)) ||CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(414, 896)) ||CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(896, 414)))

#define kVerticalBottomSafeHeight_Share ((IS_IPhoneX_All_Share > 0) ? 34 : 0)
#define kHorizontalBottomHeight_Share ((IS_IPhoneX_All_Share > 0) ? 21 : 0)

#define RGB(r,g,b)          [UIColor colorWithRed:(r)/255.f \
                                                    green:(g)/255.f \
                                                    blue:(b)/255.f \
                                                    alpha:1.f]

//////////////////////////////////////
///////////////// 三方平台相关参数////////
//////////////////////////////////////
#pragma mark - 默认文案
static NSString *const CNBetterLife = @"中国网家家 让生活更美好!";
static NSString *const CNComeAndJoin = @"快来看中国网家家，优享美好生活!";



#endif /* CNLiveShareToolDefine_h */
