//
//  MNMeHomeTableViewCell.h
//  ManekiNeko
//
//  Created by JackCheng on 16/3/29.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNBaseTableViewCell.h"

@class MNMeHomeCellDataModel;

@interface MNMeHomeTableViewCell : MNBaseTableViewCell

@property (nonatomic, weak)MNMeHomeCellDataModel *model;

@end
