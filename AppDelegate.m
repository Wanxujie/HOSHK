//
//  AppDelegate.m
//  HOSHK
//
//  Created by Pain on 13年10月23日.
//  Copyright (c) 2013年 Pain. All rights reserved.
//

#import "AppDelegate.h"
#import "packetDataSource.h"


@implementation AppDelegate
{
    NSString *classID;
    NSString *mymsgID;
    
}
#pragma mark - 处理授权反馈信息
//- (void)sessionStateChanged:(FBSession *)currentSession
//                      state:(FBSessionState) state
//                      error:(NSError *)error
//{
//    switch (state) {
//        case FBSessionStateOpen:
//            if (!error) {
//                // We have a valid session
//                //NSLog(@"User session found");
//                //授权成功,进行相关处理
//            }
//            break;
//        case FBSessionStateClosed:
//        case FBSessionStateClosedLoginFailed:
//            [FBSession.activeSession closeAndClearTokenInformation];
//            break;
//        default:
//            break;
//    }
//    
//    [[NSNotificationCenter defaultCenter]
//     postNotificationName:@"FBSessionStateChangedNotification"
//     object:currentSession];
//    
//    /*
//     if (error) {
//     UIAlertView *alertView = [[UIAlertView alloc]
//     initWithTitle:@"Error"
//     message:error.localizedDescription
//     delegate:nil
//     cancelButtonTitle:@"OK"
//     otherButtonTitles:nil];
//     [alertView show];
//     }
//     */
//}

#pragma mark - 打开授权页面
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    
    
    //  return  [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"] defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:allowLoginUI
    //                                     completionHandler:^(FBSession *currentSession,
    //                                                         FBSessionState state,
    //                                                         NSError *error) {
    //
    //                                         [self sessionStateChanged:currentSession
    //                                                             state:state
    //                                                             error:error];
    //                                     }];
    
    
    
//    FBSession *appLinkSession = [[FBSession alloc] initWithAppID:nil
//                                                     permissions:[NSArray arrayWithObject:@"publish_actions"]
//                                                 defaultAudience:FBSessionDefaultAudienceEveryone
//                                                 urlSchemeSuffix:nil
//                                              tokenCacheStrategy:[FBSessionTokenCachingStrategy nullCacheInstance]];
//    //[FBSessionTokenCachingStrategy nullCacheInstance]
//    
//    [FBSession setActiveSession:appLinkSession];
//    [appLinkSession openWithBehavior:FBSessionLoginBehaviorForcingWebView completionHandler:^(FBSession *currentSession, FBSessionState status, NSError *error) {
//        [self sessionStateChanged:currentSession
//                            state:status
//                            error:error];
//        
//    }];
    
    return YES;
}

