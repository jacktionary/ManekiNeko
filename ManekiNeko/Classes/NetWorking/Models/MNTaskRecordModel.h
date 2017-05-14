//
//  MNTaskRecordModel.h
//  ManekiNeko
//
//  Created by JackCheng on 16/2/19.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNBaseModel.h"

@interface MNTaskRecordModel : MNBaseModel

//uid = 'UID'
@property (nonatomic, strong)NSString *uid;

//token = 'TOKEN'
@property (nonatomic, strong)NSString *token;

//p = '页码：从0开始'
@property (nonatomic, strong)NSString *p;

@end
