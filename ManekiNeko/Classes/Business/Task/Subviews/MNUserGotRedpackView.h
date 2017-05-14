//
//  MNUserGotRedpackView.h
//  ManekiNeko
//
//  Created by JackCheng on 16/3/1.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNBaseView.h"

@interface MNUserGotRedpackView : MNBaseView

@property (nonatomic, strong) void(^confirmRedPackCallBack)(void);
@property (nonatomic, strong)NSString *redpackAmount;

@end
