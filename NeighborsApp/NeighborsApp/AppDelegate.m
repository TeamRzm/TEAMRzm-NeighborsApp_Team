//
//  AppDelegate.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/3/26.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "AppDelegate.h"
#import "XGPush.h"
#import "XGSetting.h"
#import "AppSessionMrg.h"
#import "XGPusher.h"

#import "FileUpLoadHelper.h"

#import "NBRLoginViewController.h"

#define _IPHONE80_ 80000

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)registerPushForIOS8{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

- (void)registerPush
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [XGPush startApp:2200108162 appKey:@"I1HC1V12T8JD"];
    
    //注销之后需要再次注册前的准备
    void (^successCallback)(void) = ^(void){
        //如果变成需要注册状态
        if(![XGPush isUnRegisterStatus])
        {
            //iOS8注册push方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
            
            float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
            if(sysVer < 8){
                [self registerPush];
            }
            else{
                [self registerPushForIOS8];
            }
#else
            //iOS8之前注册push方法
            //注册Push服务，注册后才能收到推送
            [self registerPush];
#endif
        }
    };
    [XGPush initForReregister:successCallback];
    
    //推送反馈(app不在前台运行时，点击推送激活时)
    //[XGPush handleLaunching:launchOptions];
    
    //推送反馈回调版本示例
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]handleLaunching's successBlock");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]handleLaunching's errorBlock");
    };
    
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [XGPush handleLaunching:launchOptions successCallback:successBlock errorCallback:errorBlock];
    
    if ([AppSessionMrg shareInstance].userIsLogin)
    {
        [self showMainViewTabViewContller];
    }
    else
    {
        [self showLoginViewController];
    }
    
    return YES;
}

- (void) showLoginViewController
{
    NBRLoginViewController *nVC = [[NBRLoginViewController alloc] initWithNibName:@"NBRLoginViewController" bundle:nil];
    UINavigationController *nNavVC = [[UINavigationController alloc] initWithRootViewController:nVC];
    self.window.rootViewController = nNavVC;
    [self.window makeKeyAndVisible];
}

- (void) showMainViewTabViewContller
{
    UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *mainTab = [mainBoard instantiateInitialViewController];
    
    self.window.rootViewController = mainTab;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    //NSString * deviceTokenStr = [XGPush registerDevice:deviceToken];
    
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]register successBlock");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]register errorBlock");
    };
    
    //注册设备
    [[XGSetting getInstance] setChannel:XGCHANNL];
    [[XGSetting getInstance] setGameServer:@"Default"];
    [[XGPusher shareInstance] configWithSecretKey:@"68b0dd6db980f54f2a77f297e628e7df" accessId:@"2200108162" environment:XGPUSH_ENVIRONEMNT_DEV];
    
    NSString * deviceTokenStr = [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
    
    //如果不需要回调
    [XGPush registerDevice:deviceToken];
    
    //打印获取的deviceToken的字符串
    NSLog(@"deviceTokenStr is %@",deviceTokenStr);
    
    [AppSessionMrg shareInstance].XGDeviceToken = deviceTokenStr;
    
    
    XGMessage *newMessage = [[XGMessage alloc] init];
    
    newMessage.from = @"UserFrom";
    newMessage.to = @"UserTo";
    newMessage.content = @"消息测试";
    newMessage.alert = @"您有一条新的消息";
    newMessage.fromDeviceToken = [AppSessionMrg shareInstance].XGDeviceToken;
    newMessage.toDeviceToken = @"8732c28bc2a9e933e4ff94446efb087fb552dc5b8b43708dfc1dbd77de85ed4a";
    
    [[XGPusher shareInstance] pushMessage:newMessage];
    
}

//如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@",err];
    
    NSLog(@"%@",str);
    
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    //推送反馈(app运行时)
    [XGPush handleReceiveNotification:userInfo];
    
    
    //回调版本示例
    /*
     void (^successBlock)(void) = ^(void){
     //成功之后的处理
     NSLog(@"[XGPush]handleReceiveNotification successBlock");
     };
     
     void (^errorBlock)(void) = ^(void){
     //失败之后的处理
     NSLog(@"[XGPush]handleReceiveNotification errorBlock");
     };
     
     void (^completion)(void) = ^(void){
     //失败之后的处理
     NSLog(@"[xg push completion]userInfo is %@",userInfo);
     };
     
     [XGPush handleReceiveNotification:userInfo successCallback:successBlock errorCallback:errorBlock completion:completion];
     */
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
