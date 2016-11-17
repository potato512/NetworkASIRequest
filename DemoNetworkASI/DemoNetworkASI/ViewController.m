//
//  ViewController.m
//  DemoNetworkASI
//
//  Created by zhangshaoyu on 15/8/3.
//  Copyright (c) 2015年 zhangshaoyu. All rights reserved.
//

#import "ViewController.h"
#import "SYASIRequest.h"

@interface ViewController ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"ASI";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"clear" style:UIBarButtonItemStyleDone target:self action:@selector(clearClick:)];
    UIBarButtonItem *cacel = [[UIBarButtonItem alloc] initWithTitle:@"cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelClick:)];
    UIBarButtonItem *request = [[UIBarButtonItem alloc] initWithTitle:@"Request" style:UIBarButtonItemStyleDone target:self action:@selector(requestClick:)];
    self.navigationItem.rightBarButtonItems = @[request, cacel];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, (CGRectGetWidth(self.view.bounds) - 10.0 * 2), (CGRectGetHeight(self.view.bounds) - 10.0 * 2))];
    [self.view addSubview:self.label];
    self.label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.label.numberOfLines = 0;
    self.label.backgroundColor = [UIColor lightGrayColor];
    self.label.textColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
}

- (void)clearClick:(UIBarButtonItem *)button
{
    self.label.text = @"";
}

- (void)cancelClick:(UIBarButtonItem *)button
{
    // 取消网络请求
    [[SYASIRequest shareRequest] cancelASIRequest:self];
}

- (void)requestClick:(UIBarButtonItem *)button
{
    NSString *url = @"http://ditu.amap.com/service/regeo?longitude=121.04925573429551&latitude=31.315590522490712";
    
    // 网络请求
    // 1 没有parameter时自适配为GET请求
    [[SYASIRequest shareRequest] sendRequest:url parameter:nil target:self didFinished:^(id obj) {
        NSString *text = [obj JSONRepresentation];
        self.label.text = text;
    } didFailed:^(NSError *error) {
        self.label.text = [NSString stringWithFormat:@"error = %@", error];
    }];
    
    // 或2 用户配置GET，或POST请求
    [[SYASIRequest shareRequest] sendRequest:url parameter:nil requestType:ASIRequestGET target:self didFinished:^(id obj) {
        NSString *text = [obj JSONRepresentation];
        self.label.text = text;
    } didFailed:^(NSError *error) {
        self.label.text = [NSString stringWithFormat:@"error = %@", error];
    }];
}

@end
