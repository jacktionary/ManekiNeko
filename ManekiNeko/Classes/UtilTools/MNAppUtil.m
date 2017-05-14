//
//  AppUtil.m
//  CyouSDK
//
//  Created by JackCheng on 8/8/14.
//  Copyright (c) 2014 Hard Time. All rights reserved.
//

#import "MNAppUtil.h"

@implementation MNAppUtil

+ (NSString *)appVersion;
{
    NSDictionary * dicInfo =[[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [dicInfo objectForKey:@"CFBundleShortVersionString"];
    return appVersion;
}

@end
