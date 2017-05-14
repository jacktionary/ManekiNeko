//
//  MNDeviceModel.h
//  ManekiNeko
//
//  Created by JackCheng on 16/2/19.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNBaseModel.h"

@interface MNDeviceModel : MNBaseModel

//deviceid = '设备ID（IDFA）'
@property (nonatomic, strong)NSString *deviceid;

//devicea = '开机时间（S）'
@property (nonatomic, strong)NSString *devicea;

//deviceb = '安装APP时间（S）'
@property (nonatomic, strong)NSString *deviceb;

//devicec = '手机总容量（B）'
@property (nonatomic, strong)NSString *devicec;

//deviced = '手机剩余容量（B）'
@property (nonatomic, strong)NSString *deviced;

//devicee = '手机电量（%）'
@property (nonatomic, strong)NSString *devicee;

//devicef = '应用程序数'
@property (nonatomic, strong)NSString *devicef;

//deviceg = '设备型号'
@property (nonatomic, strong)NSString *deviceg;

//deviceh = '系统版本'
@property (nonatomic, strong)NSString *deviceh;

//devicei = '手机名称'
@property (nonatomic, strong)NSString *devicei;

//devicej = '是否越狱：0正常；1越狱'
@property (nonatomic, strong)NSString *devicej;

/*
 *  构建model数据
 */
- (void)setupModelData;

@end
