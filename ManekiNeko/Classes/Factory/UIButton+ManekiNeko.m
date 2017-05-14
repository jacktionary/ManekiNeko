//
//  UIButton+ManekiNeko.m
//  ManekiNeko
//
//  Created by JackCheng on 16/2/24.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "UIButton+ManekiNeko.h"
#import "UIImage+ManekiNeko.h"
#import "Masonry.h"
#import "MNMacro.h"

@implementation UIButton (ManekiNeko)

+ (UIButton *)buttonWithButtonType:(ButtonType)type
{
    return [UIButton buttonWithButtonType:type iconImageName:nil title:nil];
}

+ (UIButton *)buttonWithButtonType:(ButtonType)type iconImageName:(NSString *)imgName title:(NSString *)title
{
    UIButton *button = [UIButton new];
    
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.reversesTitleShadowWhenHighlighted = YES;
    
    button.layer.cornerRadius = 3;
    
    switch (type) {
        case ButtonTypeOrange:
            button.backgroundColor = UIColorFromRGB(0xfb7540);
            [button setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xfc8759)] forState:UIControlStateHighlighted];
            break;
        case ButtonTypeBlue:
            button.backgroundColor = UIColorFromRGB(0x59cefc);
            [button setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0x40cefc)] forState:UIControlStateHighlighted];
            break;
        case ButtonTypeGray:
            button.backgroundColor = UIColorFromRGB(0xa5a5a5);
            [button setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xa5a5a5)] forState:UIControlStateHighlighted];
            break;
        default:
            break;
    }
    
    if (imgName) {
        NSInteger offsetBetweenIconAndTitle = 12;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, offsetBetweenIconAndTitle+8, 0, 0);
        
        // icon imageview
        UIImageView *iconImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
        
        [button addSubview:iconImgView];
        
        [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(button.titleLabel.mas_left).with.offset(-(offsetBetweenIconAndTitle));
            make.centerY.equalTo(button.titleLabel);
        }];
    }
    
    [button setTitle:title forState:UIControlStateNormal];
    
    return button;
}

@end
