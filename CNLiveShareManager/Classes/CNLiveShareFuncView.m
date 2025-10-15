//
//  CNLiveShareFuncView.m
//  CNLiveShareTool
//
//  Created by 流诗语 on 2018/11/28.
//  Copyright © 2018年 group. All rights reserved.
//

#import "CNLiveShareFuncView.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "CNLiveShareToolDefine.h"
#import "CNLiveShareCustomButton.h"
#import "WXApi.h"
#import "CNLiveShareHelper.h"
#import "WeiboSDK.h"
#import "CNLiveShareManager.h"
#import <QMUIKit/QMUIKit.h>
#import "NSString+CNLiveShareExtension.h"
#import "CNLiveShareRequestHandler.h"
#import "CNLiveShareImageManager.h"
#import "CNLiveNetworking.h"
#import "NSDictionary+CNSafeObjectForKey.h"
#import <CNLiveEnvironment/CNLiveEnvironment.h>
#import <CNLiveCommonCategory/NSString+Category.h>
#import <CNLiveCommonCategory/CNLiveCommonCategory.h>
#import <CNLiveUserManagement/CNUserInfoManager.h>

static const CGFloat kSelfHeight = 190;

//NSString * CNLiveShareShortUrl = cn_API_Host(@"/Daren/announcementCheck/genShortLinks.action");

@interface CNLiveShareFuncView ()
@property (readwrite, copy, nonatomic) NSString * shareName;
@property (readwrite, copy, nonatomic) NSString * shareUrl;
@property (readwrite, copy, nonatomic) NSString * shareDesc;
@property (readwrite, strong, nonatomic) id shareImage;
@property (readwrite, assign, nonatomic) BOOL isFull;
@property (readwrite, assign, nonatomic) CNLiveSharePlatformType platType;

@property (assign, nonatomic) BOOL isShowBot;
@property (assign, nonatomic) CNLiveShareShowType shareType;
@property (assign, nonatomic) BOOL isShopCar;
@property (assign, nonatomic) BOOL isNotView;
@property (assign, nonatomic) BOOL isHiddenWjj;
@property (assign, nonatomic) BOOL isHiddenQQ;
@property (nonatomic, assign) BOOL isHiddenWB;
@property (assign, nonatomic) BOOL isHiddenWechat;
@property (assign, nonatomic) BOOL isHiddenSafari;
@property (assign, nonatomic) BOOL isWXMiniProgram;


@property (assign, nonatomic) BOOL isTitleEmpty;
@property (assign, nonatomic) BOOL isImageEmpty;
@property (assign, nonatomic) BOOL isContentEmpty;
@property (assign, nonatomic) BOOL isShareEmpty;

@property (strong, nonatomic) UIView * shareView;
@property (strong, nonatomic) NSMutableArray * shareDataArray;

@property (strong, nonatomic) NSArray * topImageArray;
@property (strong, nonatomic) NSArray * topTitleArray;
@property (copy, nonatomic) void(^touchTopActionBlock)(NSString * title);

@property (strong, nonatomic) NSArray * botImageArray;
@property (strong, nonatomic) NSArray * botTitleArray;
@property (copy, nonatomic) void(^touchBotActionBlock)(NSString * title);

@property (nonatomic, copy) NSString *mProgramId;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, assign) BOOL isTicket;
@property (nonatomic, assign) NSInteger miniProgramType;
@end

@implementation CNLiveShareFuncView

- (instancetype)initWithShareName:(NSString *)shareName
                         ShareUrl:(NSString *)shareUrl
                        ShareDesc:(NSString *)shareDesc
                       ShareImage:(id)shareImage
                     PlatformType:(CNLiveSharePlatformType)platformType
                           isFull:(BOOL)isFull
                  isWXMiniProgram:(BOOL)isWXMiniProgram
                        HiddenWjj:(BOOL)isHiddenWjj
                         HiddenQQ:(BOOL)isHiddenQQ
                         HiddenWB:(BOOL)isHiddenWB
                     HiddenWechat:(BOOL)isHiddenWechat
                     HiddenSafari:(BOOL)isHiddenSafari
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        NSDictionary * dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"CNWjjAddSourceTime"];
        
        self.isTitleEmpty = CNLiveStringIsEmpty(shareName);
        self.isShareEmpty = CNLiveStringIsEmpty(shareUrl);
        self.isContentEmpty = CNLiveStringIsEmpty(shareDesc);
        if ([shareImage isKindOfClass:[NSString class]]) {
            self.isImageEmpty = CNLiveStringIsEmpty(shareName);
        }else if ([shareImage isKindOfClass:[UIImage class]]) {
            self.isImageEmpty = shareImage == nil;
        }

        
        NSString * defult_img = @"";
#ifdef DEBUG
        defult_img = CNLiveStringIsEmpty([dic objectForKey:@"shareImgPathDebug"])?@"":[dic objectForKey:@"shareImgPathDebug"];
#else
        defult_img = CNLiveStringIsEmpty([dic objectForKey:@"shareImgPathRelease"])?@"":[dic objectForKey:@"shareImgPathRelease"];
