//
//  MNTaskListModel.h
//  ManekiNeko
//
//  Created by JackCheng on 16/2/19.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNBaseModel.h"

typedef enum {
    MNTaskUserStatus_Avaliable,
    MNTaskUserStatus_Processing,
    MNTaskUserStatus_Done,
    MNTaskUserStatus_Abort,
} MNTaskUserStatus;

@interface MNTaskListModel : MNBaseModel

//uid = 'UID'
@property (nonatomic, strong)NSString *uid;

//token = 'TOKEN'
@property (nonatomic, strong)NSString *token;

//p = '页码：从0开始'
@property (nonatomic, strong)NSString *p;

@end

@interface MNTaskListResponseModel : MNBaseModel

//tid;//'任务ID'
@property (nonatomic, strong)NSString *tid;

//bid;//'BundleID'
@property (nonatomic, strong)NSString *bid;

//name;//'名称'
@property (nonatomic, strong)NSString *name;

//icon;//'图标'
@property (nonatomic, strong)NSString *icon;

//quantity;//'发放任务数量'
@property (nonatomic, strong)NSString *quantity;

//award;//'奖励金额'
@property (nonatomic, strong)NSString *award;

//condition;//'达成条件（时间：分）'
@property (nonatomic, strong)NSString *condition;

//keyword;//'关键字'
@property (nonatomic, strong)NSString *keyword;

//startdate;//'开启时间'
@property (nonatomic, strong)NSString *startdate;

//stopdate;//'停止时间'
@property (nonatomic, strong)NSString *stopdate;

//createdate;//'创建时间'
@property (nonatomic, strong)NSString *createdate;

//updatedate;//'更新时间'
@property (nonatomic, strong)NSString *updatedate;

//state;//'状态：0开启；1关闭'
@property (nonatomic, strong)NSString *state;

//userstate;//'当前用户状态：0未领取；1进行中；2已完成；3已放弃；'
@property (nonatomic, assign)NSInteger userstate;

//acquire;//'领取任务数量'
@property (nonatomic, strong)NSString *acquire;

//residue;//'剩余任务数量'
@property (nonatomic, strong)NSString *residue;

@end