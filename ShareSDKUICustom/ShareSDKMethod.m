//
//  ShareSDKMethod.m
//  QLYDPro
//
//  Created by QiLu on 2017/4/26.
//  Copyright © 2017年 zxy. All rights reserved.
//
//分享自定义UI
#import "ShareSDKMethod.h"
@implementation ShareSDKMethod

+(void)ShareTextActionWithTitle:(NSString*)title ShareContent:(NSString*)content ShareUlr:(NSString*)url IsCollect:(BOOL)isCollect IsReport:(BOOL)isReport IsCollected:(BOOL)isCollected Report:(ReportBlock)reportBlock Collect:(CollectBlock)collectBlock Result:(ResultBlock)resultBlock
{
    //设置分享参数
    myReportBlock = reportBlock;
    myCollectBlock = collectBlock;
    myResultBlock = resultBlock;
    myIsReport = isReport;
    myIsCollct = isCollect;
    myIsCollected = isCollected;
    UIImage *iconImage = [UIImage imageNamed:@"Icon"];
    _shareParams = [NSMutableDictionary dictionary];
    //QQ
    [_shareParams SSDKSetupQQParamsByText:title title:title url:[NSURL URLWithString:url] thumbImage:nil image:iconImage type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQQFriend];
    //微信朋友圈
    [_shareParams SSDKSetupWeChatParamsByText:title title:title url:[NSURL URLWithString:url] thumbImage:nil image:iconImage musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    //微信
    [_shareParams SSDKSetupWeChatParamsByText:title title:title url:[NSURL URLWithString:url] thumbImage:nil image:iconImage musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    //空间
    [_shareParams SSDKSetupQQParamsByText:title title:title url:[NSURL URLWithString:url] thumbImage:nil image:iconImage type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQZone];
    //微博
    [_shareParams SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@%@",title,url] title:title image:iconImage url:[NSURL URLWithString:url] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
    //创建UI
    [self createCustomUIWithCollect:isCollect Report:isReport];
}
//自定义分享UI
+(void)createCustomUIWithCollect:(BOOL)isCollect Report:(BOOL)isReport
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    
    //透明蒙层
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    grayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    grayView.tag = 60000;
    UITapGestureRecognizer *tapGrayView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelShareAction)];
    [grayView addGestureRecognizer:tapGrayView];
    grayView.userInteractionEnabled = YES;
    [window addSubview:grayView];
    
    //分享控制器
    UIView *shareBackView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 150*HEIGHT_SCALE)];
    shareBackView.backgroundColor =[UIColor whiteColor];
    shareBackView.tag = 60001;
    [window addSubview:shareBackView];
    
    //分享图标和标题数组
    NSArray *imageNameArr = @[@"share_qq",@"share_weichat_zone",@"share_weichat",@"share_zone",@"share_weibo"];
    NSMutableArray *imagesArr = [NSMutableArray array];
    for (NSString *imageName in imageNameArr) {
        UIImage *image = [UIImage imageNamed:imageName];
        [imagesArr addObject:image];
    }
    NSArray *titlesArr = @[@"QQ",@"朋友圈",@"微信",@"空间",@"微博"];
    NSMutableArray *titleNameArr = [NSMutableArray array];
    for (NSString *title in titlesArr) {
        [titleNameArr addObject:title];
    }
    //分享栏中添加自己的功能，比如收藏、举报之类的
    if (isCollect) {
        if (myIsCollected) {
            [imagesArr addObject:[UIImage imageNamed:@"share_colect_select"]];
        }else
        {
            [imagesArr addObject:[UIImage imageNamed:@"share_colect_normal"]];
        }
        [titleNameArr addObject:@"收藏"];
    }
    if (isReport) {
        [imagesArr addObject:[UIImage imageNamed:@"share_report"]];
        [titleNameArr addObject:@"举报"];
    }
    //分享按钮
    CGFloat itemWidth = 32;
    CGFloat itemHeight = 32+25;
    CGFloat spaceX = (SCREEN_WIDTH-32*5)/6;
    CGFloat spaceY = 16;
    NSInteger rowCount = 5;
    for (int i =0; i<titleNameArr.count; i++) {
        UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        iconBtn.frame = CGRectMake(spaceX + (i%rowCount)*(itemWidth+spaceX), 24 + (i/rowCount)*(itemHeight+spaceY), itemWidth, itemWidth);
        [iconBtn setImage:imagesArr[i] forState:UIControlStateNormal];
        iconBtn.tag = 2000 + i;
        [iconBtn addTarget:self action:@selector(shareItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [shareBackView addSubview:iconBtn];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
        titleLabel.center = CGPointMake(CGRectGetMinX(iconBtn.frame)+itemWidth/2, CGRectGetMaxY(iconBtn.frame)+10);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:12.0];
        titleLabel.text = titleNameArr[i];
        [shareBackView addSubview:titleLabel];
    }
    
    if (titleNameArr.count<=5) {
        shareBackView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 150*HEIGHT_SCALE/2 + 20);
    }
    [UIView animateWithDuration:0.35 animations:^{
        shareBackView.frame = CGRectMake(0, SCREEN_HEIGHT-shareBackView.frame.size.height, shareBackView.frame.size.width, shareBackView.frame.size.height);
    }];
    
}
+(void)shareItemAction:(UIButton*)button
{
    [self removeShareView];
    NSInteger sharetype = 0;
    NSMutableDictionary *publishContent = _shareParams;
    switch (button.tag) {
        case 2000:
        {
            sharetype = SSDKPlatformSubTypeQQFriend;
        }
            break;
        case 2001:
        {
            sharetype = SSDKPlatformSubTypeWechatTimeline;
        }
            break;
        case 2002:
        {
            sharetype = SSDKPlatformSubTypeWechatSession;
        }
            break;
        case 2003:
        {
            sharetype = SSDKPlatformSubTypeQZone;
        }
            break;
        case 2004:
        {
            sharetype = SSDKPlatformTypeSinaWeibo;
            [publishContent SSDKEnableUseClientShare];
        }
            break;
        case 2005:
        {
            if (myIsCollct)
            {
                if (myCollectBlock) {
                    myCollectBlock();
                }
            }else
            {
                if (myReportBlock) {
                    myReportBlock();
                }
            }
        }
            break;
        case 2006:
        {
            if (myReportBlock) {
                myReportBlock();
            }
        }
            break;
        default:
            break;
    }
    if (sharetype == 0)
    {
        [self removeShareView];
    }else
    {
        //调用ShareSDK的无UI分享方法
        [ShareSDK share:sharetype parameters:publishContent onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            if (myResultBlock) {
                myResultBlock(state,sharetype,userData,contentEntity,error);
            }
        }];
    }
}
//点击分享栏之外的区域 取消分享 移除分享栏
+(void)removeShareView{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *blackView = [window viewWithTag:60000];
    UIView *shareView = [window viewWithTag:60001];
    shareView.frame =CGRectMake(0, shareView.frame.origin.y, shareView.frame.size.width, shareView.frame.size.height);
    [UIView animateWithDuration:0.35 animations:^{
        shareView.frame = CGRectMake(0, SCREEN_HEIGHT, shareView.frame.size.width, shareView.frame.size.height);
    } completion:^(BOOL finished) {
        
        [shareView removeFromSuperview];
        [blackView removeFromSuperview];
    }];
    
    
}
+(void)cancelShareAction{
    
    [self removeShareView];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"KNotiVideoPlayForShare" object:nil];
}

@end
