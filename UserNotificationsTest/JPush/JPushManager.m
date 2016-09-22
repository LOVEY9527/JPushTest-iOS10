//
//  JPushManager.m
//  JPushTest
//
//  Created by li_yong on 15/9/17.
//  Copyright (c) 2015年 li_yong. All rights reserved.
//

#import "JPushManager.h"
#import "JPUSHService.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    #import <UserNotifications/UserNotifications.h>
#endif

#define JPUSH_APP_KEY   @"066ec4ae201d7fe2a76b9f9c"

@interface JPushManager ()<JPUSHRegisterDelegate>

@end

@implementation JPushManager

+ (id)sharedInstance
{
    static JPushManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JPushManager alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

//配置极光推送
- (void)configWithLaunchOptions:(NSDictionary *)launchOptions
{
    //Requested
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
    {
        JPUSHRegisterEntity *registerEntity = [[JPUSHRegisterEntity alloc] init];
        registerEntity.types = UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert;
        [JPUSHService registerForRemoteNotificationConfig:registerEntity delegate:self];
    }else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [JPUSHService registerForRemoteNotificationTypes:UIUserNotificationTypeBadge|
                                                         UIUserNotificationTypeSound|
                                                         UIUserNotificationTypeAlert
                                              categories:nil];
    }else
    {
        [JPUSHService registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
                                                         UIRemoteNotificationTypeSound|
                                                         UIRemoteNotificationTypeAlert
                                              categories:nil];
    }
#elif __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [JPUSHService registerForRemoteNotificationTypes:UIUserNotificationTypeBadge|
                                                         UIUserNotificationTypeSound|
                                                         UIUserNotificationTypeAlert
                                              categories:nil];
    }else
    {
        [JPUSHService registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
                                                         UIRemoteNotificationTypeSound|
                                                         UIRemoteNotificationTypeAlert
                                              categories:nil];
    }
#else
    [JPUSHService registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
                                                     UIRemoteNotificationTypeSound|
                                                     UIRemoteNotificationTypeAlert
                                          categories:nil];
#endif

    [JPUSHService setupWithOption:launchOptions
                           appKey:JPUSH_APP_KEY
                          channel:nil
                 apsForProduction:YES];
    
//    if ([[launchOptions allValues] count] > 0)
//    {
//        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//    }
}

//注册deviceToken
- (void)registerDeviceToken:(NSData *)deviceToken
{
    //Requested
    [JPUSHService registerDeviceToken:deviceToken];
}

//处理收到的APNS消息，向服务器上报收到APNS消息
- (void)handleRemoteNotification:(NSDictionary *)userInfo
{
    //Requested
    [JPUSHService handleRemoteNotification:userInfo];
    
    //操作推送通知
    [self operationPushNotificationWithUserInfo:userInfo];
}

//处理收到的APNS消息，向服务器上报收到APNS消息(iOS 7以后专用)
- (void)handleRemoteNotification:(NSDictionary *)userInfo
          fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    if (([[userInfo allKeys] containsObject:@"contentId"])&&
        ([[userInfo allKeys] containsObject:@"isSendLocation"])&&
        ([[userInfo allKeys] containsObject:@"panel"]))
    {
        //操作推送通知,通过上面三个参数判断推送消息是否是极光推送
        [self operationPushNotificationWithUserInfo:userInfo];
    }
}

/**
 *  @author liyong
 *
 *  设置别名
 *
 *  @param alias      别名
 */
- (void)setAlias:(NSString *)alias
{
    [JPUSHService setAlias:alias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
}

/**
 *  @author li_yong
 *
 *  极光推送设置别名成功
 *
 *  @param iResCode 状态码(0为成功，其他返回码请参考错误码定义)
 *  @param tags
 *  @param alias    别名
 */
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

/**
 *  @author li_yong
 *
 *  设置角标(到服务器),本接口不会改变应用本地的角标值.
 *
 *  @param value 新的值. 会覆盖服务器上保存的值(这个用户)
 *
 *  @return
 */
- (BOOL)setBadge:(NSInteger)value
{
    return [JPUSHService setBadge:value];
}

/**
 *  @author liyong
 *
 *  操作极光推送通知
 *
 *  @param userInfo 通知内容
 */
- (void)operationPushNotificationWithUserInfo:(NSDictionary *)userInfo
{
    
}

#pragma mark - JPUSHRegisterDelegate

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler
{
    NSLog(@"willPresentNotification");
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
    NSLog(@"didReceiveNotificationResponse");
}

@end
