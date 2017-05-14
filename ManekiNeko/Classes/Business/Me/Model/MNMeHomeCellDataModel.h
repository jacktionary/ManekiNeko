//
//  MNMeHomeCellDataModel.h
//  ManekiNeko
//
//  Created by JackCheng on 16/3/28.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNBaseModel.h"

@interface MNMeHomeCellDataModel : MNBaseModel

@property (nonatomic, strong)NSString *imgName;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *indicatorName;
@property (nonatomic, strong)NSString *nextViewControllerClassName;

@end
