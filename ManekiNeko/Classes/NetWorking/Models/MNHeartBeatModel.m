//
//  MNHeartBeatModel.m
//  ManekiNeko
//
//  Created by JackCheng on 16/3/14.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNHeartBeatModel.h"
#import "MNDeviceInfo.h"

@implementation MNHeartBeatModel

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
