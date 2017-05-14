//
//  MNApprenticeDescriptionWhyViewController.m
//  ManekiNeko
//
//  Created by JackCheng on 16/4/21.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNApprenticeDescriptionWhyViewController.h"
#import "Masonry.h"
#import "MNMacro.h"

@implementation MNApprenticeDescriptionWhyViewController

- (NSString *)title
{
    return @"为什么要收徒";
}

- (void)initSubViews
{
    @weakify(self);
    UIImageView *bannerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_appre_why_banner"]];
    
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
    paragraphStyle.firstLineHeadIndent = 25.0;
    
    NSAttributedString *subjectString =
    [[NSAttributedString alloc] initWithString:@"想赚更多的钱吗？那就收徒弟吧！招财猫师徒活动，收徒弟有奖励。（由招财猫官方补贴）\n"
                                    attributes:@{
                                                 NSForegroundColorAttributeName : UIColorFromRGB(0x999898),
                                                 NSParagraphStyleAttributeName : paragraphStyle,
                                                 NSFontAttributeName : [UIFont boldSystemFontOfSize:14]
                                                 }];
    NSAttributedString *verbString = [[NSAttributedString alloc] initWithString:@"收一名徒弟，你可获得徒弟赚得收入的10%奖励\n"
                                                                     attributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xfb7540),NSParagraphStyleAttributeName : paragraphStyle,   NSFontAttributeName : [UIFont boldSystemFontOfSize:14]
                                                                                  }];
    
    NSAttributedString *objectString =
    [[NSAttributedString alloc] initWithString:@"总之，你的徒弟做任务，不仅徒弟全额收入，你也会得到招财猫官方额外给予的奖励！徒弟奖励是永久有效的哦。\n亲们，这不是白日梦，这是真实的赚钱攻略，在招财猫，已经有越来越多的猫友因为收徒变成有钱的大腕！所以，各位想赚钱的亲们，请不要独来独往，拉帮结派的收徒吧！只要“师门”够壮大，徒弟数量够多，招财猫保证你天天有钱花！"
                                    attributes:@{
                                                 NSForegroundColorAttributeName : UIColorFromRGB(0x999898),
                                                 NSParagraphStyleAttributeName : paragraphStyle,
                                                 NSFontAttributeName : [UIFont boldSystemFontOfSize:14]
                                                 }];
    
    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithAttributedString:subjectString];
    [message appendAttributedString:verbString];
    [message appendAttributedString:objectString];
    
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
