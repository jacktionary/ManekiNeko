//
//  UISegmentedControl+ManekiNeko.m
//  ManekiNeko
//
//  Created by JackCheng on 16/4/22.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "UISegmentedControl+ManekiNeko.h"

@implementation UISegmentedControl (ManekiNeko)

+ (UISegmentedControl *)standardMNStyleSegmentedControl
{
    UISegmentedControl *control = [UISegmentedControl new];
    
    [control setBackgroundImage:nil forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [control setBackgroundImage:nil forState:UIControlStateFocused barMetrics:UIBarMetricsDefault];
    [control setBackgroundImage:nil forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [control setBackgroundImage:nil forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    return control;
}

@end
