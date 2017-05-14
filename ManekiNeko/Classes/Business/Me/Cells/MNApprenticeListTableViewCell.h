//
//  MNApprenticeListTableViewCell.h
//  ManekiNeko
//
//  Created by JackCheng on 16/4/19.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNBaseTableViewCell.h"

@class MNApprenticeListModel;

@interface MNApprenticeListTableViewCell : MNBaseTableViewCell

@property (nonatomic, weak)MNApprenticeListModel *model;

@end
