//
//  JCIOKitNodeInfo.m
//  IOKitTest
//
//  Created by Christopher Anderson on 28/12/2013.
//  Copyright (c) 2013 Electric Labs. All rights reserved.
//

#import "JCIOKitNodeInfo.h"


@implementation JCIOKitNodeInfo


- (instancetype)init {
    self = [super init];
    if (self) {
        _children = [NSMutableArray new];
    }
    return self;
}

- (id)initWithParent:(JCIOKitNodeInfo *)parent nodeInfoWithInfo:(NSString *)info properties:(NSArray *)properties {
    self = [self init];
    if (self) {
        _parent = parent;
        _name = info;
        _properties = properties;

    }
    return self;
}

- (void)addChild:(JCIOKitNodeInfo *)child {
   if(child != nil)
       [_children addObject:child];
}

@end
