//
//  MNTaskDiscardModel.h
//  ManekiNeko
//
//  Created by JackCheng on 16/2/19.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNBaseModel.h"

@interface MNTaskDiscardModel : MNBaseModel

//uid = 'UID'
@property (nonatomic, strong)NSString *uid;

//token = 'TOKEN'
@property (nonatomic, strong)NSString *token;

//tid = '任务ID'
@property (nonatomic, strong)NSString *tid;

@end
