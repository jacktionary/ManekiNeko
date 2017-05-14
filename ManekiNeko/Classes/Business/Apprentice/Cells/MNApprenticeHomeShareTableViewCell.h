//
//  MNApprenticeHomeShareTableViewCell.h
//  ManekiNeko
//
//  Created by JackCheng on 16/4/19.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNBaseTableViewCell.h"

typedef enum {
    MNApprenticeShareCellButtonType_Share,
    MNApprenticeShareCellButtonType_Scan,
} MNApprenticeShareCellButtonType;

@interface MNApprenticeHomeShareTableViewCell : MNBaseTableViewCell

@property (nonatomic, copy, nullable) void (^callback)(MNApprenticeShareCellButtonType);

@end
