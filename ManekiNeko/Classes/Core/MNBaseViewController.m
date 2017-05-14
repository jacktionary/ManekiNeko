//
//  MNBaseViewController.m
//  ManekiNeko
//
//  Created by JackCheng on 15/10/19.
//  Copyright © 2015年 HardTime. All rights reserved.
//

#import "MNBaseViewController.h"
#import "SVWebViewController.h"

@interface MNBaseViewController ()

@end

@implementation MNBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // update navigation bar title color & font
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor whiteColor],
                                               NSForegroundColorAttributeName,
                                               [UIFont boldSystemFontOfSize:20],
                                               NSFontAttributeName,
                                               nil];
    [self.navigationController.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
    
    [self initSubViews];
}

- (void)initSubViews
{
    NSAssert(NO, @"子类必须重写此函数，在此函数中创建页面上view");
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)configRightBarButton
{
    // 右上角bar item
    UIImage *fontImage = [UIImage imageNamed:@"common_bar_gift_normal"];
    
    UIImage *fontImageSelected = [UIImage imageNamed:@"common_bar_gift_selected"];
    
    UIButton *fontButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fontButton.bounds = CGRectMake( 0, 0, fontImage.size.width, fontImage.size.height );
    [fontButton setImage:fontImage forState:UIControlStateNormal];
    [fontButton setImage:fontImageSelected forState:UIControlStateHighlighted];
    [fontButton setImage:fontImageSelected forState:UIControlStateSelected];
    
    [fontButton addTarget:self action:@selector(fontButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *fontBtn = [[UIBarButtonItem alloc] initWithCustomView:fontButton];
    
    NSArray *actionButtonItems = @[fontBtn];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
}

- (void)fontButtonClicked:(UIButton *)button
{
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:[NSString stringWithFormat:@"%@%@", baseActivityPageURL, @"activity.jsp"]];
    
    [self.navigationController pushViewController:webViewController animated:YES];
}

@end
