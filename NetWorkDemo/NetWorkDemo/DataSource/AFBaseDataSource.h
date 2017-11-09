//
//  AFBaseDataSource.h
//  NetWorkDemo
//
//  Created by wuyine on 2017/11/8.
//  Copyright © 2017年 wuyine. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol AFResponseDeleagte <NSObject>

-(void) networkingStartWithInterfaceIndentifier:(NSString*) indentifier;
-(void) networkingCompletedWithInterfaceIndentifier:(NSString*) indentifier;
-(void) networkingFailurewithInterfaceIndentifier:(NSString*) indentifier errorCode:(NSInteger)code  errorMessage:(NSString*)message;

@end

@interface AFBaseDataSource : NSObject
typedef void(^successBlock)(NSURLSessionDataTask *task, id responseObject);
typedef void(^failureBlock)(NSURLSessionDataTask *task, NSError *error);

@property (weak, nonatomic, readonly) id<AFResponseDeleagte> responseNetDelegate;

- (instancetype) initWithSRResponseNetDeleagte:(id<AFResponseDeleagte>)delegate;
+ (instancetype) dataSourceInitWithSRResponseNetDeleagte:(id<AFResponseDeleagte>)delegate;

//get
-(NSURLSessionDataTask *)getWithUrl:(NSString *)url interfaceIndentifier:(NSString *)indentifier params:(NSDictionary *)params successBlock:(successBlock)success failureBlock:(failureBlock)failure;

//post
-(NSURLSessionDataTask *)postWithUrl:(NSString *)url interfaceIndentifier:(NSString *)indentifier params:(NSDictionary *)params successBlock:(successBlock)success failureBlock:(failureBlock)failure;

-(NSURLSessionDataTask *) uploadImageWithData:(NSData *)data url:(NSString *)url indentifier:(NSString*) indentifier success:(successBlock) success failure:(failureBlock) failure;
@end



