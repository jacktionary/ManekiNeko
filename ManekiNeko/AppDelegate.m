//
//  AppDelegate.m
//  ManekiNeko
//
//  Created by JackCheng on 15/9/14.
//  Copyright (c) 2015年 HardTime. All rights reserved.
//

#import "AppDelegate.h"
#import "MNMacro.h"
#import "MNUserDefaultConfig.h"
#import "MNNetWorking.h"
#import "MNUserLoginModel.h"
#import "MNGlobalSharedMemeroyCache.h"
#import "MNConst.h"
#import "MNNetWorking.h"
#import "MNHeartBeatModel.h"
#import "MNGlobalSharedMemeroyCache.h"
#import "WXApi.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UITabBarController *tabBarController = (UITabBarController *)[self.window rootViewController];
    
    tabBarController.tabBar.tintColor = RGBCOLOR(248, 117, 72);
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"common_back_normal"]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    [self recordFirstLaunch];
    [self registNotification];
    
    [WXApi registerApp:@"wx127ee41d72c8e259"];
    
//    [Bugtags startWithAppKey:@"55bddd81ac3d1e0009397295daf4fde9" invocationEvent:BTGInvocationEventBubble];
    
    return YES;
}

- (void)dealloc
{
    [self unregistNotification];
}

- (void)registNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHeartbeatStart:) name:vNotificationHeartBeatStart object:nil];
}

- (void)notificationHeartbeatStart:(NSNotification *)notification
{
    [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(heartbeating) userInfo:nil repeats:YES];
}

- (void)heartbeating
{
    MNHeartBeatModel *model = [[MNHeartBeatModel alloc] init];
    [model setupBidsAndPnames];
    model.uid = [[[MNGlobalSharedMemeroyCache sharedInstance] userLoginModel] uid];
    model.token = [[[MNGlobalSharedMemeroyCache sharedInstance] userLoginModel] token];
    
    [[MNHttpSessionManager manager] POST:kUserHeartbeat parameters:[model toDictionary]
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                                     NSLog(@"bing...%@", responseObject);
                                 }
                                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                     
                                 }];
}

- (void)unregistNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:vNotificationHeartBeatStart object:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
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

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self];
}

#pragma mark - Private Methods
#define MNFirstLaunch @"1"
#define MNNotFirstLaunch @"0"

- (void)recordFirstLaunch
{
    static NSString *kMNFirstLaunchKey = @"mn_first_launch_key";
    
    NSString *firstLaunch = [MNUserDefaultConfig getValueForKey:kMNFirstLaunchKey defaultValue:MNFirstLaunch];
    
    if ([firstLaunch isEqualToString:MNFirstLaunch]) {
        [MNUserDefaultConfig setKey:kMNFirstLaunchKey forValue:MNNotFirstLaunch];
        [MNUserDefaultConfig setKey:kMNTimeOfOpenAppKey forValue:@([[NSDate date] timeIntervalSince1970])];
        
        [[MNGlobalSharedMemeroyCache sharedInstance] setIsFirstLaunch:YES];
    } else {
        [[MNGlobalSharedMemeroyCache sharedInstance] setIsFirstLaunch:NO];
    }
}

@end
