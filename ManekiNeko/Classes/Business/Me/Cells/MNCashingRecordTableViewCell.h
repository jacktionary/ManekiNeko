//
//  MNCashingRecordTableViewCell.h
//  ManekiNeko
//
//  Created by JackCheng on 16/3/30.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNBaseTableViewCell.h"

@class MNUserExpendRecordModel;

@interface MNCashingRecordTableViewCell : MNBaseTableViewCell

@property (nonatomic, weak)MNUserExpendRecordModel *model;

@end