#pragma mark - 注销授权
- (void) closeSession
{
//    [FBSession.activeSession closeAndClearTokenInformation];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    application.statusBarHidden = YES;
    
    //谷歌地图
    [GMSServices provideAPIKey:GoogleAPIKey];
    
    //创建数据库
    [[DBManager singletonNetManager] createDatabase];
    
    [[DBManager singletonNetManager] createNoticelTable];
    [[DBManager singletonNetManager] createNoticeSecondaryTable];
    [[DBManager singletonNetManager] createNoticeContentTable];
    [[DBManager singletonNetManager] createUseFullTable];
    [[DBManager singletonNetManager] createUseFullDetailTable];
    [[DBManager singletonNetManager] createUseFullThirdLevelTable];
    [[DBManager singletonNetManager] createBookHistoryTable];
    [[DBManager singletonNetManager] createCollectionTable];
    [[DBManager singletonNetManager] createShopDetailTable];
    [[DBManager singletonNetManager] createPrintingTable];
    [[DBManager singletonNetManager] createCommentUseTable];
    [[DBManager singletonNetManager] createPacketTable];
    [[DBManager singletonNetManager] createPacketUpdataTimeTable];
    [[DBManager singletonNetManager] createPacketNoticeTable];
    [[DBManager singletonNetManager] createPacketShopTable];
    
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isDeleNO"])
    {
        NSString *isDelete = @"no";
        [[NSUserDefaults standardUserDefaults] setObject:isDelete forKey:@"isDeleNO"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[DBManager singletonNetManager] deleteMypacket];
        [[DBManager singletonNetManager] deleteMyFavTable];
        
    }
    

    
    
    
    
    [[DBManager singletonNetManager] createMyPaketTable];
    
    [[DBManager singletonNetManager] createMyFavTable];
    
    [[DBManager singletonNetManager] createAFileToSaveDownloadImages];
    
    //    NSArray *languages = [NSLocale preferredLanguages];
    //    NSString *currentLanguage = [languages objectAtIndex:0];
    //    NSLog( @"%@" , currentLanguage);
    
    //保存密码
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isSaveUserNameAndPassWord"] == nil) {
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:@"isSaveUserNameAndPassWord"];
    }
    
    //屋院ID
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"EstateId"] == nil || ![[[NSUserDefaults standardUserDefaults] objectForKey:@"isSaveUserNameAndPassWord"] boolValue])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"EstateId" forKey:@"EstateId"];
    }
    
    //判断是否在主页
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:@"isHomePage"];
    
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSMutableArray array] forKey:@"receavePushTag"];
    
    //屋院ID
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"PushTag"] == nil || ![[[NSUserDefaults standardUserDefaults] objectForKey:@"isSaveUserNameAndPassWord"] boolValue]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"PushTag" forKey:@"PushTag"];
    }
    
    //处理推送通知
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(handleNotification) name:@"handleNotification" object:nil];
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"isSaveUserNameAndPassWord"] boolValue]) {
        //不保存密码
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"CurrentUserAcount"];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"CurrentPassword"];
        [[NSUserDefaults standardUserDefaults] setValue:[NSMutableDictionary dictionary] forKey:@"CurrentUserInfo"];
    } else {
        //[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isUserLogined"];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:@"isUserLogined"];
    
    //物业服务处坐标
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"locationAxis"];
    //物业服务电话
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"PSPhone"];
    //立案法团电话
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"OCPhone"];
    //判断字体大小
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"textFont"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"18" forKey:@"textFont"];
    }
    myLaunchOptions = [[NSDictionary alloc] initWithDictionary:launchOptions];
    [[NSUserDefaults standardUserDefaults] setObject:@"UnknowIdentification" forKey:@"token"];
    
    //判断用户是否接受推送提示
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isRegisterForRemoteNotification"]   isEqualToString:@"0"])
    {
        
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"isRegisterForRemoteNotification"];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:@"packetTag"];
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:@"comanTag"];
    
    // 语言
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"CH" forKey:@"currentLanguage"];
    }
    
    //注册是否接受咨询提示消息中心
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(isRegisterForRemoteNotification) name:@"isRegisterForRemoteNotification" object:nil];
    
    count = 0;
    
    //清空本地缓存消息中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteAllCachaedData) name:@"deleteAllCachaedData" object:nil];
    
    
    
    LoginViewController *root = [[LoginViewController alloc] init] ;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:root];
    //[root release];
    self.window.rootViewController = nav;
    nav.navigationBarHidden = YES;
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window = window;
    
    [self.window addSubview:nav.view];
    //[nav release];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    //打开或关闭推送
    [self isRegisterForRemoteNotification];
    
    /*
     NSArray *familyNames =[[NSArray alloc]initWithArray:[UIFont familyNames]];
     NSArray *fontNames;
     NSInteger indFamily, indFont;
     
     for(indFamily=0; indFamily < [familyNames count]; ++indFamily)
     {
     NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
     fontNames =[[NSArray alloc]initWithArray:[UIFont fontNamesForFamilyName:[familyNames objectAtIndex:indFamily]]];
     for(indFont=0; indFont<[fontNames count]; ++indFont)
     {
     NSLog(@"    Font name: %@",[fontNames objectAtIndex:indFont]);
     }
     [fontNames release];
     }
     [familyNames release];
     [[NSUserDefaults standardUserDefaults] synchronize];*/
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //取消登陆状态
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:@"isUserLogined"];
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:@"isHomePage"];
}

