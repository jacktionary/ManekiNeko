//
//  UIButton+ManekiNeko.h
//  ManekiNeko
//
//  Created by JackCheng on 16/2/24.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ButtonTypeOrange,
    ButtonTypeBlue,
    ButtonTypeGray,
} ButtonType;

@interface UIButton (ManekiNeko)

/*
 *  根据type生成button
 */
+ (UIButton *)buttonWithButtonType:(ButtonType)type;

/*
 *  根据type,指定icon和title生成button
 */
+ (UIButton *)buttonWithButtonType:(ButtonType)type iconImageName:(NSString *)imgName title:(NSString *)title;

@end
