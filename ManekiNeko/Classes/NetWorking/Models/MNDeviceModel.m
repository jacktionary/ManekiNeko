//
//  MNDeviceModel.m
//  ManekiNeko
//
//  Created by JackCheng on 16/2/19.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNDeviceModel.h"
#import "MNDeviceInfo.h"
#import "MNConst.h"
#import "MNUserDefaultConfig.h"

@implementation MNDeviceModel

- (void)setupModelData
{
    /*
    deviceid = '设备ID（IDFA）'
    devicea = '开机时间（S）'
    deviceb = '安装APP时间（S）'
    devicec = '手机总容量（B）'
    deviced = '手机剩余容量（B）'
    devicee = '手机电量（%）'
    devicef = '应用程序数'
    deviceg = '设备型号'
    deviceh = '系统版本'
    devicei = '手机名称'
    devicej = '是否越狱：0正常；1越狱'
     */
    
    self.deviceid = [MNDeviceInfo deviceID];
    self.devicea = [MNDeviceInfo getLaunchSystemTime];
    self.deviceb = [MNUserDefaultConfig getValueForKey:kMNTimeOfOpenAppKey];
    self.devicec = [[MNDeviceInfo diskSpaceTotal] stringValue];
    self.deviced = [[MNDeviceInfo diskSpaceAvaliable] stringValue];
    self.devicee = [NSString stringWithFormat:@"%f", [MNDeviceInfo batteryAvaliable]];
    self.devicef = [MNDeviceInfo installedApp] == nil ? @"0" : [NSString stringWithFormat:@"%lu", (unsigned long)[[MNDeviceInfo installedApp] count]];
    self.deviceg = [MNDeviceInfo deviceModelName];
    self.deviceh = [MNDeviceInfo systemName];
    self.devicei = [MNDeviceInfo deviceName];
    self.devicej = [MNDeviceInfo checkJailBroken];
}

@end