#endif
        NSString * defult_title = CNLiveStringIsEmpty([dic objectForKey:@"shareTitle"])?CNComeAndJoin:[dic objectForKey:@"shareTitle"];
        NSString * defult_subTitle = CNLiveStringIsEmpty([dic objectForKey:@"shareSubTitle"])?CNBetterLife:[dic objectForKey:@"shareSubTitle"];
        self.shareDesc = ![self isEmptyString:shareDesc]?shareDesc:defult_subTitle;
        if ([shareImage isKindOfClass:[NSString class]]) {
            self.shareImage = CNLiveStringIsEmpty(shareImage)?defult_img:shareImage;
        }else{
            self.shareImage = shareImage;
        }
        self.shareUrl = ![self isEmptyString:shareUrl]?shareUrl:@"";
        self.shareName = ![self isEmptyString:shareName]?shareName:defult_title;
        self.platType = platformType;
        self.isFull = isFull;
        self.isHiddenWechat = isHiddenWechat;
        self.isHiddenSafari = isHiddenSafari;
        self.isHiddenQQ = isHiddenQQ;
        self.isHiddenWB = isHiddenWB;
        self.isHiddenWjj = isHiddenWjj;
        self.isWXMiniProgram = isWXMiniProgram;
        self.shareType = CNLiveShareShowTypeShare;

    }
    return self;
}
-(void)touchSharePlatformType:(CNLiveSharePlatformType)platformType
{
    
    if (platformType == CNLiveSharePlatformTypeWeChat && ![WXApi isWXAppInstalled]) {
//        [self showAlertViewTipString:@"未安装微信"];
        [QMUITips showWithText:@"未安装微信" inView:[UIWindow currentViewController].view hideAfterDelay:1.5];
        [self dismiss];
        return;
    }
    if (platformType == CNLiveSharePlatformTypeCricle && ![WXApi isWXAppInstalled]) {
//       [self showAlertViewTipString:@"未安装微信"];
        [QMUITips showWithText:@"未安装微信" inView:[UIWindow currentViewController].view hideAfterDelay:1.5];
        [self dismiss];
        return;
    }
    if (platformType == CNLiveSharePlatformTypeQQFriend && ![TencentOAuth iphoneQQInstalled])
    {
//        [self showAlertViewTipString:@"未安装QQ"];
        [QMUITips showWithText:@"未安装QQ" inView:[UIWindow currentViewController].view hideAfterDelay:1.5];
        [self dismiss];
        return;
    }
    if (platformType == CNLiveSharePlatformTypeSina && ![WeiboSDK isWeiboAppInstalled])
    {
//        [self showAlertViewTipString:@"未安装新浪微博"];
        [QMUITips showWithText:@"未安装新浪微博" inView:[UIWindow currentViewController].view hideAfterDelay:1.5];
        [self dismiss];
        return;
    }
    self.isNotView = YES;
    
    CNLiveShareCustomButton *shareItem = [CNLiveShareCustomButton buttonWithType:UIButtonTypeCustom];
    
    NSString * shareString = @"";
    
    if (platformType == CNLiveSharePlatformTypeWjjFriend) shareString = @"网家家好友";
    if (platformType == CNLiveSharePlatformTypeWjjLive) shareString = @"生活圈";
    if (platformType == CNLiveSharePlatformTypeWeChat) shareString = @"微信";
    if (platformType == CNLiveSharePlatformTypeCricle) shareString = @"朋友圈";
    if (platformType == CNLiveSharePlatformTypeQQFriend) shareString = @"QQ好友";
    if (platformType == CNLiveSharePlatformTypeSina) shareString = @"新浪微博";
    if (platformType == CNLiveSharePlatformTypeSafari) shareString = @"Safari打开";
    
    [shareItem setTitle:shareString forState:UIControlStateNormal];
    
    [self shareItemClick:shareItem];
}

-(void)addBottemButtomsImage:(NSArray<NSString *> *)images Titles:(NSArray<NSString *> *)titles CompleterBlock:(void (^)(NSString *))completerBlock
{
    self.isShowBot = YES;
    self.botTitleArray = titles;
    self.botImageArray = images;
    self.touchBotActionBlock = completerBlock;
}
-(void)addTopButtomsImage:(NSArray<NSString *> *)images Titles:(NSArray<NSString *> *)titles CompleterBlock:(void (^)(NSString *))completerBlock
{
    self.topImageArray = images;
    self.topTitleArray = titles;
    self.touchTopActionBlock = completerBlock;
}
-(void)addShareWeChatMiniProgramForParamDict:(NSString *)mProgramId Path:(NSString *)path ShareTicket:(BOOL)isTicket isCanShareSafari:(BOOL)isCanShareSafari MiniProgramType:(NSInteger)miniProgramType ShowType:(CNLiveShareShowType)showType
{
    self.shareType = showType;
    self.isShopCar = YES;
    self.mProgramId = mProgramId;
    self.path = path;
    self.isTicket = isTicket;
    self.isHiddenSafari = isCanShareSafari;
    self.miniProgramType = miniProgramType;
}

