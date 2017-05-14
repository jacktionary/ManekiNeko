//
//  MNUserBindingAlipayModel.h
//  ManekiNeko
//
//  Created by JackCheng on 16/3/24.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNBaseModel.h"

@interface MNUserBindingAlipayModel : MNBaseModel

@property (nonatomic, strong)NSString *uid;
@property (nonatomic, strong)NSString *token;
@property (nonatomic, strong)NSString *alipayaccount;
@property (nonatomic, strong)NSString *alipayname;

@end