#pragma mark -  时都注册推送信息
- (void)isRegisterForRemoteNotification
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isRegisterForRemoteNotification"] isEqualToString:@"1"]) {
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self selector:@selector(networkDidSetup:) name:kJPFNetworkDidSetupNotification object:nil];
        [defaultCenter addObserver:self selector:@selector(networkDidClose:) name:kJPFNetworkDidCloseNotification object:nil];
        [defaultCenter addObserver:self selector:@selector(networkDidRegister:) name:kJPFNetworkDidRegisterNotification object:nil];
        [defaultCenter addObserver:self selector:@selector(networkDidLogin:) name:kJPFNetworkDidLoginNotification object:nil];
        [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
        
        //注册推送通知
        
        //categories 必须为nil
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            //可以添加自定义categories
            [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                           UIUserNotificationTypeSound |
                                                           UIUserNotificationTypeAlert)
                                               categories:nil];
        }
        else {
            //categories 必须为nil
            [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                           UIRemoteNotificationTypeSound |
                                                           UIRemoteNotificationTypeAlert)
                                               categories:nil];
        }
        
        
        //categories 必须为nil
        
        
        //[APService setTags:[NSSet setWithObjects:@"123", nil] alias:@"123"];
        
        [APService setupWithOption:myLaunchOptions];
        
        //设置标签
        NSString *Building = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"PushTag"]];
        
        //[APService setTags:[NSSet setWithObjects:Building, nil] alias:nil];
        
        [APService setTags:[NSSet setWithObjects:Building, nil] alias:nil callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    }
    else
    {
        //取消推送功能
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

#pragma mark - 推送信息协议方法实现
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSUserDefaults *token = [NSUserDefaults standardUserDefaults];
    [token setObject:deviceToken forKey:@"token"];
    [token synchronize];
    
    //成功注册远程推送通知，上传手机令牌到服务器
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"err---------------%@",[err localizedDescription]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    NSLog(@"%@",userInfo);
    NSLog(@"userInfo---------------%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
    classID = [[NSString alloc] initWithString:[userInfo objectForKey:@"classID"]];
    mymsgID = [[NSString alloc] initWithString:[userInfo objectForKey:@"msgID"]];
    NSLog(@"%@ = = = = = %@",classID,mymsgID);
    
    
    //程序处于启动状态，或者在后台运行时，会接收到推送消息，解析处理
    //    //把icon上的标记数字设置为0,
    //    NSLog(@"dasfasdfdasfdsa-----%i",application.applicationIconBadgeNumber-1);
    ////    application.applicationIconBadgeNumber = application.applicationIconBadgeNumber-1;
    //    NSLog(@"------------------%@",[[userInfo objectForKey:@"aps"] objectForKey:@"badge"]);
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"succ"])
    {
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguage"]isEqualToString:@"CH"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確認", nil];
            alert.tag = 88;
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            alert.tag = 88;
            [alert show];
        }
        
    }
    else if (![classID isEqualToString:@"0"]&&![[NSUserDefaults standardUserDefaults] objectForKey:@"succ"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请先登录" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else if ([classID isEqualToString:@"0"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alertView show];
    }
    //else if ([classID isEqualToString:<#(NSString *)#>])
    
    application.statusBarHidden = YES;
    application.applicationIconBadgeNumber = 0;
    //处理收到的APNS消息，向服务器上报收到APNS消息
    [APService handleRemoteNotification:userInfo];
    
    /*
     //处理用户登陆以及未登录情况下的推送信息
     if (([noticeID isEqualToString:@"1"] || [noticeID isEqualToString:@"2"]) && ![[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogined"] boolValue]) {
     [self performSelector:@selector(UserLogin)];
     }
     else {
     [self handleRemoteNotification:noticeID withContentID:contentID];
     }
     */
}

#pragma mark - 消息中心相应方法
- (void)networkDidSetup:(NSNotification *)notification {
    NSLog(@"Connected...............");
}

- (void)networkDidClose:(NSNotification *)notification {
    NSLog(@"DisConnected...............");
}

- (void)networkDidRegister:(NSNotification *)notification {
    NSLog(@"Registed...............");
}

- (void)networkDidLogin:(NSNotification *)notification {
    NSLog(@"[notification userInfo]----------------%@",[notification userInfo]);
    NSLog(@"DidLogin...............");
}

