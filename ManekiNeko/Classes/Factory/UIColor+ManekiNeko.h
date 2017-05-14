//
//  UIColor+ManekiNeko.h
//  ManekiNeko
//
//  Created by JackCheng on 16/2/24.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ColorTypeFB7540,    //#fb7540
    ColorTypeFFAF90,    //#ffaf90
    ColorType999898,    //#999898
    ColorTypeA7A7A7,    //#a7a7a7
    ColorType575656,    //#575656
} ColorType;

@interface UIColor (ManekiNeko)

+ (UIColor *)colorWithType:(ColorType)type;

@end
