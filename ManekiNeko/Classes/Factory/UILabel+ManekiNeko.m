//
//  UILabel+ManekiNeko.m
//  ManekiNeko
//
//  Created by JackCheng on 16/2/24.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "UILabel+ManekiNeko.h"
#import "MNMacro.h"

@implementation UILabel (ManekiNeko)

+ (UILabel *)labelWithType:(LabelType)type
{
    return [UILabel labelWithType:type fontSize:30 textColor:UIColorFromRGB(0x575656)];
}

+ (UILabel *)labelWithType:(LabelType)type fontSize:(NSInteger)fontSize
{
    return [UILabel labelWithType:type fontSize:fontSize textColor:UIColorFromRGB(0x575656)];
}

+ (UILabel *)labelWithType:(LabelType)type fontSize:(NSInteger)fontSize textColor:(UIColor *)textColor
{
    // create label
    UILabel *label = [[UILabel alloc] init];
    
    // style label
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = textColor;
    label.numberOfLines = [UILabel numberOfLinesForType:type];
    label.textAlignment = [UILabel textAlignmentForType:type];
    
    // return style label
    return label;
}

+ (NSInteger)numberOfLinesForType:(LabelType)type
{
    switch (type) {
        case LabelTypeDefault:
            return 0;
            break;
            
        default:
            return 1;
            break;
    }
}

+ (NSTextAlignment)textAlignmentForType:(LabelType)type
{
    switch (type) {
        case LabelTypeDefault:
            return NSTextAlignmentCenter;
            break;
            
        default:
            return NSTextAlignmentLeft;
            break;
    }
}

@end
