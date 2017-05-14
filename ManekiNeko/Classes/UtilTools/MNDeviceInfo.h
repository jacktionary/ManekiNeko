//
//  DeviceInfo.h
//  CyouSDK
//
//  Created by Alien Wang on 14-8-22.
//  Copyright (c) 2014年 Hard Time. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNDeviceInfo : NSObject

/*
 *  获取系统版本号
 */
+ (float)systemVersion;

/*
 *  获取用户设备唯一标识
 */
+ (NSString *)deviceID;

/*
 *  获取当前时间
 */
+(NSString *)getDate;

/*
 *  获取app bundleID
 */
+(NSString *)bundleID;

/*
 *  获取MAC地址 唯一表示
 */
+(NSString *)macAddress;

/*
 *  获取操作系统类型
 */
+(NSString *)systemName;

/*
 * 获取设备名称
 */
+(NSString *)deviceName;

/*
 * 获取设备类型
 */
+(NSString *)deviceModelName;

/*
 * 获取设备分辨率
 */
+(NSString *)resolution;

/*
 * 获取运营商标示
 */
+(NSString *)carrier;

/*
 *  获取当前联网方式。
 *  wifi/3g/nonetwork
 */
+(NSString *)checkNetWoriking;

/*
 *  判断设备是否越狱
 */

+(NSString *)checkJailBroken;

/*
 *  检查是否连接到网络
 */
+(BOOL) isConnectedToNetwork;

/*
 *  获取开机时间
 */
+ (NSString *)getLaunchSystemTime;

/*
 *  手机总容量
 */
+ (NSNumber *)diskSpaceTotal;

/*
 *  手机剩余可用容量
 */
+ (NSNumber *)diskSpaceAvaliable;

/*
 *  手机可用电量
 */
+ (double)batteryAvaliable;

/*
 *  获得当前所有进程信息(jailbreak可用)
 */
+ (NSArray *)runningProcesses;

/*
 *  获得手机安装的app list(jailbreak可用)
 */
+(NSArray *)installedApp;

/*
 *  获取所有安装application
 */
+ (NSArray *)allApplications;

@end
