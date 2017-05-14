//
//  MNUserExpendRecordModel.h
//  ManekiNeko
//
//  Created by JackCheng on 16/3/30.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNBaseModel.h"
#import "MNUserIdAndTokenModel.h"

@interface MNUserExpendRecordRequestModel : MNUserIdAndTokenModel

@property (nonatomic, strong)NSString *p;

@end

@interface MNUserExpendRecordModel : MNBaseModel

//id;//'ID',
@property (nonatomic, strong)NSString *id;

//uid;//'用户ID',
@property (nonatomic, strong)NSString *uid;

//paytype;//'支付方式：0支付宝；1微信；2充话费',
@property (nonatomic, strong)NSString *paytype;
@property (nonatomic, strong)NSString *paytypename;

//expend;//'支出金额',
@property (nonatomic, strong)NSString *expend;

//createdate;//'创建时间',
@property (nonatomic, strong)NSString *createdate;

//updatedate;//'更新时间',
@property (nonatomic, strong)NSString *updatedate;

//state;//'任务状态：0处理中；1已完成；2已失败',
@property (nonatomic, strong)NSString *state;

@property (nonatomic, strong)NSString *statename;

@end