- (void)networkDidReceiveMessage:(NSNotification *)notification
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    NSLog(@"-----------%@",[notification userInfo]);
    
    /*
     count ++;
     if (count == 1 ) {
     noticeID = [[NSString alloc] initWithFormat:@"%@",[[[notification userInfo] objectForKey:@"extras"] objectForKey:@"classID"]];
     contentID = [[NSString alloc] initWithFormat:@"%@",[[[notification userInfo] objectForKey:@"extras"] objectForKey:@"msgID"]];
     
     NSLog(@"noticeID-------%@-------contentID--------%@",noticeID,contentID);
     
     if ([noticeID isEqualToString:@"0"]) {
     //处理纯消息
     [self showMessageWithMsgID:contentID];
     }
     else if([noticeID length]){
     UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
     message:@"有新資訊推送,是否前往查看?"
     delegate:self
     cancelButtonTitle:@"取消"
     otherButtonTitles:@"確定",nil];
     alert.tag = 4;
     [alert show];
     [alert release];
     }
     
     */
    
    count ++;
    if (count == 1 )
    {
        noticeID = [[NSString alloc] initWithFormat:@"%@",[[[notification userInfo] objectForKey:@"extras"] objectForKey:@"classID"]];
        contentID = [[NSString alloc] initWithFormat:@"%@",[[[notification userInfo] objectForKey:@"extras"] objectForKey:@"msgID"]];
        
        NSString *receavePushTag = [[NSString alloc] initWithFormat:@"%@",[[[notification userInfo] objectForKey:@"extras"] objectForKey:@"tag"]];
        [[NSUserDefaults standardUserDefaults] setValue:[NSMutableArray arrayWithArray:[receavePushTag  componentsSeparatedByString:@","]] forKey:@"receavePushTag"];
        
        
        NSLog(@"noticeID-------%@-------contentID--------%@",noticeID,contentID);
        NSLog(@"receavePushTag--------------%@",receavePushTag);
        
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isHomePage"] boolValue])
        {
            //应用在主页
            if ([noticeID isEqualToString:@"0"])
            {
                //处理纯消息
                [self showMessageWithMsgID:contentID];
            }
            else{
                //详细信息
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"有新資訊推送,是否前往查看?"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"確定",nil];
                alert.tag = 4;
                [alert show];
                
            }
        }
        else {
            //应用在登陆页面
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"有新資訊推送,請登入查看"
                                                           delegate:nil
                                                  cancelButtonTitle:@"確定"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 4) {
        if (buttonIndex==1) {
            [self handleRemoteNotification:noticeID withContentID:contentID];
        }
        count = 0;
    }
    else if(alertView.tag == 5){
        count = 0;
    }
    if (alertView.tag == 88&&buttonIndex == 1)
    {
        NSMutableDictionary * sendDic;
        if ([classID isEqualToString:@"3"]) {
            NSArray * tempArr2 = [[NSArray alloc] initWithArray:[[[[netManager singletonNetController] getCommunityContentWithNoticeId:mymsgID]objectForKey:@"GetCommunityContentResult"] JSONValue]];
            
            sendDic = [[NSMutableDictionary alloc] initWithCapacity:0];
            [sendDic setValue:tempArr2 forKey:@"dataSource"];
            [sendDic setValue:@"Community" forKey:@"tableName"];
            [sendDic setValue:[NSNumber numberWithBool:NO] forKey:@"isComeFromCommonUse"];
        }else
        {
            NSArray *tempArr2 = [[NSArray alloc] initWithArray:[[[[netManager singletonNetController] getNoticeContentWithNoticeId:mymsgID]objectForKey:@"GetNoticeContentResult"] JSONValue]];
            
            
            sendDic = [[NSMutableDictionary alloc] initWithCapacity:0];
            [sendDic setValue:tempArr2 forKey:@"dataSource"];
            if ([classID isEqualToString:@"1"]) {
                [sendDic setValue:@"ManagementOffice" forKey:@"tableName"];
            }else
            {
                [sendDic setValue:@"Incorporation" forKey:@"tableName"];
            }
            
            [sendDic setValue:[NSNumber numberWithBool:NO] forKey:@"isComeFromCommonUse"];
            
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            
            dispatch_async(queue, ^{
                [[packetDataSource sharedPacktedDataSource] startDownLoad];
                
                
            });
        }
        
            
            //调用消息中心把Contact和Notice推进来来
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PushNotice" object:sendDic];
            
        
    }
    else if (alertView.tag == 88 && buttonIndex == 0)
    {
        [[packetDataSource sharedPacktedDataSource] startDownLoad];
        
    }
}


#pragma mark - 处理推送信息
- (void)handleNotification{
    //用户登陆后提示接受推送
    if ([noticeID isEqualToString:@"0"]) {
        //处理纯消息
        [self showMessageWithMsgID:contentID];
    }
    else{
        //详细信息
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"有新資訊推送,是否前往查看?"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"確定",nil];
        alert.tag = 4;
        [alert show];
        
    }
}

