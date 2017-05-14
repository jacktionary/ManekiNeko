//
//  MNTaskListTableViewCell.h
//  ManekiNeko
//
//  Created by JackCheng on 15/10/20.
//  Copyright © 2015年 HardTime. All rights reserved.
//

#import "MNBaseTableViewCell.h"
#import "MNTaskListModel.h"

@interface MNTaskListTableViewCell : MNBaseTableViewCell

@property (nonatomic, weak)MNTaskListResponseModel *model;

@property (nonatomic, copy)void(^taskButtonClick)(MNTaskListResponseModel *model);

@end
