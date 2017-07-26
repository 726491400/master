//
//  AppDelegate.m
//  ShareSDKUICustom
//
//  Created by QiLu on 2017/7/25.
//  Copyright © 2017年 QiLu. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ShareSDKMethod.h"

#import "WXApi.h"
#import "WeiboSDK.h"
#define ShareSdkAppKey @"1fb13bb716fa8"
@interface AppDelegate ()

@end

@implementation AppDelegate

/**
 *  设置ShareSDK的appKey
 *  在将生成的AppKey传入到此方法中。
 *  方法中的第二个参数用于指定要使用哪些社交平台，以数组形式传入。第三个参数为需要连接社交平台SDK时触发，
 *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
 *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
 */
-(void)ShareSDKRegister{
    [ShareSDK registerApp:ShareSdkAppKey
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformTypeSMS)
                            ]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                             
                         case SSDKPlatformTypeSinaWeibo:
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             
                             
                             break;
                             
                             
                         default:
                             break;
                     }
                     
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType)
              {
                  case SSDKPlatformTypeSinaWeibo:
                      //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                      [appInfo SSDKSetupSinaWeiboByAppKey:@"556733091"
                                                appSecret:@"e4a468c69b47c8e79baf76fc391eaea9"
                                              redirectUri:@"http://www.baidu.com"
                                                 authType:SSDKAuthTypeBoth];
                      break;
                      
                      
                      
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:@""
                                            appSecret:@""];
                      
                      break;
                  case SSDKPlatformTypeQQ:
                      [appInfo SSDKSetupQQByAppId:@""
                                           appKey:@""
                                         authType:SSDKAuthTypeBoth];
                      
                      break;
                      
                  default:
                      break;
              }
          }];
    
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    ViewController *vc = [[ViewController alloc]init];
    self.window.rootViewController = vc;
    [self ShareSDKRegister];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
