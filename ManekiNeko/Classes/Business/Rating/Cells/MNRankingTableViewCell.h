//
//  MNRatingTableViewCell.h
//  ManekiNeko
//
//  Created by JackCheng on 16/3/15.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNBaseTableViewCell.h"
#import "MNUserRankingIncomeModel.h"
#import "MNUserRankingApprenticeModel.h"

typedef enum {
    MNRankingTableViewCellType_Default,
    MNRankingTableViewCellType_Top3,
} MNRankingTableViewCellType;

@interface MNRankingTableViewCell : MNBaseTableViewCell

@property (nonatomic, strong)MNBaseModel *model;
@property (nonatomic, assign)NSInteger rankingNum;

@end
