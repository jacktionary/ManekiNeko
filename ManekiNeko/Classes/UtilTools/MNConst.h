//
//  MNConst.h
//  ManekiNeko
//
//  Created by JackCheng on 16/3/3.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MNTabBarControllerIndex_Task = 0,
    MNTabBarControllerIndex_Apprentice,
    MNTabBarControllerIndex_Cashing,
    MNTabBarControllerIndex_Ranking,
    MNTabBarControllerIndex_Me,
} MNTabBarControllerIndex;

static NSString *const kMNTimeOfOpenAppKey = @"mn_time_of_open_app";
static NSString *const kNotificationAccelerometerChanged = @"kNotificationAccelerometerChanged";
