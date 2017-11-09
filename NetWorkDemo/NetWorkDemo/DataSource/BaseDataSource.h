//
//  BaseDataSource.h
//  NetWorkDemo
//
//  Created by wuyine on 2017/10/31.
//  Copyright © 2017年 wuyine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

//请求成功回调block
typedef void (^requestSuccessBlock)(NSURLSessionTask *task, NSDictionary * responseObject);

//请求失败回调block
typedef void (^requestFailureBlock)(NSURLSessionTask *operation, NSError *error);

//请求方法define
typedef enum {
    GET,
    POST,
    PUT,
    DELETE,
    HEAD
} HTTPMethod;

@interface BaseDataSource : AFHTTPSessionManager
+ (instancetype)sharedManager;
- (void)requestWithMethod:(HTTPMethod)method
                 WithPath:(NSString *)path
               WithParams:(NSDictionary*)params
         WithSuccessBlock:(requestSuccessBlock)success
          WithFailurBlock:(requestFailureBlock)failure;
@end
