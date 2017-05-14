//
//  UILabel+ManekiNeko.h
//  ManekiNeko
//
//  Created by JackCheng on 16/2/24.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    LabelTypeDefault,
} LabelType;

@interface UILabel (ManekiNeko)

/*
 *  根据type生成label，默认字体大小30号，颜色575656
 */
+ (UILabel *)labelWithType:(LabelType)type;

/*
 *  根据type和fontSize生成label，颜色575656
 */
+ (UILabel *)labelWithType:(LabelType)type fontSize:(NSInteger)fontSize;

/*
 *  根据type、fontSize和textColor生成label
 */
+ (UILabel *)labelWithType:(LabelType)type fontSize:(NSInteger)fontSize textColor:(UIColor *)textColor;

@end
