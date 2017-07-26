//
//  ShareSDKMethod.h
//  QLYDPro
//
//  Created by QiLu on 2017/4/26.
//  Copyright © 2017年 zxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//不同宽度的和320宽度的缩放比
#define WIDTH_SCALE (SCREEN_WIDTH/320.f)
#define HEIGHT_SCALE  (SCREEN_HEIGHT/568.f)

typedef void (^ReportBlock)();
typedef void (^CollectBlock)();
typedef void (^ResultBlock)(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error);
static NSMutableDictionary *_shareParams;
static ReportBlock myReportBlock;
static CollectBlock myCollectBlock;
static ResultBlock myResultBlock;
static BOOL myIsCollct;//是否有收藏按钮
static BOOL myIsReport;//是否有举报按钮
static BOOL myIsCollected;//收藏选中状态
@interface ShareSDKMethod : NSObject

+(void)ShareTextActionWithTitle:(NSString*)title ShareContent:(NSString*)content ShareUlr:(NSString*)url IsCollect:(BOOL)isCollect IsReport:(BOOL)isReport IsCollected:(BOOL)isCollected Report:(ReportBlock)reportBlock Collect:(CollectBlock)collectBlock Result:(ResultBlock)resultBlock;

@end
