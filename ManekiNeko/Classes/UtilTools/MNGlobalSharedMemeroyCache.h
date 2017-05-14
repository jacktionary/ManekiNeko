//
//  MNGlobalSharedMemeroyCache.h
//  ManekiNeko
//
//  Created by JackCheng on 16/3/3.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNUserLoginModel.h"
#import "MNUserInfoModel.h"

@interface MNGlobalSharedMemeroyCache : NSObject

/*
 *  是否是第一次打开app
 */
@property (nonatomic, assign)BOOL isFirstLaunch;

/*
 *  用户登录信息
 */
@property (nonatomic, strong)MNUserLoginResponseModel *userLoginModel;

/*
 *  用户详细信息
 */
@property (nonatomic, strong)MNUserInfoModel *userInfoModel;

/*
 *  app登录信息
 */
@property (nonatomic, strong)MNAppUpdateInfoModel *appUpdateInfoModel;

/*
 *  单例模式
 */
+ (instancetype)sharedInstance;

@end