- (void)handleRemoteNotification:(NSString *)_noticeID withContentID:(NSString *)_contentID{
    if ([_noticeID isEqualToString:@"1"]){
        if ([_contentID length]) {
            //物业服务处
            NSArray *tempArr2 = [[NSArray alloc] initWithArray:[[[[netManager singletonNetController] getNoticeContentWithNoticeId:_contentID] objectForKey:@"GetNoticeContentResult"] JSONValue]];
            NSLog(@"%@",tempArr2);
            NSMutableDictionary * sendDic = [[NSMutableDictionary alloc] initWithCapacity:0];
            [sendDic setValue:tempArr2 forKey:@"dataSource"];
            [sendDic setValue:@"ManagementOffice" forKey:@"tableName"];
            [sendDic setValue:[NSNumber numberWithBool:NO] forKey:@"isComeFromCommonUse"];
            
            
            //调用消息中心把Contact和Notice推进来来
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PushNotice" object:sendDic];
            
        }
    }
    else if([_noticeID isEqualToString:@"2"]){
        if ([_contentID length]) {
            //立案法团
            NSArray *tempArr2 = [[NSArray alloc] initWithArray:[[[[netManager singletonNetController] getNoticeContentWithNoticeId:_contentID] objectForKey:@"GetNoticeContentResult"] JSONValue]];
            
            NSMutableDictionary * sendDic = [[NSMutableDictionary alloc] initWithCapacity:0];
            [sendDic setValue:tempArr2 forKey:@"dataSource"];
            [sendDic setValue:@"Incorporation" forKey:@"tableName"];
            [sendDic setValue:[NSNumber numberWithBool:NO] forKey:@"isComeFromCommonUse"];
            
            
            //调用消息中心把Contact和Notice推进来来
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PushNotice" object:sendDic];
            
        }
    }
    else if([_noticeID isEqualToString:@"3"]){
        if ([_contentID length]) {
            //商铺1
            NSArray *tempArr2 = [[NSArray alloc] initWithArray:[[[[netManager singletonNetController] getShopDetailsV2WithShopId:_contentID andEstate:[[NSUserDefaults standardUserDefaults] objectForKey:@"Estate"]]  objectForKey:@"GetShopDetailsV2Result"] JSONValue]];
            NSMutableDictionary * sendDic = [[NSMutableDictionary alloc] initWithCapacity:0];
            [sendDic setValue:tempArr2 forKey:@"dataSource"];
            [sendDic setValue:@"ShopOne" forKey:@"tableName"];
            [sendDic setValue:[NSNumber numberWithBool:NO] forKey:@"isComeFromCommonUse"];
            
            
            //调用消息中心把Contact和Notice推进来来
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PushShopping" object:sendDic];
            
        }
    }
    else if ([_noticeID isEqualToString:@"4"]) {
        if ([_contentID length]) {
            //商铺2
            NSArray *tempArr2 = [[NSArray alloc] initWithArray:[[[[netManager singletonNetController] getShopDetailsV2WithShopId:_contentID andEstate:[[NSUserDefaults standardUserDefaults] objectForKey:@"Estate"]]  objectForKey:@"GetShopDetailsV2Result"] JSONValue]];
            NSMutableDictionary * sendDic = [[NSMutableDictionary alloc] initWithCapacity:0];
            [sendDic setValue:tempArr2 forKey:@"dataSource"];
            [sendDic setValue:@"ShopTwo" forKey:@"tableName"];
            [sendDic setValue:[NSNumber numberWithBool:NO] forKey:@"isComeFromCommonUse"];
            
            
            //调用消息中心把Contact和Notice推进来来
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PushShopping" object:sendDic];
            
        }
    }
    else if([_noticeID isEqualToString:@"5"]){
        if ([_contentID length]) {
            //商铺3
            NSArray *tempArr2 = [[NSArray alloc] initWithArray:[[[[netManager singletonNetController] getShopDetailsV2WithShopId:_contentID andEstate:[[NSUserDefaults standardUserDefaults] objectForKey:@"Estate"]]  objectForKey:@"GetShopDetailsV2Result"] JSONValue]];
            NSMutableDictionary * sendDic = [[NSMutableDictionary alloc] initWithCapacity:0];
            [sendDic setValue:tempArr2 forKey:@"dataSource"];
            [sendDic setValue:@"ShopThree" forKey:@"tableName"];
            [sendDic setValue:[NSNumber numberWithBool:NO] forKey:@"isComeFromCommonUse"];
            
            
            //调用消息中心把Contact和Notice推进来来
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PushShopping" object:sendDic];
            
        }
    }
    else if([_noticeID isEqualToString:@"6"]){
        if ([_contentID length]) {
            //商铺4
            NSArray *tempArr2 = [[NSArray alloc] initWithArray:[[[[netManager singletonNetController] getShopDetailsV2WithShopId:_contentID andEstate:[[NSUserDefaults standardUserDefaults] objectForKey:@"Estate"]]  objectForKey:@"GetShopDetailsV2Result"] JSONValue]];
            NSMutableDictionary * sendDic = [[NSMutableDictionary alloc] initWithCapacity:0];
            [sendDic setValue:tempArr2 forKey:@"dataSource"];
            [sendDic setValue:@"ShopFour" forKey:@"tableName"];
            [sendDic setValue:[NSNumber numberWithBool:NO] forKey:@"isComeFromCommonUse"];
            
            
            //调用消息中心把Contact和Notice推进来来
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PushShopping" object:sendDic];
            
        }
    }
    else if([_noticeID isEqualToString:@"7"]){
        if ([_contentID length]) {
            //商铺5
            NSArray *tempArr2 = [[NSArray alloc] initWithArray:[[[[netManager singletonNetController] getShopDetailsV2WithShopId:_contentID andEstate:[[NSUserDefaults standardUserDefaults] objectForKey:@"Estate"]]  objectForKey:@"GetShopDetailsV2Result"] JSONValue]];
            NSMutableDictionary * sendDic = [[NSMutableDictionary alloc] initWithCapacity:0];
            [sendDic setValue:tempArr2 forKey:@"dataSource"];
            [sendDic setValue:@"ShopFive" forKey:@"tableName"];
            [sendDic setValue:[NSNumber numberWithBool:NO] forKey:@"isComeFromCommonUse"];
            
            
            //调用消息中心把Contact和Notice推进来来
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PushShopping" object:sendDic];
            
        }
    }
    else if([_noticeID isEqualToString:@"8"]){
        if ([_contentID length]) {
            //商铺6
            NSArray *tempArr2 = [[NSArray alloc] initWithArray:[[[[netManager singletonNetController] getShopDetailsV2WithShopId:_contentID andEstate:[[NSUserDefaults standardUserDefaults] objectForKey:@"Estate"]]  objectForKey:@"GetShopDetailsV2Result"] JSONValue]];
            NSMutableDictionary * sendDic = [[NSMutableDictionary alloc] initWithCapacity:0];
            [sendDic setValue:tempArr2 forKey:@"dataSource"];
            [sendDic setValue:@"ShopSix" forKey:@"tableName"];
            [sendDic setValue:[NSNumber numberWithBool:NO] forKey:@"isComeFromCommonUse"];
            
            
            //调用消息中心把Contact和Notice推进来来
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PushShopping" object:sendDic];
            
            
        }
    }
    count = 0;
}

