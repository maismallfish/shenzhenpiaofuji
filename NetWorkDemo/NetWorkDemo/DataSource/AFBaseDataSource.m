//
//  AFBaseDataSource.m
//  NetWorkDemo
//
//  Created by wuyine on 2017/11/8.
//  Copyright © 2017年 wuyine. All rights reserved.
//

#import "AFBaseDataSource.h"
#import "AFBaseSessionManager.h"
@implementation AFBaseDataSource

- (instancetype) initWithSRResponseNetDeleagte:(id<AFResponseDeleagte>)delegate{
    
    self = [super init];
    if(self){
        _responseNetDelegate = delegate;
    }
    return  self;
}

+ (instancetype) dataSourceInitWithSRResponseNetDeleagte:(id<AFResponseDeleagte>)delegate{
    return [[self alloc] initWithSRResponseNetDeleagte:delegate];
}

+ (AFBaseSessionManager *) aFNetworkManager{
    
    static dispatch_once_t onceToken;
    static AFBaseSessionManager *operationManager;
    dispatch_once(&onceToken, ^{
        
        //https
        //证书
        // NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"t.smart.everylink.cn" ofType:@"cer"];
        // NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
        //NSSet *cerSet = [NSSet setWithObjects:cerData, nil];
        // AFSecurityPolicy *sercurityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        //是否允许无效证书，默认为no
        // sercurityPolicy.allowInvalidCertificates = YES;
        // sercurityPolicy.validatesDomainName = YES; //是否需要验证域名，默认为yes
        //[sercurityPolicy setPinnedCertificates:@[cerData]];
        
        operationManager = [AFBaseSessionManager manager];
        operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
        operationManager.responseSerializer = [AFJSONResponseSerializer serializer];
        // operationManager.securityPolicy = sercurityPolicy;
        [operationManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [operationManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        operationManager.requestSerializer.timeoutInterval = 12.0f;
        [operationManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/xml", nil];
    });
    return operationManager;
}

//get
-(NSURLSessionDataTask *)getWithUrl:(NSString *)url interfaceIndentifier:(NSString *)indentifier params:(NSDictionary *)params successBlock:(successBlock)success failureBlock:(failureBlock)failure {
    return [self method:@"GET" WithUrl:url interfaceIndentifier:indentifier params:params successBlock:success failureBlock:failure];
}

//post
-(NSURLSessionDataTask *)postWithUrl:(NSString *)url interfaceIndentifier:(NSString *)indentifier params:(NSDictionary *)params successBlock:(successBlock)success failureBlock:(failureBlock)failure {
    return [self method:@"POST" WithUrl:url interfaceIndentifier:indentifier params:params successBlock:success failureBlock:failure];
}

//method
-(NSURLSessionDataTask *)method:(NSString *)method WithUrl:(NSString *)url interfaceIndentifier:(NSString *)indentifier params:(NSDictionary *)params successBlock:(successBlock)success failureBlock:(failureBlock)failure{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if([_responseNetDelegate respondsToSelector:@selector(networkingStartWithInterfaceIndentifier:)]){
            [_responseNetDelegate networkingStartWithInterfaceIndentifier:indentifier];
        }
    });
    
    __weak __typeof(self) weakSelf = self;
    
    success = ^(NSURLSessionDataTask *task, id responseObject){
        [[AFBaseDataSource aFNetworkManager] removeTask:task];
        if(success){
            success(task,responseObject);
        }
        
        if([weakSelf.responseNetDelegate respondsToSelector:@selector(networkingCompletedWithInterfaceIndentifier:)]){
            [weakSelf.responseNetDelegate networkingCompletedWithInterfaceIndentifier:indentifier];
        }
    };
    
    failure = ^(NSURLSessionDataTask *task, NSError *error) {
        [[AFBaseDataSource aFNetworkManager] removeTask:task];
        NSString *errorMsg;
        NSLog(@"errorCode = %ld", (long)error.code);
        switch (error.code) {
            case -1005:
            case -1006:
            case -1007:
            case -1008:
            case -1009:
                errorMsg = @"网络连接失败";
                break;
            default:
                errorMsg = @"服务器繁忙";
                break;
        }
        if(failure){
            failure(task,error);
        }
        if([weakSelf.responseNetDelegate respondsToSelector:@selector(networkingFailurewithInterfaceIndentifier:errorCode:errorMessage:)]){
            [weakSelf.responseNetDelegate networkingFailurewithInterfaceIndentifier:indentifier errorCode:error.code errorMessage:errorMsg];
        }
        if([weakSelf.responseNetDelegate respondsToSelector:@selector(networkingCompletedWithInterfaceIndentifier:)]){
            [weakSelf.responseNetDelegate networkingCompletedWithInterfaceIndentifier:indentifier];
        }
    };
    
    NSURLSessionDataTask *originTask;
    if ([method isEqualToString:@"GET"]) {
        originTask = [[AFBaseDataSource aFNetworkManager] GET:url parameters:params success:success failure:failure];
    }else if([method isEqualToString:@"POST"]) {
        originTask = [[AFBaseDataSource aFNetworkManager] POST:url parameters:params success:success failure:failure];
    }
    [[AFBaseDataSource aFNetworkManager] addTask:originTask];
    return  originTask;
}

//上传图片
-(NSURLSessionDataTask *) uploadImageWithData:(NSData *)data url:(NSString *)url indentifier:(NSString*) indentifier success:(successBlock) success failure:(failureBlock) failure{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if([_responseNetDelegate respondsToSelector:@selector(networkingStartWithInterfaceIndentifier:)]){
            [_responseNetDelegate networkingStartWithInterfaceIndentifier:indentifier];
        }
    });
    
    __weak __typeof(self) weakSelf = self;
    success = ^(NSURLSessionDataTask *task, id responseObject) {
        [[AFBaseDataSource aFNetworkManager] removeTask:task];
        
        if(success){
            success(task,responseObject);
        }
        if([weakSelf.responseNetDelegate respondsToSelector:@selector(networkingCompletedWithInterfaceIndentifier:)]){
            [weakSelf.responseNetDelegate networkingCompletedWithInterfaceIndentifier:indentifier];
        }
    };
    
    failure = ^(NSURLSessionDataTask *task, NSError *error) {
        [[AFBaseDataSource aFNetworkManager] removeTask:task];
        
        NSString *errorMsg;
        switch (error.code) {
            case -1005:
            case -1006:
            case -1007:
            case -1008:
            case -1009:
                errorMsg = @"网络连接失败";
                break;
            default:
                errorMsg = @"服务器繁忙";
                break;
        }
        if(failure){
            failure(task,error);
        }
        if([weakSelf.responseNetDelegate respondsToSelector:@selector(networkingFailurewithInterfaceIndentifier:errorCode:errorMessage:)]){
            [weakSelf.responseNetDelegate networkingFailurewithInterfaceIndentifier:indentifier errorCode:error.code errorMessage:errorMsg];
        }
    };
    
    NSURLSessionDataTask *originTask = [[AFBaseDataSource aFNetworkManager] POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData:data name:@"file"];
        [formData appendPartWithFormData:[@"PICTURE" dataUsingEncoding:NSUTF8StringEncoding] name:@"uoloadType"];
    }success:success failure:failure];
    
    [[AFBaseDataSource aFNetworkManager] addTask:originTask];
    return originTask;
}

#pragma mark -other
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (void)cancelAllTask {
    [[AFBaseDataSource aFNetworkManager] cancelAllTask];
}

@end
