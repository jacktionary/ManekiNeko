//
//  MNUserTaskRecordTableViewCell.h
//  ManekiNeko
//
//  Created by JackCheng on 16/3/30.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNBaseTableViewCell.h"

@class MNUserTaskRecordModel;

@interface MNUserTaskRecordTableViewCell : MNBaseTableViewCell

@property (nonatomic, weak)MNUserTaskRecordModel *model;

@end
