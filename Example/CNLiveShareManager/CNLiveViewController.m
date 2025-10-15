//
//  CNLiveViewController.m
//  CNLiveShareManager
//
//  Created by woshiliushiyu on 12/11/2018.
//  Copyright (c) 2018 woshiliushiyu. All rights reserved.
//

#import "CNLiveViewController.h"
#import "CNLiveShareManager.h"
@interface CNLiveViewController ()<CNLiveShareManagerDelegate>

@end

@implementation CNLiveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [CNLiveShareManager shareDefaultsManager].delegate = self;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
//    [CNLiveShareManager showShareViewWithParamForShareTitle:@"nihaoma " ShareUrl:@"https://www.baidu.com" ShareDesc:@"ddjdjjfj" ShareImage:@"https://apiwjjtest.cnlive.com/static/logo.png" ScreenFull:NO PlatformType:CNLiveSharePlatformTypeAll CompleterBlock:^(CNLiveShareResultType resultType) {
//
//    }];
//    [CNLiveShareManager showShareViewWithBottemViewButtonsParamForShareTitle:@"nihaoma " ShareUrl:@"https://www.baidu.com" ShareDesc:@"ddjdjjfj" ShareImage:@"https://apiwjjtest.cnlive.com/static/logo.png" ScreenFull:NO Image:@[[UIImage imageNamed:@"observer_fx_trash"]] Titles:@[@"ddddd"] PlatformType:CNLiveSharePlatformTypeAll TouchActionBlock:^(NSString *title) {
//
//    } CompleterBlock:^(CNLiveShareResultType resultType) {
//
//    }];
    
    [CNLiveShareManager showShareViewWithParamForShareTitle:@"nihaoma" ShareUrl:@"https://www.baidu.com" ShareDesc:@"ddjdjjfj" ShareImage:@"https://apiwjjtest.cnlive.com/static/logo.png" ScreenFull:NO HiddenWjj:NO HiddenQQ:NO HiddenWB:NO HiddenWechat:NO HiddenSafari:NO TopImage:nil TopTitles:nil PlatformType:CNLiveSharePlatformTypeAll TouchActionBlock:NULL CompleterBlock:^(CNLiveShareResultType resultType, CNLiveSharePlatformType platformType, NSString *typtString) {
        NSLog(@"回调结果");
    }];
}
-(void)shareWithPlatformType:(CNLiveSharePlatformType)fromType ShareName:(NSString *)shareName ShareDesc:(NSString *)shareDesc ShareUrl:(NSString *)ShareUrl ShareImage:(id)shareImage Full:(BOOL)isFull ShareType:(NSInteger)shareType
{
    NSLog(@"点击我了");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
