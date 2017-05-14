//
//  MNApprenticeHomeTableViewData.m
//  ManekiNeko
//
//  Created by JackCheng on 16/4/19.
//  Copyright © 2016年 HardTime. All rights reserved.
//

#import "MNApprenticeHomeTableViewData.h"

@interface MNApprenticeHomeTableViewData()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *nameList;

@end

@implementation MNApprenticeHomeTableViewData

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _dataArray = [NSMutableArray new];
        _nameList  = [NSMutableArray new];
    }
    return self;
}

- (void)addDataArray:(NSArray *)array arrayFlag:(NSString *)flag
{
    [_dataArray addObject:array];
    [_nameList  addObject:flag];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray[section] count];
}

- (NSInteger)numberOfSections
{
    return [_dataArray count];
}

- (NSString *)flagInSection:(NSInteger)section
{
    return _nameList[section];
}

- (id)dataInIndexPath:(NSIndexPath *)indexPath
{
    return _dataArray[indexPath.section][indexPath.row];
}

@end
