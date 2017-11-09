//
//  AFBaseSessionManager.h
//  NetWorkDemo
//
//  Created by wuyine on 2017/11/8.
//  Copyright © 2017年 wuyine. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <objc/runtime.h>

@interface AFBaseSessionManager : AFHTTPSessionManager
- (void)addTask:(NSURLSessionDataTask *)task;
- (void)removeTask:(NSURLSessionDataTask *)task;
- (NSMutableDictionary *)taskQueue;
- (BOOL)isRequesting;
- (void)cancelAllTask;
@end
