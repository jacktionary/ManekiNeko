//
//  MNUserIdAndTokenModel.h
//  ManekiNeko
//
//  Created by JackCheng on 16/3/25.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNBaseModel.h"

@interface MNUserIdAndTokenModel : MNBaseModel

@property (nonatomic, strong)NSString *uid;
@property (nonatomic, strong)NSString *token;

@end
