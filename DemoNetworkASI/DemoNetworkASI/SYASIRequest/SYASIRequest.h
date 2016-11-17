//
//  SYASIRequest.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 14-7-15.
//  Copyright (c) 2014年 ygsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "JSON.h"

/****************************************************************/

// 文件信息
@interface FileModal : NSObject

/// 文件名称
@property (nonatomic, strong) NSString *fileName;
/// 文件路径
@property (nonatomic, strong) NSString *filePath;

@end

/****************************************************************/

/// 网络请求方式
typedef enum
{
    /// GET方式
    ASIRequestGET = 1,
    
    /// POST方式
    ASIRequestPOST = 2
    
}ASIRequestType;

@interface SYASIRequest : NSObject

/// 单例
+ (SYASIRequest *)shareRequest;

/// 发送请求（没有参数时为GET，有参数时为POST；开始，成功，失败的block回调）
- (ASIFormDataRequest *)sendRequest:(NSString *)urlString
                          parameter:(NSDictionary *)parameter
                             target:(id)targer
                        didFinished:(void (^)(id obj))finishedBlock
                          didFailed:(void (^)(NSError *error))failedBlock;
/// 发送请求（自定义请求方式；开始，成功，失败的block回调）
- (ASIFormDataRequest *)sendRequest:(NSString *)urlString
                          parameter:(NSDictionary *)parameter
                        requestType:(ASIRequestType)type
                             target:(id)targer
                        didFinished:(void (^)(id obj))finishedBlock
                          didFailed:(void (^)(NSError *error))failedBlock;

///////////////////////////////////////////////////////////////////////

/// 退出网络请求
- (void)cancelASIRequest:(id)target;

///////////////////////////////////////////////////////////////////////

@end

/*
 说明
 
 配置
 1 添加ASIHttpRequest库文件
 2 添加6个动态库：libxml, CFNetwork, libz, CoreGraphics, MobileCoreServices, SystemConfiguration, libxml
 添加方法：项目名称-TARGETS-项目-Build Phases-Link Binary With Libraries-"+"
 3 设置Search Path
 设置方法：项目名称-TARGETS-项目-Build Settings-Search Paths-Header Search Paths（${SDK_DIR}/usr/include/libxml2）

 
 */

