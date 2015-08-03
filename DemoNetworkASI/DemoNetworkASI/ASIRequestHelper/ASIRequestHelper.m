//
//  NetRequestBlockManager.m
//  DemoNetWork
//
//  Created by zhangshaoyu on 14-7-15.
//  Copyright (c) 2014年 ygsoft. All rights reserved.
//

#import "ASIRequestHelper.h"

/****************************************************************/

// 文件信息
@implementation FileModal

@synthesize fileName;
@synthesize filePath;

@end

/****************************************************************/

@interface ASIRequestHelper ()

@property (nonatomic, strong) NSMutableArray *requestArray;

@end

@implementation ASIRequestHelper

+ (ASIRequestHelper *)shareRequest
{
    static ASIRequestHelper *staticRequestManager;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        staticRequestManager = [[self alloc] init];
        assert(staticRequestManager != nil);
    });
    
    return staticRequestManager;
}

/// 发送请求
- (ASIFormDataRequest *)sendRequest:(NSString *)urlString
                          parameter:(NSDictionary *)parameter
                             target:(id)targer
                        didFinished:(void (^)(id obj))finishedBlock
                          didFailed:(void (^)(NSError *error))failedBlock
{
    // 创建请求 __block 在非ARC下时使用，而ARC下则用__weak
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // 设置请求模式，根据有无参数情况
    NSString *requestMethod = (!parameter ? @"GET" : @"POST");
    request.requestMethod = requestMethod;
    // 设置请求超时
    request.timeOutSeconds = 30.0;
    
    // 参数设置
    for (NSString *key in parameter.allKeys)
    {
        id valueObj = [parameter objectForKey:key];
        if ([valueObj isKindOfClass:[FileModal class]])
        {
            // 上传文件
            FileModal *fileModal = (FileModal *)valueObj;
            NSString *filePath = fileModal.filePath;
            NSString *fileName = [filePath substringFromIndex:[filePath rangeOfString:@"/" options:NSBackwardsSearch].location + 1];
            [request setFile:filePath withFileName:fileName andContentType:@"multipart/form-data" forKey:key];
        }
        else
        {
            [request setPostValue:valueObj forKey:key];
        }
    }
    
    __weak ASIFormDataRequest *weakRequest = request;
    
    /*
    // 设置请求开始时
    [request setStartedBlock:^{
#if NS_BLOCKS_AVAILABLE

#endif
    }];
    */
    
    // 设置请求成功时
    [request setCompletionBlock:^{
#if NS_BLOCKS_AVAILABLE
        if (finishedBlock)
        {
            NSString *responseString = [[NSString alloc] initWithData:[weakRequest responseData] encoding:NSUTF8StringEncoding];
            finishedBlock([responseString JSONValue]);
            
            NSLog(@"request url:%@\n request methord:%@\n requst para:%@\n result:%@", urlString, weakRequest.requestMethod, parameter, responseString);
        }
#endif
    }];
    
    // 设置请求失败时
    [request setFailedBlock:^{
#if NS_BLOCKS_AVAILABLE
        if (failedBlock)
        {
            failedBlock([weakRequest error]);
        }
#endif
    }];
    
    // 发送异步请求
    [request startAsynchronous];
    
    // 添加到请求数组，便于管理
    if (targer)
    {
        request.delegate = targer;
        [self addASIRequest:request];
    }
    
    return request;
}

/// 发送请求，自定义请求方式
- (ASIFormDataRequest *)sendRequest:(NSString *)urlString
                          parameter:(NSDictionary *)parameter
                        requestType:(ASIRequestType)type
                             target:(id)targer
                        didFinished:(void (^)(id obj))finishedBlock
                          didFailed:(void (^)(NSError *error))failedBlock
{
    // 创建请求 __block 在非ARC下时使用，而ARC下则用__weak
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // 设置请求模式，根据有无参数情况
    NSString *requestMethod = (ASIRequestGET == type ? @"GET" : @"POST");
    request.requestMethod = requestMethod;
    // 设置请求超时
    request.timeOutSeconds = 30.0;
    
    // 参数设置
    for (NSString *key in parameter.allKeys)
    {
        id valueObj = [parameter objectForKey:key];
        if ([valueObj isKindOfClass:[FileModal class]])
        {
            // 上传文件
            FileModal *fileModal = (FileModal *)valueObj;
            NSString *filePath = fileModal.filePath;
            NSString *fileName = [filePath substringFromIndex:[filePath rangeOfString:@"/" options:NSBackwardsSearch].location + 1];
            [request setFile:filePath withFileName:fileName andContentType:@"multipart/form-data" forKey:key];
        }
        else
        {
            [request setPostValue:valueObj forKey:key];
        }
    }
    
    __weak ASIFormDataRequest *weakRequest = request;
    
    /*
    // 设置请求开始时
    [request setStartedBlock:^{
#if NS_BLOCKS_AVAILABLE

#endif
    }];
    */
    
    // 设置请求成功时
    [request setCompletionBlock:^{
#if NS_BLOCKS_AVAILABLE
        if (finishedBlock)
        {
            NSString *responseString = [[NSString alloc] initWithData:[weakRequest responseData] encoding:NSUTF8StringEncoding];
            finishedBlock([responseString JSONValue]);
            
            NSLog(@"request url:%@\n request methord:%@\n requst para:%@\n result:%@", urlString, weakRequest.requestMethod, parameter, responseString);
        }
#endif
    }];
    
    // 设置请求失败时
    [request setFailedBlock:^{
#if NS_BLOCKS_AVAILABLE
        if (failedBlock)
        {
            failedBlock([weakRequest error]);
        }
#endif
    }];
    
    // 发送异步请求
    [request startAsynchronous];
    
    // 添加到请求数组，便于管理
    if (targer)
    {
        request.delegate = targer;
        [self addASIRequest:request];
    }
    
    return request;
}

///////////////////////////////////////////////////////////////////////

/// 添加网络请求
- (void)addASIRequest:(ASIFormDataRequest *)request
{
    if (!self.requestArray)
    {
        self.requestArray = [[NSMutableArray alloc] init];
    }
    
    if (request)
    {
        [self.requestArray addObject:request];
    }
}

/// 退出网络请求
- (void)cancelASIRequest:(id)target
{
    if (self.requestArray)
    {
        NSMutableArray *removeArray = [[NSMutableArray alloc] init];
        
        for (ASIFormDataRequest *request in self.requestArray)
        {
            if (target == request.delegate)
            {
                [request clearDelegatesAndCancel];
                request.delegate = nil;
                
                [removeArray addObject:request];
                
                NSLog(@"Request cancel %@", target);
            }
        }
        
        if (0 != removeArray.count)
        {
            [self.requestArray removeObjectsInArray:removeArray];
        }
    }
}

///////////////////////////////////////////////////////////////////////

@end
