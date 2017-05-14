//
//  MNApprenticeListModel.h
//  ManekiNeko
//
//  Created by JackCheng on 16/4/19.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNUserIdAndTokenModel.h"

@interface MNApprenticeListRequestModel : MNUserIdAndTokenModel

@property (nonatomic, strong)NSString *p;

@end

@interface MNApprenticeListModel : MNBaseModel

//uid;//'用户ID',
@property (nonatomic, strong)NSString *uid;

//nickname;//'昵称',
@property (nonatomic, strong)NSString *nickname;

//registerdate;//'收徒时间',
@property (nonatomic, strong)NSString *registerdate;

//rewards;//'奖励收入',
@property (nonatomic, strong)NSString *rewards;

@end