#pragma mark - 显示纯消息
- (void)showMessageWithMsgID:(NSString *)msgID{
    UIAlertView *alert1;
    alert1 = [[UIAlertView alloc]
              initWithTitle:NSLocalizedString(@"新資訊", nil)
              message:NSLocalizedString(@"\n\n\n\n\n\n", nil)
              delegate:self
              cancelButtonTitle:@"確定"
              otherButtonTitles:nil];
    alert1.tag = 5;
    [alert1 show];
    
    
    // NSLog(@"msgID-----------%@",msgID);
    
    UITextView *txt1 = [[UITextView alloc]initWithFrame:CGRectMake(12, 40, 260, 140)];
    txt1.backgroundColor = [UIColor whiteColor];
    txt1.editable = NO;
    
    NSMutableArray *contentArr = [[NSMutableArray alloc] initWithArray:[[[[netManager singletonNetController] getPushMsgByIdWithMessageId:msgID] objectForKey:@"GetPushMsgByIdResult"] JSONValue]];
    
    if ([contentArr count]) {
        txt1.text = [NSString stringWithFormat:@"%@",[[contentArr objectAtIndex:0] objectForKey:@"MsgContent"]];
        
    } else {
        txt1.text = @"";
    }
    
    txt1.font = [UIFont systemFontOfSize:15.0];
    [alert1 addSubview:txt1];
    
}

#pragma mark - 清空本地缓存图片
- (void)deleteAllCachaedData{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"];
    
    //NSLog(@"--------%@",documentsDirectory);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        
        [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        
        //        if ([[filename pathExtension] isEqualToString:@"png"] || [[filename pathExtension] isEqualToString:@"PDF"]) {
        //
        //        }
    }
}

@end
