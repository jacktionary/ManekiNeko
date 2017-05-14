//
//  MNTaskDetailView.h
//  ManekiNeko
//
//  Created by JackCheng on 16/3/4.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNBaseView.h"
#import "MNTaskListModel.h"

typedef enum {
    MNTaskDetailViewCallbackType_Commit,
    MNTaskDetailViewCallbackType_Aboart,
} MNTaskDetailViewCallbackType;

@interface MNTaskDetailView : MNBaseView

@property (nonatomic, strong) void(^viewCloseCallback)(MNTaskDetailViewCallbackType type, MNTaskListResponseModel *model);
@property (nonatomic, weak)MNTaskListResponseModel *model;

@end
