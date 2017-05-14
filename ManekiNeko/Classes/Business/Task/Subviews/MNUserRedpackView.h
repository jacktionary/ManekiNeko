//
//  MNUserRedpackView.h
//  ManekiNeko
//
//  Created by JackCheng on 16/2/24.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNBaseView.h"

@interface MNUserRedpackView : MNBaseView

@property (nonatomic, strong) void(^confirmRedPackCallBack)(NSString *invitedID, NSString *redpackAmount);

@end
