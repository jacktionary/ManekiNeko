//
//  MNUserLoginModel.m
//  ManekiNeko
//
//  Created by JackCheng on 16/2/19.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNUserLoginModel.h"
#import "MNDeviceInfo.h"

@implementation MNUserLoginModel

- (void)setupBidsAndPnames
{
    /*
     bids = 'BundleIDS'
     pnames = 'ProcessNAMES'
     */
    
    self.bids = [[MNDeviceInfo allApplications] componentsJoinedByString:@","];
    self.pnames = [[MNDeviceInfo runningProcesses] componentsJoinedByString:@","];
}

@end

@implementation MNUserLoginResponseModel

@end

@implementation MNAppUpdateInfoModel

@end
