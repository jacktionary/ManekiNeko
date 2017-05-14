//
//  MNUserLoginModel.h
//  ManekiNeko
//
//  Created by JackCheng on 16/2/19.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNBaseModel.h"
#import "MNDeviceModel.h"

typedef enum {
    MNUpdateType_None = 0,
    MNUpdateType_Force,
    MNUpdateType_Normal,
}MNUpdateType;

@interface MNUserLoginModel : MNDeviceModel

//bids = 'BundleIDS'
@property (nonatomic, strong)NSString *bids;

//pnames = 'ProcessNAMES'
@property (nonatomic, strong)NSString *pnames;

- (void)setupBidsAndPnames;

@end

@interface MNUserLoginResponseModel : MNBaseModel

//uid = //'用户ID（后续所有请求需要带上）'
@property (nonatomic, strong)NSString *uid;

//token = //'令牌（后续所有请求需要带上）'
@property (nonatomic, strong)NSString *token;

@end

@interface MNAppUpdateInfoModel : MNBaseModel

//force_update = //'强制更新'
@property (nonatomic, assign)NSString *updatetype;

//version_info = //'版本信息'
@property (nonatomic, strong)NSString *versioninfo;

//version_url = //'版本appstore地址'
@property (nonatomic, strong)NSString *versionurl;

@end
