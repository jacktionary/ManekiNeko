//
//  MNUserDefaultConfig.h
//  
//
//  Created by Jack Cheng on 14-3-11.
//  Copyright (c) 2014年 Hard Time. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNUserDefaultConfig : NSObject

+ (void)setKey:(NSString *)key forValue:(id)value;
+ (id)getValueForKey:(NSString *)key;
+ (id)getValueForKey:(NSString *)key defaultValue:(id)defaultValue;

@end
