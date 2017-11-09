//
//  NSDictionary+NativeJSON.h
//  acfun_video
//
//  Created by 王晨旭 on 15/1/24.
//  Copyright (c) 2015年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NativeJSON)

-(NSString *)toJSONString;
-(NSData *)toJSONData;
@end
