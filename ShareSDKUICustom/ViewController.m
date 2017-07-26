//
//  ViewController.m
//  ShareSDKUICustom
//
//  Created by QiLu on 2017/7/25.
//  Copyright © 2017年 QiLu. All rights reserved.
//

#import "ViewController.h"
#import "ShareSDKMethod.h"
@interface ViewController ()<UIAlertViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat btnWidth = 100;
    CGFloat btnHeight = 30;
    CGFloat x = (SCREEN_WIDTH - btnWidth)/2;
    for (int i = 1; i<=3; i++) {
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shareBtn.frame = CGRectMake(x, 180 + i*(btnHeight + 50), btnWidth, btnHeight);
        shareBtn.backgroundColor = [UIColor yellowColor];
        [shareBtn setTitle:[NSString stringWithFormat:@"分享%d",i] forState:UIControlStateNormal];
        [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        shareBtn.tag = 1000 + i;
        [shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:shareBtn];
    }
}
-(void)shareAction:(UIButton*)shareBtn
{
    NSInteger tag = shareBtn.tag - 1000;
    NSString *message = @"DEMO未通过审核，无法分享。具体配置各平台分享文档连接--http://bbs.mob.com/forum.php?mod=viewthread&tid=275&page=1&extra=#pid860";
    switch (tag) {
        case 1://单纯分享
        {
            [ShareSDKMethod ShareTextActionWithTitle:@"分享标题" ShareContent:@"分享内容" ShareUlr:@"https://www.baidu.com" IsCollect:NO IsReport:NO IsCollected:NO Report:nil Collect:nil Result:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                //分享之后的回调 在这里可以收集分享数据
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
                alertView.delegate = self;
                [alertView show];
            }];
        }
            break;
        case 2://分享和自己的功能混合
        {
            [ShareSDKMethod ShareTextActionWithTitle:@"分享标题" ShareContent:@"分享内容" ShareUlr:@"https://www.baidu.com" IsCollect:YES IsReport:NO IsCollected:YES Report:nil Collect:^{
                //这里用来实现自己的功能 例如收藏
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"收藏成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
                alertView.delegate = self;
                [alertView show];
            } Result:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                //分享之后的回调 在这里可以收集分享数据
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
                alertView.delegate = self;
                [alertView show];
            }];
        }
            break;
        case 3://分享和自己的功能混合
        {
            [ShareSDKMethod ShareTextActionWithTitle:@"分享标题 " ShareContent:@"分享内容" ShareUlr:@"https://www.baidu.com" IsCollect:YES IsReport:YES IsCollected:YES Report:^{
                //这里用来实现自己的功能 例如举报
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"举报成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
                alertView.delegate = self;
                [alertView show];
            } Collect:^{
                //这里用来实现自己的功能 例如收藏
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"收藏成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
                alertView.delegate = self;
                [alertView show];
            } Result:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                //分享之后的回调 在这里可以收集分享数据
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
                alertView.delegate = self;
                [alertView show];
            }];
        }
            break;
        default:
            break;
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://bbs.mob.com/forum.php?mod=viewthread&tid=275&page=1&extra=#pid860"]];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
