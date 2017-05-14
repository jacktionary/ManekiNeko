//
//  MNUserRedpackModel.h
//  ManekiNeko
//
//  Created by JackCheng on 16/2/19.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNBaseModel.h"

@interface MNUserRedpackModel : MNBaseModel

//uid = 'UID'
@property (nonatomic, strong)NSString *uid;

//token = 'TOKEN'
@property (nonatomic, strong)NSString *token;

//ruid = '推荐人UID'
@property (nonatomic, strong)NSString<Optional> *ruid;

@end

@interface MNUserRedpackResponseModel : MNBaseModel

//uid = //'用户ID'
@property (nonatomic, strong)NSString *uid;

//redpack = //'可否领取红包：0是；1否'
@property (nonatomic, strong)NSString *redpack;

//balance = //'余额'
@property (nonatomic, strong)NSString *balance;

@end
