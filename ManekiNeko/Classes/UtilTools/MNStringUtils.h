//
//  StringUtils.h
//  
//
//  Created by Jack Cheng on 14-2-11.
//  Copyright (c) 2014年 Hard Time. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MNDateType_Year=0,
    MNDateType_Hour,
} MNDateType;


@interface StringUtils : NSObject

+ (NSString *)getMD5:(NSString *)string;
+ (NSString *)UUID;
+ (NSString *)sha1:(NSString *)str;

+(NSString *)getNewDateWithString:(NSString *)dateString type:(MNDateType)dateType;

+(NSString *)getDateWithTimeStamp:(NSString *)timestamp;

+(NSString *)getDateWithFormatter:(NSString *)formatter andTimeStamp:(NSString *)timestamp;

@end
