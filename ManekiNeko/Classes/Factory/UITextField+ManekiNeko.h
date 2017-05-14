//
//  UITextField+ManekiNeko.h
//  ManekiNeko
//
//  Created by JackCheng on 16/2/25.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TextFieldTypeDefault,
    TextFieldTypeGrayBorder,    //灰色边框，cornerRadius=5
} TextFieldType;

@interface UITextField (ManekiNeko)

/*
 *  根据type生成textField，默认字体大小30号，颜色575656
 */
+ (UITextField *)textFieldWithType:(TextFieldType)type;

@end
