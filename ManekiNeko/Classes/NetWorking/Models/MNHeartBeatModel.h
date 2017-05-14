//
//  MNHeartBeatModel.h
//  ManekiNeko
//
//  Created by JackCheng on 16/3/14.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNBaseModel.h"

@interface MNHeartBeatModel : MNBaseModel

//bids = 'BundleIDS'
@property (nonatomic, strong)NSString *bids;

//pnames = 'ProcessNAMES'
@property (nonatomic, strong)NSString *pnames;

//uid = //'用户ID（后续所有请求需要带上）'
@property (nonatomic, strong)NSString *uid;

//token = //'令牌（后续所有请求需要带上）'
@property (nonatomic, strong)NSString *token;

- (void)setupBidsAndPnames;

@end
