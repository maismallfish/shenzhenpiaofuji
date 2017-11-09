//
//  AFBaseSessionManager.m
//  NetWorkDemo
//
//  Created by wuyine on 2017/11/8.
//  Copyright © 2017年 wuyine. All rights reserved.
//

#import "AFBaseSessionManager.h"

@implementation AFBaseSessionManager
-(void)addTask:(NSURLSessionDataTask *)task{
    NSMutableDictionary *taskQueue = [self taskQueue];
    [taskQueue setObject:task forKey:@(task.taskIdentifier)];
}

-(void)removeTask:(NSURLSessionDataTask *)task{
    if ([self isRequesting]) {
        NSMutableDictionary *taskQueue = [self taskQueue];
        [taskQueue removeObjectForKey:@(task.taskIdentifier)];
    }
}

-(void)cancelAllTask{
    if ([self isRequesting]) {
        NSMutableDictionary *taskQueue = [self taskQueue];
        for (NSURLSessionDataTask *task in taskQueue.allValues) {
            [task cancel];
        }
        [taskQueue removeAllObjects];
    }
}

-(NSMutableDictionary *)taskQueue{
    NSMutableDictionary *taskDic = objc_getAssociatedObject(self, @selector(addTask:));
    if (!taskDic) {
        taskDic = @{}.mutableCopy;
        objc_setAssociatedObject(self, @selector(addTask:), taskDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return taskDic;
}

-(BOOL)isRequesting{
    NSMutableDictionary *taskDic = objc_getAssociatedObject(self, @selector(addTask:));
    if (taskDic.allKeys.count > 0) {
        return YES;
    }
    return NO;
}
@end
