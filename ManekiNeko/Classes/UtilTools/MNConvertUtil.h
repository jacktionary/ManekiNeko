//
//  HTConvertUtil.h
//  
//
//  Created by Jack Cheng on 14-3-3.
//  Copyright (c) 2014年 Hard Time. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNConvertUtil : NSObject

/**
 64编码
 */
+(NSString *)base64Encoding:(NSData*) text;

/**
 字节转化为16进制数
 */
+(NSString *) parseByte2HexString:(Byte *) bytes;

/**
 字节数组转化16进制数
 */
+(NSString *) parseByteArray2HexString:(Byte[]) bytes;

/*
 将16进制数据转化成NSData 数组
 */
+(NSData*) parseHexToByteArray:(NSString*) hexString;

@end
