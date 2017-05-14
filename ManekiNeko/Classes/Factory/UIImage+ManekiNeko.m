//
//  UIImage+ManekiNeko.m
//  ManekiNeko
//
//  Created by JackCheng on 16/2/25.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "UIImage+ManekiNeko.h"

@implementation UIImage (ManekiNeko)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
