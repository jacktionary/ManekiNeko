//
//  MNGlobalSharedMemeroyCache.m
//  ManekiNeko
//
//  Created by JackCheng on 16/3/3.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNGlobalSharedMemeroyCache.h"
#import "MNUserDefaultConfig.h"

static NSString *const kUserLoginModelKey = @"mn_user_login_model_key";
static NSString *const kUserInfoModelKey = @"mn_user_info_model_key";
static NSString *const kAppUpdateInfoModelKey = @"mn_appuodate_info_model_key";

@implementation MNGlobalSharedMemeroyCache

@synthesize userLoginModel = _userLoginModel;
@synthesize userInfoModel = _userInfoModel;
@synthesize appUpdateInfoModel = _appUpdateInfoModel;

+ (instancetype)sharedInstance
{
    static MNGlobalSharedMemeroyCache *sharedInstace = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstace = [MNGlobalSharedMemeroyCache new];
    });
    
    return sharedInstace;
}

- (MNUserLoginResponseModel *)userLoginModel
{
    if (!_userLoginModel) {
        _userLoginModel = [[MNUserLoginResponseModel alloc] initWithDictionary:[MNUserDefaultConfig getValueForKey:kUserLoginModelKey] error:nil];
    }
    
    return _userLoginModel;
}

- (MNUserInfoModel *)userInfoModel
{
    if (!_userInfoModel) {
        _userInfoModel = [[MNUserInfoModel alloc] initWithDictionary:[MNUserDefaultConfig getValueForKey:kUserInfoModelKey] error:nil];
    }
    
    return _userInfoModel;
}

- (void)setUserLoginModel:(MNUserLoginResponseModel *)userLoginModel
{
    _userLoginModel = userLoginModel;
    [MNUserDefaultConfig setKey:kUserLoginModelKey forValue:[userLoginModel toDictionary]];
}

- (void)setUserInfoModel:(MNUserInfoModel *)userInfoModel
{
    _userInfoModel = userInfoModel;
    [MNUserDefaultConfig setKey:kUserInfoModelKey forValue:[userInfoModel toDictionary]];
}

- (MNAppUpdateInfoModel *)appUpdateInfoModel
{
    if (!_appUpdateInfoModel) {
        _appUpdateInfoModel = [[MNAppUpdateInfoModel alloc] initWithDictionary:[MNUserDefaultConfig getValueForKey:kAppUpdateInfoModelKey] error:nil];
    }
    
    return _appUpdateInfoModel;
}

- (void)setAppUpdateInfoModel:(MNAppUpdateInfoModel *)appUpdateInfoModel
{
    _appUpdateInfoModel = appUpdateInfoModel;
    [MNUserDefaultConfig setKey:kAppUpdateInfoModelKey forValue:[appUpdateInfoModel toDictionary]];
}

@end
