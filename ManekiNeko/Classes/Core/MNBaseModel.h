//
//  MNBaseModel.h
//  ManekiNeko
//
//  Created by JackCheng on 16/2/19.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "JSONModel.h"

@interface MNBaseModel : JSONModel

@property (nonatomic, strong)NSString<Optional> *info;
@property (nonatomic, strong)NSNumber<Optional> *status;

@end
