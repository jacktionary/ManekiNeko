//
//  MNUserTaskRecordModel.h
//  ManekiNeko
//
//  Created by JackCheng on 16/3/30.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNBaseModel.h"
#import "MNUserIdAndTokenModel.h"

@interface MNUserTaskRecordRequestModel : MNUserIdAndTokenModel

@property (nonatomic, strong)NSString *p;

@end

@interface MNUserTaskRecordModel : MNBaseModel

//id;//'ID',
@property (nonatomic, strong)NSString *id;

//uid;//'用户ID',
@property (nonatomic, strong)NSString *uid;

//tid;//'任务ID',
@property (nonatomic, strong)NSString *tid;

//tname;//'任务名称',
@property (nonatomic, strong)NSString *tname;

//income;//'收入金额',
@property (nonatomic, strong)NSString *income;

//createdate;//'创建时间',
@property (nonatomic, strong)NSString *createdate;

//updatedate;//'更新时间',
@property (nonatomic, strong)NSString *updatedate;

//state;//'任务状态：0进行中；1已完成；2已结束',
@property (nonatomic, strong)NSString *state;

@end
