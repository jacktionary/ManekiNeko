//
//  MNTaskListHeaderTableViewCell.h
//  ManekiNeko
//
//  Created by JackCheng on 15/10/20.
//  Copyright © 2015年 HardTime. All rights reserved.
//

#import "MNBaseTableViewCell.h"

@interface MNTaskListHeaderTableViewCell : MNBaseTableViewCell

@property (nonatomic, weak)UILabel *incomeLabel; //今日收入

@property (nonatomic, weak)UILabel *apprenticeLabel; //今日收徒

@property (nonatomic, copy)void(^callback)(void);

@end
