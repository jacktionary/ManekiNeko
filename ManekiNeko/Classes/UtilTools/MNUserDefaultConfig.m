//
//  MNUserDefaultConfig.m
//  
//
//  Created by Jack Cheng on 14-3-11.
//  Copyright (c) 2014年 Hard Time. All rights reserved.
//

#import "MNUserDefaultConfig.h"

#define MNKEY_PRE @"MN_KEY"

@implementation MNUserDefaultConfig

+ (void)setKey:(NSString *)key forValue:(id)value
{
    NSString *HT_key = [NSString stringWithFormat:@"%@_%@", MNKEY_PRE, key];
    
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:HT_key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)getValueForKey:(NSString *)key
{
    NSString *HT_key = [NSString stringWithFormat:@"%@_%@", MNKEY_PRE, key];
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:HT_key];
}

+ (id)getValueForKey:(NSString *)key defaultValue:(id)defaultValue
{
    id value = [MNUserDefaultConfig getValueForKey:key];
    
    if (!value) {
        value = defaultValue;
    }
    
    return value;
}

@end
