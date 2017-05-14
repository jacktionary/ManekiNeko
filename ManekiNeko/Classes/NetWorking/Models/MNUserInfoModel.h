//
//  MNUserInfoModel.h
//  ManekiNeko
//
//  Created by JackCheng on 16/3/14.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNDeviceModel.h"

@interface MNUserInfoRequestModel : MNBaseModel

//uid;//'用户ID',
@property (nonatomic, strong)NSString *uid;

//token;//'令牌',
@property (nonatomic, strong)NSString *token;

@end

@interface MNUserInfoModel : MNBaseModel

//uid;//'用户ID',
@property (nonatomic, strong)NSString<Optional> *uid;

//alipayaccount;//'支付宝账号',
@property (nonatomic, strong)NSString<Optional> *alipayaccount;

//alipayname;//'支付宝姓名',
@property (nonatomic, strong)NSString<Optional> *alipayname;

//nickname;//'昵称',
@property (nonatomic, strong)NSString<Optional> *nickname;

//registerdate;//'注册时间',
@property (nonatomic, strong)NSString<Optional> *registerdate;

//logindate;//'登录时间',
@property (nonatomic, strong)NSString<Optional> *logindate;

//state;//'用户状态：0正常；封停',
@property (nonatomic, strong)NSString<Optional> *state;

//redpack;//'可否领取红包：0是；1否',
@property (nonatomic, strong)NSNumber<Optional> *redpack;

//balance;//'余额=收入-支出',
@property (nonatomic, strong)NSString<Optional> *balance;

//expend;//'累计提现金额',
@property (nonatomic, strong)NSString<Optional> *expend;

//income;//'累计任务金额',
@property (nonatomic, strong)NSString<Optional> *income;

//todayincome;//'今日收入',
@property (nonatomic, strong)NSString<Optional> *todayincome;

//totaltask;//'总任务数',
@property (nonatomic, strong)NSString<Optional> *totaltask;

//disciplecount;//'徒弟人数',
@property (nonatomic, strong)NSString<Optional> *disciplecount;

//disciplerewards;//'徒弟奖励';
@property (nonatomic, strong)NSString<Optional> *disciplerewards;

@end
