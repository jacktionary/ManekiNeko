//
//  MNBaseViewController.h
//  ManekiNeko
//
//  Created by JackCheng on 15/10/19.
//  Copyright © 2015年 HardTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "MNMacro.h"
#import "MNHttpSessionManager.h"
#import "MNNetWorkingConst.h"

@interface MNBaseViewController : UIViewController

- (void)initSubViews;

- (void)configRightBarButton;

@property (nonatomic, copy)void(^pageClose)(void);

@end
