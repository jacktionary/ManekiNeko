//
//  MNApprenticeDescriptionHowViewController.m
//  ManekiNeko
//
//  Created by JackCheng on 16/4/21.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNApprenticeDescriptionHowViewController.h"

@implementation MNApprenticeDescriptionHowViewController

- (NSString *)title
{
    return @"如何受更多的徒弟";
}

- (void)initSubViews
{
    @weakify(self);
    UIImageView *bannerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_appre_how_banner"]];
    
    [self.view addSubview:bannerImgView];
    
    [bannerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@155);
    }];
    
    // attributed strings
    CGFloat lineHeight = 24.0;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = lineHeight;
    paragraphStyle.maximumLineHeight = lineHeight;
    paragraphStyle.minimumLineHeight = lineHeight;
    
    paragraphStyle.paragraphSpacing = 10.0;
    
    NSMutableParagraphStyle *paragraphStyleWithHeadIndent = [[NSMutableParagraphStyle alloc] init];
    paragraphStyleWithHeadIndent.lineHeightMultiple = lineHeight;
    paragraphStyleWithHeadIndent.maximumLineHeight = lineHeight;
    paragraphStyleWithHeadIndent.minimumLineHeight = lineHeight;
    
    paragraphStyleWithHeadIndent.paragraphSpacing = 10.0;
    paragraphStyleWithHeadIndent.firstLineHeadIndent = 25.0;
    
    NSAttributedString *string0 =
    [[NSAttributedString alloc] initWithString:@"亲爱的猫友们：\n"
                                    attributes:@{
                                                 NSForegroundColorAttributeName : UIColorFromRGB(0x999898),
                                                 NSParagraphStyleAttributeName : paragraphStyle,
                                                 NSFontAttributeName : [UIFont boldSystemFontOfSize:14]
                                                 }];
    
    NSAttributedString *string1 = [[NSAttributedString alloc] initWithString:@"为了让你赚更多的钱，收更多的徒弟，小编煞费苦心，整理出以下攻略，请认真阅读，积极实践！\n"
                                                                     attributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0x999898),NSParagraphStyleAttributeName : paragraphStyleWithHeadIndent,   NSFontAttributeName : [UIFont boldSystemFontOfSize:14]
                                                                                  }];
    
    NSAttributedString *string2 =
    [[NSAttributedString alloc] initWithString:@"微信好友\n"
                                    attributes:@{
                                                 NSForegroundColorAttributeName : UIColorFromRGB(0x999898),
                                                 NSParagraphStyleAttributeName : paragraphStyle,
                                                 NSFontAttributeName : [UIFont boldSystemFontOfSize:14]
                                                 }];
    
    NSAttributedString *string3 =
    [[NSAttributedString alloc] initWithString:@"首先肯定实把赚钱这种好事推荐给朋友，相信小伙伴们都会喜欢，朋友下载安装就能马上领取招财猫官方送出的2元红包（朋友在打开App后需要输入你的ID才能拿到2元），从此大家携手一起踏上赚钱之旅，绝对会对你感激不尽！\n"
                                    attributes:@{
                                                 NSForegroundColorAttributeName : UIColorFromRGB(0x999898),
                                                 NSParagraphStyleAttributeName : paragraphStyleWithHeadIndent,
                                                 NSFontAttributeName : [UIFont boldSystemFontOfSize:14]
                                                 }];
    
    NSAttributedString *string4 =
    [[NSAttributedString alloc] initWithString:@"微信朋友圈\n"
                                    attributes:@{
                                                 NSForegroundColorAttributeName : UIColorFromRGB(0x999898),
                                                 NSParagraphStyleAttributeName : paragraphStyle,
                                                 NSFontAttributeName : [UIFont boldSystemFontOfSize:14]
                                                 }];
    
    NSAttributedString *string5 =
    [[NSAttributedString alloc] initWithString:@"在社交网络，主要是发动态，内容可以是招财猫的使用心得，经验传授等，还可以晒出你的收入，排名，重点是带上你的邀请链接或者ID，微信朋友圈是很好的方式，建议每周发2-3次收入的动态，求好友点赞，转发，吸引更多的朋友加入。\n"
                                    attributes:@{
                                                 NSForegroundColorAttributeName : UIColorFromRGB(0x999898),
                                                 NSParagraphStyleAttributeName : paragraphStyleWithHeadIndent,
                                                 NSFontAttributeName : [UIFont boldSystemFontOfSize:14]
                                                 }];
    
    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithAttributedString:string0];
    [message appendAttributedString:string1];
    [message appendAttributedString:string2];
    [message appendAttributedString:string3];
    [message appendAttributedString:string4];
    [message appendAttributedString:string5];
    
    // text view
    UITextView *textView = [UITextView new];
    
    textView.attributedText = message;
    
    textView.textContainerInset = UIEdgeInsetsMake(4, 12, 4, 12);
    
    [self.view addSubview:textView];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(bannerImgView.mas_bottom);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.view).with.offset(-(CGRectGetHeight(self.tabBarController.tabBar.frame)));
    }];
}

@end
