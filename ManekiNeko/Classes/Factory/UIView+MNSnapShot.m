//
//  UIView+MNSnapShot.m
//  ManekiNeko
//
//  Created by JackCheng on 16/4/18.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "UIView+MNSnapShot.h"

@implementation UIView (MNSnapShot)

- (UIImage *)takeSnapshotForSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    
    // old style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
