//
//  MNHttpSessionManager.m
//  ManekiNeko
//
//  Created by JackCheng on 15/9/15.
//  Copyright (c) 2015年 HardTime. All rights reserved.
//

#import "MNHttpSessionManager.h"
#import "MNStringUtils.h"
#import "MNNetWorkingConst.h"
#import "MNAppUtil.h"

@interface MNHttpSessionManager()

@end

@implementation MNHttpSessionManager

+ (instancetype)manager
{
    MNHttpSessionManager *manager = [[[self class] alloc] initWithBaseURL:[NSURL URLWithString:baseNetworkingURL]];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    securityPolicy.allowInvalidCertificates = YES;
    
    manager.securityPolicy = securityPolicy;
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [manager setResponseSerializer:responseSerializer];
    
    return manager;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    [self setupDefaultHeader];
    [self calculateSign:parameters];
    
    return [super GET:URLString parameters:parameters success:success failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    [self setupDefaultHeader];
    [self calculateSign:parameters];
    
    return [super POST:URLString parameters:parameters constructingBodyWithBlock:block success:success failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))success failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failure
{
    [self setupDefaultHeader];
    [self calculateSign:parameters];
    
    return [super POST:URLString parameters:parameters success:success failure:failure];
}

#pragma mark - 构建Header
- (void)setupDefaultHeader
{
    [self.requestSerializer setValue:@"moneykey" forHTTPHeaderField:@"appid"];
    [self.requestSerializer setValue:[MNAppUtil appVersion] forHTTPHeaderField:@"appversion"];
}

#pragma mark - 签名算法

- (void)calculateSign:(NSDictionary *)paramDict
{
    NSString *data = [NSString string];;
    
    if (paramDict) {
        NSMutableArray *sortedStringArray = [NSMutableArray array];
        
        NSArray *dictKeys = [paramDict allKeys];
        
        NSArray *sortedKeysArr = [dictKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }];
        
        for (NSString *dictKey in sortedKeysArr) {
            [sortedStringArray addObject:[NSString stringWithFormat:@"%@=%@", dictKey, [paramDict objectForKey:dictKey]]];
        }
        
        data = [sortedStringArray componentsJoinedByString:@"&"];
    }
    
    NSString *signInfoString = [NSString stringWithFormat:@"%@%@%@",
                                data,
                                @"moneykey", @"a20fc3ffa430f9ff7e7b382c10fc04570b8b92fafbc30fbe"];
    
    NSLog(@"string before md5：%@", signInfoString);
    
    NSString * signMD5String =[[StringUtils getMD5:signInfoString] substringWithRange:NSMakeRange(8, 16)];
    
    NSLog(@"sign：%@", signMD5String);
    
    [self.requestSerializer setValue:signMD5String forHTTPHeaderField:@"sign"];
}

@end
