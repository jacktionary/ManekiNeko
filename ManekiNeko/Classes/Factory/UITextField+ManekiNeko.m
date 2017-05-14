//
//  UITextField+ManekiNeko.m
//  ManekiNeko
//
//  Created by JackCheng on 16/2/25.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "UITextField+ManekiNeko.h"
#import "MMPlaceHolder.h"
#import "MNMacro.h"

@implementation UITextField (ManekiNeko)

+ (UITextField *)textFieldWithType:(TextFieldType)type
{
    UITextField *textField = [UITextField new];
    
    textField.keyboardType = UIKeyboardTypeASCIICapable;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.spellCheckingType = UITextSpellCheckingTypeNo;
    
    switch (type) {
        case TextFieldTypeGrayBorder:
            textField.layer.cornerRadius = 3;
            textField.layer.borderColor = UIColorFromRGB(0x999898).CGColor;
            textField.textColor = UIColorFromRGB(0x999898);
            textField.layer.borderWidth = 0.5;
            textField.textAlignment = NSTextAlignmentLeft;
            textField.adjustsFontSizeToFitWidth = YES;
            
            textField.font = [UIFont systemFontOfSize:12];
            textField.minimumFontSize = 10;
            
            break;
            
        default:
            break;
    }
    
    return textField;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return [self rectForTextFieldBounds:bounds];
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self rectForTextFieldBounds:bounds];
}

- (CGRect)rectForTextFieldBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 5, 0);
}

@end
