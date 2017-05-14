//
//  MNRankingIncomeModel.h
//  ManekiNeko
//
//  Created by JackCheng on 16/3/15.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNBaseModel.h"

@interface MNUserRankingRequestIncomeModel : MNBaseModel

@property (nonatomic, strong)NSString *uid;
@property (nonatomic, strong)NSString *token;

@end

@interface MNUserRankingIncomeModel : MNBaseModel

@property (nonatomic, strong)NSString *uid;
@property (nonatomic, strong)NSString *nickname;
@property (nonatomic, strong)NSString *income;

@end
