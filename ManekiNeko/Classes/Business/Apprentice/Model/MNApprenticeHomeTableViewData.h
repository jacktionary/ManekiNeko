//
//  MNApprenticeHomeTableViewData.h
//  ManekiNeko
//
//  Created by JackCheng on 16/4/19.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNApprenticeHomeTableViewData : NSObject

// 添加数据源 + 数据源标签
- (void)addDataArray:(NSArray *)array arrayFlag:(NSString *)flag;

// 对应区域中的row的个数
- (NSInteger)numberOfRowsInSection:(NSInteger)section;

// 有几个section
- (NSInteger)numberOfSections;

// 对应于Section上的flag值标签
- (NSString *)flagInSection:(NSInteger)section;

// 对应于indexPath中的数据
- (id)dataInIndexPath:(NSIndexPath *)indexPath;

@end
