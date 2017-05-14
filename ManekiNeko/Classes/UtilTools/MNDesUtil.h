//
//  HTDesUtil.h
//  
//
//  Created by Jack Cheng on 14-3-3.
//  Copyright (c) 2014年 Hard Time. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNDesUtil : NSObject

+ (NSString *)DESEncrypt:(NSString *)string;
+ (NSString *)DESDecrypt:(NSString *)dataString;

@end
