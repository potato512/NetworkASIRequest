//
//  ViewController.m
//  DemoNetworkASI
//
//  Created by zhangshaoyu on 15/8/3.
//  Copyright (c) 2015年 zhangshaoyu. All rights reserved.
//

#import "ViewController.h"
#import "ASIRequestHelper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"ASI";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"RequestCancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelbuttonClick:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Request" style:UIBarButtonItemStyleDone target:self action:@selector(buttonClick:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelbuttonClick:(UIBarButtonItem *)button
{
    [[ASIRequestHelper shareRequest] cancelASIRequest:self];
}

- (void)buttonClick:(UIBarButtonItem *)button
{
    NSString *url = @"http://192.168.16.240:9009/Product/GetAdvertisementInfo";
    [[ASIRequestHelper shareRequest] sendRequest:url parameter:nil requestType:ASIRequestPOST target:self didFinished:^(id obj) {
        NSLog(@"request success obj %@", obj);
    } didFailed:^(NSError *error) {
        NSLog(@"request fail");
    }];
}

@end
