//
//  MNTaskGetModel.h
//  ManekiNeko
//
//  Created by JackCheng on 16/2/19.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNDeviceModel.h"

@interface MNTaskGetModel : MNDeviceModel

//uid = 'UID'
@property (nonatomic, strong)NSString *uid;

//token = 'TOKEN'
@property (nonatomic, strong)NSString *token;

//tid = '任务ID'
@property (nonatomic, strong)NSString *tid;

@end
