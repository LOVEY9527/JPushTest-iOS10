//
//  JPushManager.h
//  JPushTest
//
//  Created by li_yong on 15/9/17.
//  Copyright (c) 2015年 li_yong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JPushManager : NSObject

/**
 *  @author li_yong
 *
 *  获取单例
 *
 *  @return
 */

+ (id)sharedInstance;

/**
 *  @author li_yong
 *
 *  配置极光推送
 *
 *  @param launchOptions 加载参数
 */
- (void)configWithLaunchOptions:(NSDictionary *)launchOptions;

/**
 *  @author li_yong
 *
 *  注册deviceToken
 *
 *  @param deviceToken deviceToken
 */
- (void)registerDeviceToken:(NSData *)deviceToken;

/**
 *  @author li_yong
 *
 *  处理收到的APNS消息，向服务器上报收到APNS消息
 *
 *  @param userInfo 消息内容
 */
- (void)handleRemoteNotification:(NSDictionary *)userInfo;

/**
 *  @author li_yong
 *
 *  处理收到的APNS消息，向服务器上报收到APNS消息(iOS 7以后专用)
 *
 *  @param userInfo          消息内容
 *  @param completionHandler 
 */
- (void)handleRemoteNotification:(NSDictionary *)userInfo
          fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

/**
 *  @author liyong
 *
 *  设置别名
 *
 *  @param alias      别名
 */
- (void)setAlias:(NSString *)alias;

/**
 *  @author li_yong
 *
 *  设置角标(到服务器),本接口不会改变应用本地的角标值.
 *
 *  @param value 新的值. 会覆盖服务器上保存的值(这个用户)
 *
 *  @return
 */
- (BOOL)setBadge:(NSInteger)value;

@end
