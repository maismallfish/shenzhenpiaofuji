//
//  NSDictionary+NativeJSON.m
//  acfun_video
//
//  Created by 王晨旭 on 15/1/24.
//  Copyright (c) 2015年 wang. All rights reserved.
//

#import "NSDictionary+NativeJSON.h"

@implementation NSDictionary (NativeJSON)

-(NSString *)toJSONString
{
    return [[NSString alloc]initWithData:[self toJSONData] encoding:NSUTF8StringEncoding];
}

-(NSData *)toJSONData
{
    return [NSJSONSerialization dataWithJSONObject:self options:0 error:NULL];
}

@end
