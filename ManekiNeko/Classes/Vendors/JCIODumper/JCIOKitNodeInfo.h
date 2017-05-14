//
//  JCIOKitNodeInfo.h
//  IOKitTest
//
//  Created by Christopher Anderson on 28/12/2013.
//  Copyright (c) 2013 Electric Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCIOKitNodeInfo : NSObject

@property(nonatomic, weak) JCIOKitNodeInfo *parent;
@property(nonatomic, copy, readonly) NSMutableArray *children;


@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSArray *properties;


@property(nonatomic, assign) NSInteger searchCount;
@property(nonatomic, strong) NSArray *matchingProperties;
@property(nonatomic, strong) NSArray *matchedChildren;


- (id)initWithParent:(JCIOKitNodeInfo *)parent nodeInfoWithInfo:(NSString *)info properties:(NSArray *)properties;

- (void)addChild:(JCIOKitNodeInfo *)child;

@end