- (void)setDataSourceWithBottomScrollView:(UIScrollView *)scrollView
{
    NSArray *imgArr2   = _botImageArray;
    NSArray *titleArr2 = _botTitleArray;
    [self setScrollViewContentWithScrollView:scrollView imgArray:imgArr2 titleArray:titleArr2];
}
- (BOOL)isEmptyString:(NSString *)string
{
    if (!string || ![string isKindOfClass:[NSString class]] || string.length == 0 || [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        return YES;
    }
    return NO;
}
#pragma mark - setupUI
-(void)setFullSetup
{
    // 背景Btn
    UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bgBtn.frame = CGRectMake(0, 0, KScreenHeight_Share, KScreenWidth_Share - ( kSelfHeight+ kVerticalBottomSafeHeight_Share));
    [bgBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bgBtn];
    
    // 分享视图
    self.shareView = ({
        UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenWidth_Share, KScreenHeight_Share, kSelfHeight+kHorizontalBottomHeight_Share)];
        shareView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        [self addSubview:shareView];
        shareView;
    });
    
    //上题目
    UILabel * shareName = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, KScreenHeight_Share, 20)];
    shareName.textColor = [UIColor blackColor];
    shareName.font = [UIFont systemFontOfSize:15];
    shareName.textAlignment = NSTextAlignmentCenter;
    shareName.text = @"分享到其他";
    [self.shareView addSubview:shareName];
    
    // 上ScrollView
    UIScrollView *topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(shareName.frame), KScreenHeight_Share, 100)];
    topScrollView.showsHorizontalScrollIndicator = NO;
    topScrollView.backgroundColor = [UIColor clearColor];
    [self.shareView addSubview:topScrollView];
    
    UILabel * lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topScrollView.frame)+10, KScreenHeight_Share, 1)];
    lineLabel.backgroundColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1];;
    [self.shareView addSubview:lineLabel];
    
    // 关闭Btn
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(0, CGRectGetMaxY(topScrollView.frame)+21, KScreenHeight_Share, 30);
    closeBtn.backgroundColor = [UIColor clearColor];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:closeBtn];
    
    // 设置数据
    [self setScrollViewContentWithScrollView:topScrollView imgArray:self.shareDataArray[1] titleArray:self.shareDataArray[0]];
}
- (void)setUp
{
    // 背景Btn
    CGFloat bgH = kSelfHeight+kVerticalBottomSafeHeight_Share+(_isShowBot ? 100 : 0);
    UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bgBtn.frame = CGRectMake(0, 0, KScreenWidth_Share, KScreenHeight_Share - bgH);
    [bgBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bgBtn];
    
    // 分享视图
    self.shareView = ({
        UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight_Share, KScreenWidth_Share, bgH)];
        shareView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        [self addSubview:shareView];
        shareView;
    });
    
    //上题目
    UILabel * shareName = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, KScreenWidth_Share-40, 20)];
    shareName.textColor = [UIColor blackColor];
    shareName.font = [UIFont systemFontOfSize:15];
    shareName.textAlignment = NSTextAlignmentLeft;
    shareName.text = @"分享到其他:";
    [self.shareView addSubview:shareName];
    
    // 上ScrollView
    UIScrollView *topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(shareName.frame), KScreenWidth_Share, 100)];
    topScrollView.showsHorizontalScrollIndicator = NO;
    topScrollView.backgroundColor = [UIColor clearColor];
    [self.shareView addSubview:topScrollView];
    
    // 下ScrollView
    UIScrollView *bottomScrollView;
    if (_isShowBot) {
        bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topScrollView.frame), KScreenWidth_Share, 100)];
        bottomScrollView.tag = 2;
        bottomScrollView.showsHorizontalScrollIndicator = NO;
        bottomScrollView.backgroundColor = [UIColor clearColor];
        [self.shareView addSubview:bottomScrollView];
    }
    
    UILabel * lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(!_isShowBot ? topScrollView.frame : bottomScrollView.frame)+10, KScreenWidth_Share, 1)];
    lineLabel.backgroundColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1];
    [self.shareView addSubview:lineLabel];
    
    // 关闭Btn
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(0, CGRectGetMaxY(!_isShowBot ? topScrollView.frame : bottomScrollView.frame)+21, KScreenWidth_Share, 30);
    closeBtn.backgroundColor = [UIColor clearColor];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:closeBtn];
    
    // 设置数据
    NSMutableArray * imageTmpArray = [[NSMutableArray alloc] initWithArray:self.shareDataArray[1]];
    NSMutableArray * titleTmpArray = [[NSMutableArray alloc] initWithArray:self.shareDataArray[0]];
    if (self.topImageArray.count > 0) [imageTmpArray addObjectsFromArray:self.topImageArray];
    if (self.topTitleArray.count > 0) [titleTmpArray addObjectsFromArray:self.topTitleArray];
    [self setScrollViewContentWithScrollView:topScrollView imgArray:imageTmpArray titleArray:titleTmpArray];
    
    if (_isShowBot) [self setDataSourceWithBottomScrollView:bottomScrollView];
}
- (void)setScrollViewContentWithScrollView:(UIScrollView *)scrollView imgArray:(NSArray *)imgArray titleArray:(NSArray *)titleArray
{
    CGFloat btnW = 70;
    CGFloat btnH = 90;
    CGFloat btnX = 0;
    CGFloat btnY = 20;


    CGFloat fullMargin = KScreenHeight_Share > btnW*imgArray.count ? (KScreenHeight_Share-(btnW*imgArray.count))/(imgArray.count-1) : 10;
    CGFloat margin = (self.isFull ? fullMargin : 10);
    
    for (int i = 0; i < imgArray.count; i++) {
        
        btnX = (btnW + margin)* i + margin;
        
        CNLiveShareCustomButton *shareItem = [CNLiveShareCustomButton buttonWithType:UIButtonTypeCustom];
        shareItem.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [shareItem setImage:_isShowBot ? [UIImage imageNamed:imgArray[i]]: [CNLiveShareHelper imageWithName:imgArray[i]] forState:UIControlStateNormal];
        [shareItem setImage:_isShowBot ? [UIImage imageNamed:imgArray[i]]:[CNLiveShareHelper imageWithName:imgArray[i]] forState:UIControlStateHighlighted];
        if ([CNLiveShareHelper imageWithName:imgArray[i]] == nil) {
            [shareItem setImage:[UIImage imageNamed:imgArray[i]] forState:UIControlStateNormal];
            [shareItem setImage:[UIImage imageNamed:imgArray[i]] forState:UIControlStateHighlighted];
        }
        [shareItem setTitle:titleArray[i] forState:UIControlStateNormal];
        shareItem.titleLabel.textAlignment = NSTextAlignmentCenter;
        [shareItem addTarget:self action:@selector(shareItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:shareItem];
        
        if (i == imgArray.count - 1) {//CGRectGetMaxX(shareItem.frame) + margin
            scrollView.contentSize = CGSizeMake(CGRectGetMaxX(shareItem.frame) + margin, btnH);
        }
        shareItem.tag = i + 1000;
    }
}


#pragma mark -Action
- (void)shareItemClick:(CNLiveShareCustomButton *)shareItemBtn
{
    NSString * shareItemBtnString = shareItemBtn.titleLabel.text;

    CNLiveSharePlatformType platformType = CNLiveSharePlatformTypeAll;
    
    if ([self checkURLWithSid] != 4) {
        if ([self checkURLWithSid] == 0) self.shareUrl = [NSString stringWithFormat:@"%@?shareSid=%@",self.shareUrl,CNUserShareModel.uid];
        if ([self checkURLWithSid] == 0) self.shareUrl = [NSString stringWithFormat:@"%@&sid=%@",self.shareUrl,CNUserShareModel.uid];
        
        if ([self checkURLWithSid] == 1) self.shareUrl = [NSString stringWithFormat:@"%@&shareSid=%@",self.shareUrl,CNUserShareModel.uid];
        if ([self checkURLWithSid] == 1) self.shareUrl = [NSString stringWithFormat:@"%@&sid=%@",self.shareUrl,CNUserShareModel.uid];
    }
    
       NSArray * typeArray = @[@"wjj_friend",@"wjj_moment",@"wx_friend",@"wx_moment",@"qq_friend",@"",@"browser"];
    
    if ([shareItemBtnString isEqualToString:@"网家家好友"]) {
        
        CNLiveShareShowType type = CNLiveShareShowTypeShare;
        if (self.isTitleEmpty && self.isContentEmpty && self.isShareEmpty && !self.isImageEmpty) type = CNLiveShareShowTypeImage;
        [self dealWithShareUrl:CNLiveSharePlatformTypeWjjFriend];
        [self checkURLWithisApp:NO];
        platformType = CNLiveSharePlatformTypeWjjFriend;
        if (self.shareResultBlock) self.shareResultBlock(CNLiveShareResultTypeStart,CNLiveSharePlatformTypeWjjFriend,typeArray[0]);
        [self dismiss];
        if (self.touchNetAddBlock) self.touchNetAddBlock(platformType,self.shareName ? self.shareName : @"", self.shareImage? self.shareImage : NetAddShareImgUrl, self.shareDesc ? self.shareDesc : @"", self.shareUrl, type, self.isFull);
        return;
        
    } else if ([shareItemBtnString isEqualToString:@"生活圈"]) {
        CNLiveShareShowType type = CNLiveShareShowTypeShare;
        if (self.isTitleEmpty && self.isContentEmpty && self.isShareEmpty && !self.isImageEmpty) type = CNLiveShareShowTypeImage;
        if (self.isShopCar) type = CNLiveShareShowTypeShare;
        [self dealWithShareUrl:CNLiveSharePlatformTypeWjjLive];
        [self checkURLWithisApp:NO];
        platformType = CNLiveSharePlatformTypeWjjLive;
        if (self.shareResultBlock) self.shareResultBlock(CNLiveShareResultTypeStart,CNLiveSharePlatformTypeWjjLive,typeArray[1]);
        [self dismiss];
        if (self.touchNetAddBlock) self.touchNetAddBlock(platformType,self.shareName ? self.shareName : @"", self.shareImage? self.shareImage : NetAddShareImgUrl, self.shareDesc ? self.shareDesc : @"", self.shareUrl, type, self.isFull);
        return;
        
    }else if ([shareItemBtnString isEqualToString:@"微信"]) {
        [self dealWithShareUrl:CNLiveSharePlatformTypeWeChat];
        if (![WXApi isWXAppInstalled]) {
            [QMUITips showError:@"未安装微信" inView:[UIWindow currentViewController].view hideAfterDelay:2];
            return;
        }
        [CNLiveShareManager shareDefaultsManager].isShare = YES;
        [self checkURLWithisApp:YES];
        platformType = CNLiveSharePlatformTypeWeChat;
        if (self.shareResultBlock) self.shareResultBlock(CNLiveShareResultTypeStart,CNLiveSharePlatformTypeWeChat,typeArray[2]);
        
    }else if ([shareItemBtnString isEqualToString:@"朋友圈"]) {
        [self dealWithShareUrl:CNLiveSharePlatformTypeCricle];
        if (![WXApi isWXAppInstalled]) {
            [QMUITips showError:@"未安装微信" inView:[UIWindow currentViewController].view hideAfterDelay:2];
            return;
        }
        [CNLiveShareManager shareDefaultsManager].isShare = YES;
        [self checkURLWithisApp:YES];
        platformType = CNLiveSharePlatformTypeCricle;
        if (self.shareResultBlock) self.shareResultBlock(CNLiveShareResultTypeStart,CNLiveSharePlatformTypeCricle,typeArray[3]);
        
    }else if ([shareItemBtnString isEqualToString:@"QQ好友"]) {
        [self dealWithShareUrl:CNLiveSharePlatformTypeQQFriend];
        if (![TencentOAuth iphoneQQInstalled]) {
            [QMUITips showError:@"未安装QQ" inView:[UIWindow currentViewController].view hideAfterDelay:2];
            return;
        }
        [CNLiveShareManager shareDefaultsManager].isShare = YES;
        [self checkURLWithisApp:YES];
        platformType = CNLiveSharePlatformTypeQQFriend;
        if (self.shareResultBlock) self.shareResultBlock(CNLiveShareResultTypeStart,CNLiveSharePlatformTypeQQFriend,typeArray[4]);
        
    }else if ([shareItemBtnString isEqualToString:@"新浪微博"]) {
        [self dealWithShareUrl:CNLiveSharePlatformTypeSina];
        if (![WeiboSDK isWeiboAppInstalled])
        {
            [QMUITips showWithText:@"未安装新浪微博" inView:[UIWindow currentViewController].view hideAfterDelay:2];
            return;
        }
        [CNLiveShareManager shareDefaultsManager].isShare = YES;
        [self checkURLWithisApp:YES];
        platformType = CNLiveSharePlatformTypeSina;
        if (self.shareResultBlock) self.shareResultBlock(CNLiveShareResultTypeStart,CNLiveSharePlatformTypeSina,typeArray[5]);
        
//        itemType = SSDKPlatformTypeSinaWeibo;
        
    }else if ([shareItemBtnString isEqualToString:@"Safari打开"]) {
        [self dealWithShareUrl:CNLiveSharePlatformTypeSafari];
        [self checkURLWithisApp:YES];
        platformType = CNLiveSharePlatformTypeSafari;
        if (self.shareResultBlock) self.shareResultBlock(CNLiveShareResultTypeStart,CNLiveSharePlatformTypeSafari,typeArray[6]);
        
        if (self.isNotView) self.shareUrl = [self shareUrlDelegateVersionWithCurrentUrl:self.shareUrl];

        NSURL * url = [NSURL URLWithString:self.shareUrl];
        
        if (@available(iOS 11.0, *)) {
            
            [[UIApplication sharedApplication]openURL:url options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES} completionHandler:^(BOOL success) {

            }];
        } else {
            // Fallback on earlier versions
            [[UIApplication sharedApplication] openURL:url];
        }
        [self dismiss];
    }else if ([shareItemBtnString isEqualToString:@"系统分享"]) {
        
    }
    
    UIImage* image = [UIImage imageNamed:[[[[NSBundle mainBundle] infoDictionary] valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject]];
    

    if (platformType != CNLiveSharePlatformTypeAll) {
        
        id tempImage;
        
        if ([self.shareImage isKindOfClass:[NSString class]] && self.shareImage != nil) {
            
            if (![self isEmptyString:self.shareImage]) {
                
                tempImage = [self.shareImage isValidUrl] ? self.shareImage : image;
            }else{
                tempImage = image;
            }
            
        }else{
            
            tempImage = self.shareImage==nil?image:self.shareImage; //传入要分享的图片
        }

        __weak typeof(self) weakSelf = self;
        [self checkWithUrl:platformType CompleterBlock:^(NSString *shareUrl) {
            //
            NSDictionary * paramDict = [[CNLiveShareImageManager manager] setupShareParamsByName:weakSelf.shareName images:weakSelf.shareImage URL:shareUrl Desc:weakSelf.shareDesc UserName:weakSelf.mProgramId withShareTicket:weakSelf.isTicket Path:weakSelf.path ContentType:weakSelf.isWXMiniProgram?CNLiveContentTypeMiniProgram:CNLiveContentTypeWebpage];
            
            [CNLiveShareImageManager share:platformType Params:paramDict RecvStatusBlock:^(CNLiveShareStatue statue) {
                [QMUITips hideAllTipsInView:[UIWindow currentViewController].view];
                if (statue == CNLiveShareStatueSuccess) {
                    if (weakSelf.shareResultBlock) weakSelf.shareResultBlock(CNLiveShareResultTypeSucc,platformType,@"");
                }else if (statue == CNLiveShareStatueCancel) {
                    [CNLiveShareManager shareDefaultsManager].isShare = NO;
//                    if (weakSelf.shareResultBlock) weakSelf.shareResultBlock(CNLiveShareResultTypeCanc,@"");
//                    [QMUITips showError:@"分享取消" inView:AppKeyWindow hideAfterDelay:2];
                }else if (statue == CNLiveShareStatueFail) {
                    [CNLiveShareManager shareDefaultsManager].isShare = NO;
//                    if (weakSelf.shareResultBlock) weakSelf.shareResultBlock(CNLiveShareResultTypeFail,@"");
                    [QMUITips showError:@"分享失败" inView:[UIWindow currentViewController].view hideAfterDelay:2];
                }
                [self dismiss];
            }];
        }];
    }else{
        if (self.touchTopActionBlock) self.touchTopActionBlock(shareItemBtnString);
    }
    
    [self dismiss];
    if (self.isShowBot && [self.botTitleArray containsObject:shareItemBtnString] && self.touchBotActionBlock) self.touchBotActionBlock(shareItemBtnString);
}
-(void)dealWithShareUrl:(CNLiveSharePlatformType)platformType
{
    if ([self.shareUrl rangeOfString:@"|||||||||||"].location != NSNotFound) {
        if (platformType == CNLiveSharePlatformTypeQQFriend || platformType == CNLiveSharePlatformTypeSina || platformType == CNLiveSharePlatformTypeWeChat || platformType == CNLiveSharePlatformTypeCricle) {
            self.shareUrl = [self.shareUrl componentsSeparatedByString:@"|||||||||||"].lastObject;
        }else{
            self.shareUrl = [self.shareUrl componentsSeparatedByString:@"|||||||||||"].firstObject;
        }
    }
    if ([self.shareName rangeOfString:@"|||||||||||"].location != NSNotFound) {
        if (platformType == CNLiveSharePlatformTypeQQFriend || platformType == CNLiveSharePlatformTypeSina || platformType == CNLiveSharePlatformTypeWeChat || platformType == CNLiveSharePlatformTypeCricle) {
            self.shareName = [self.shareName componentsSeparatedByString:@"|||||||||||"].lastObject;
        }else{
            self.shareName = [self.shareName componentsSeparatedByString:@"|||||||||||"].firstObject;
        }
        self.shareName = CNLiveStringIsEmpty(self.shareName)?CNComeAndJoin:self.shareName;
    }
}
-(void)checkWithUrl:(CNLiveSharePlatformType)platformType CompleterBlock:(void(^)(NSString * shareUrl))completerBlock
{
    if (platformType == CNLiveSharePlatformTypeQQFriend) {
        
        if (self.shareUrl.length > 510) {
            __weak typeof(self) weakSelf = self;
            [CNLiveNetworking setupShowResult:YES];
            [CNLiveNetworking setAllowRequestDefaultArgument:YES];
            [CNLiveNetworking requestNetworkWithMethod:CNLiveRequestMethodPOST URLString:cn_API_Host(@"/Daren/announcementCheck/genShortLinks.action") Param:@{@"longUrl":weakSelf.shareUrl} CacheType:CNLiveNetworkCacheTypeNetworkOnly CompletionBlock:^(NSURLSessionTask *requestTask, id responseObject, NSError *error) {
                if (completerBlock) completerBlock([[responseObject objectForKey:@"data"] objectForKey:@"shortUrl"]);
            }];
        }else{
            if (completerBlock) completerBlock(self.shareUrl);
        }
        
    }else{
        if (completerBlock) completerBlock(self.shareUrl);
    }
}

-(void)checkURLWithisApp:(BOOL)partyPlatfromType
{
    NSString * hostName = [NSURL URLWithString:[self.shareUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]].host;
    if (partyPlatfromType && [WjjH5_Host containsString:hostName]) {//分享对外平台
        __block NSMutableDictionary * tempDict = [[NSMutableDictionary alloc] init];
        NSDictionary * paramDict = [CNLiveShareHelper requestURLParameters:self.shareUrl];
        [paramDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [tempDict setObject:obj forKey:key];
            if ([key isEqualToString:@"isApp"] && [obj isEqualToString:@"true"] && partyPlatfromType) {
                [tempDict setObject:@"false" forKey:@"isApp"];
            }
        }];
        if (![[tempDict allKeys] containsObject:@"isApp"]) [tempDict setObject:@"false" forKey:@"isApp"];
        [tempDict removeObjectsForKeys:@[@"plat",@"ver",@"verson"]];
        [tempDict setObject:@"i" forKey:@"plat"];
        if (![paramDict safeObjectForKey:@"apple"]) [tempDict setObject:@"apple" forKey:@"wjjFrom"];
        [tempDict setObject:CNLiveStringgetLocalAppBuildVersion forKey:@"ver"];
        [tempDict setObject:CNLiveStringgetLocalAppVersion forKey:@"version"];
        
        NSMutableString * tempString = [[NSMutableString alloc] initWithString:[self.shareUrl componentsSeparatedByString:@"?"].firstObject];
        if (tempDict != nil) {
            [tempString appendString:@"?"];
            [tempDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [tempString appendFormat:@"%@=%@&",key,obj];
            }];
            [tempString deleteCharactersInRange:NSMakeRange(tempString.length-1, 1)];
        }
        self.shareUrl = tempString;
    }else{
        if ([WjjH5_Host containsString:hostName]) {//分享对内平台
            NSMutableDictionary * paramDict = [CNLiveShareHelper requestURLParameters:self.shareUrl].mutableCopy;
            if (![paramDict safeObjectForKey:@"apple"]) [paramDict setObject:@"apple" forKey:@"wjjFrom"];
            if ([paramDict safeObjectForKey:@"isApp"]) [paramDict setObject:@"true" forKey:@"isApp"];
            NSMutableString * tempString = [[NSMutableString alloc] initWithString:[self.shareUrl componentsSeparatedByString:@"?"].firstObject];
            if (paramDict != nil) {
                [tempString appendString:@"?"];
                [paramDict removeObjectsForKeys:@[@"plat",@"ver",@"verson"]];
                [paramDict setObject:@"i" forKey:@"plat"];
                [paramDict setObject:CNLiveStringgetLocalAppBuildVersion forKey:@"ver"];
                [paramDict setObject:CNLiveStringgetLocalAppVersion forKey:@"version"];
                [paramDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    [tempString appendFormat:@"%@=%@&",key,obj];
                }];
                [tempString deleteCharactersInRange:NSMakeRange(tempString.length-1, 1)];
            }
            self.shareUrl = tempString;
        }else{
            self.shareUrl = self.shareUrl;
        }
    }
}

