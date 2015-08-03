# NetworkASIRequest
ASI网络请求

##配置

1 添加ASIHttpRequest库文件

2 添加6个动态库：libxml, CFNetwork, libz, CoreGraphics, MobileCoreServices, SystemConfiguration, libxml

添加方法：项目名称-TARGETS-项目-Build Phases-Link Binary With Libraries-"+"

3 设置Search Path

设置方法：项目名称-TARGETS-项目-Build Settings-Search Paths-Header Search Paths（${SDK_DIR}/usr/include/libxml2）

##使用说明

~~~ javascript
// 网络请求开始
NSString *url = @"http://192.168.16.240:9009/Product/GetAdvertisementInfo";
[[ASIRequestHelper shareRequest] sendRequest:url parameter:nil requestType:ASIRequestPOST target:self didFinished:^(id obj) {
NSLog(@"request success obj %@", obj);
} didFailed:^(NSError *error) {
NSLog(@"request fail");
}];

// 网络请求退出
[[ASIRequestHelper shareRequest] cancelASIRequest:self];

~~~