-(NSInteger)checkURLWithSid
{
    if (![self isCNLive]) return 4;
    NSArray * sourceArray = [self.shareUrl componentsSeparatedByString:@"?"];
    if (sourceArray.count==1) return 0;
    NSString * paramString = sourceArray.lastObject;
    NSArray * tempArray = [paramString componentsSeparatedByString:@"&"];
    BOOL _isReplacing = YES;
    for (NSString * res in tempArray) {
        if ([[res componentsSeparatedByString:@"="].firstObject isEqualToString:@"shareSid"]) {
            self.shareUrl = [self.shareUrl stringByReplacingOccurrencesOfString:res withString:[NSString stringWithFormat:@"shareSid=%@",CNUserShareModel.uid]];
            _isReplacing = NO;
            continue;
        }
        if ([[res componentsSeparatedByString:@"="].firstObject isEqualToString:@"sid"]) {
            self.shareUrl = [self.shareUrl stringByReplacingOccurrencesOfString:res withString:[NSString stringWithFormat:@"sid=%@",CNUserShareModel.uid]];
            _isReplacing = NO;
            continue;
        }
    }
    return _isReplacing ? 1: 2;
}

- (NSString *)shareUrlDelegateVersionWithCurrentUrl:(NSString *)shareUrl {
    
    if (shareUrl && [shareUrl containsString:@"ver="]) {
        NSString *verStr = [[shareUrl componentsSeparatedByString:@"ver="] lastObject];
        NSString *ver = [[verStr componentsSeparatedByString:@"&"] firstObject];
        return [shareUrl stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"&ver=%@",ver] withString:@""];
    } else {
        return shareUrl;
    }
}
-(void)showAlertViewTipString:(NSString *)tipString
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:tipString message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:NULL];
    [actionSheet addAction:action];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:actionSheet animated:YES completion:^{
        
    }];
    return;
}
-(BOOL)isCNLive
{
    NSString * hostString = [NSURL URLWithString:self.shareUrl].host;
    if ([hostString isEqualToString:@"wjjh5.cnlive.com"] || [hostString isEqualToString:@"wjjh5test.cnlive.com"]) {
        return YES;
    }
    return NO;
}
#pragma mark -Lazy
-(NSMutableArray *)shareDataArray
{
    if (!_shareDataArray) {
        _shareDataArray = [[NSMutableArray alloc] init];
        NSMutableArray * titleArray = [[NSMutableArray alloc] init];
        NSMutableArray * imageArray = [[NSMutableArray alloc] init];
        NSString * pathUrl = [[NSBundle mainBundle] pathForResource:@"CNLiveShareToolDataSource.plist" ofType:nil];
        NSArray * tempArray = [[NSArray alloc] initWithContentsOfFile:pathUrl];
        for (int i = 0; i<tempArray.count; i++) {
            NSDictionary * obj = (NSDictionary *)tempArray[i];
            NSString * shareName = [obj objectForKey:@"shareName"];
            NSString * shareImage = [obj objectForKey:@"shareImage"];
            BOOL isContinue = YES;
            if ([shareName isEqualToString:@"网家家好友"] && !self.isHiddenWjj) {
                [titleArray addObject:shareName];
                [imageArray addObject:shareImage];
                continue;
            }else{
                isContinue = NO;
            }
            if ([shareName isEqualToString:@"生活圈"] && !self.isHiddenWjj) {
                [titleArray addObject:shareName];
                [imageArray addObject:shareImage];
                continue;
            }else{
                isContinue = NO;
            }
            if ([shareName isEqualToString:@"微信"] && [WXApi isWXAppInstalled] && !self.isHiddenWechat) {
                [titleArray addObject:shareName];
                [imageArray addObject:shareImage];
                continue;
            }else{
                isContinue = NO;
            }
            if ([shareName isEqualToString:@"朋友圈"] && [WXApi isWXAppInstalled] && !self.isHiddenWechat) {
                [titleArray addObject:shareName];
                [imageArray addObject:shareImage];
                continue;
            }else{
                isContinue = NO;
            }
            if ([shareName isEqualToString:@"QQ好友"] && [TencentOAuth iphoneQQInstalled] && !self.isHiddenQQ) {
                [titleArray addObject:shareName];
                [imageArray addObject:shareImage];
                continue;
            }else{
                isContinue = NO;
            }
            if ([shareName isEqualToString:@"新浪微博"] && [WeiboSDK isWeiboAppInstalled] && !self.isHiddenWB) {
                [titleArray addObject:shareName];
                [imageArray addObject:shareImage];
                continue;
            }else{
                isContinue = NO;
            }
            if ([shareName isEqualToString:@"Safari打开"] && !self.isHiddenSafari) {
                [titleArray addObject:shareName];
                [imageArray addObject:shareImage];
                continue;
            }else{
                isContinue = NO;
            }
            if (isContinue) {
                [titleArray addObject:shareName];
                [imageArray addObject:shareImage];
            }
        }
        [_shareDataArray addObject:titleArray];
        [_shareDataArray addObject:imageArray];
    }
    return _shareDataArray;
}
#pragma mark - show&hidden
// 显示
- (void)show
{
    CGFloat bgH = kSelfHeight+kVerticalBottomSafeHeight_Share+(_isShowBot ? 100 : 0);

    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
    
    if (self.platType == CNLiveSharePlatformTypeAll) {
        
        self.isFull ? [self setFullSetup] : [self setUp];
        
    }else{
        [self touchSharePlatformType:self.platType];
    }
    
    [self.appRootViewController.view addSubview:self];
    
    NSTimeInterval i     = 0;
    NSTimeInterval delay = 0;
    
    for (UIView *subView in self.shareView.subviews) {
        
        if ([subView isKindOfClass:[UIScrollView class]]) {
            
            UIScrollView *scrollView = (UIScrollView *)subView;
            
            for (UIView *subView in scrollView.subviews) {
                if ([subView isKindOfClass:[CNLiveShareCustomButton class]]) {
                    if (i == 5) {
                        delay = 0;
                    }
                    delay += 0.04;
                    i += 1;
                    
                    CNLiveShareCustomButton *shareBtn = (CNLiveShareCustomButton *)subView;
                    [shareBtn shakeBtnWithDely:delay];
                }
            }
        }
    }
    
    self.alpha = 0.0f;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2f animations:^{
        weakSelf.alpha = 1.0f;
        if (weakSelf.isFull) {
            weakSelf.shareView.frame = CGRectMake(0, KScreenWidth_Share - bgH, KScreenHeight_Share, bgH);
        }else{
            weakSelf.shareView.frame = CGRectMake(0, KScreenHeight_Share - bgH, KScreenWidth_Share, bgH);
        }
    } completion:^(BOOL finished) {
        
    }];
}
// 关闭
- (void)dismiss
{    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2f animations:^{
        if (weakSelf.isFull) {
            weakSelf.shareView.frame = CGRectMake(0, KScreenWidth_Share, KScreenHeight_Share, (kSelfHeight+kVerticalBottomSafeHeight_Share));
        }else{
            weakSelf.shareView.frame = CGRectMake(0, KScreenHeight_Share, KScreenWidth_Share, (kSelfHeight+kVerticalBottomSafeHeight_Share));
        }
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (UIViewController *)appRootViewController
{
    UIViewController *RootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *topVC = RootVC;
    
    while (topVC.presentedViewController) {
        
        topVC = topVC.presentedViewController;
        
    }
    return topVC;
}
@end
