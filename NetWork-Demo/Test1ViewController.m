//
//  Test1ViewController.m
//  内存管理-Demo
//
//  Created by 王泽龙 on 2019/5/22.
//  Copyright © 2019 王泽龙. All rights reserved.
//

#import "Test1ViewController.h"

@interface Test1ViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation Test1ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"最原始的网络下载 -- NSData+NSURL方式";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];

    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    button.frame = CGRectMake(100, 100, 200, 100);
    [button setTitle:@"请求" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor blueColor];
    [button addTarget:self action:@selector(request) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 220, [UIScreen mainScreen].bounds.size.width, 349)];
    self.imageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.imageView];
}

- (void)request {
    // 在子线程中发送下载文件请求
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 创建下载路径
        NSURL *url = [NSURL URLWithString:@"https://upload-images.jianshu.io/upload_images/1877784-b4777f945878a0b9.jpg"];
        
        // NSData的dataWithContentsOfURL:方法下载
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        // 回到主线程，刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.imageView.image = [UIImage imageWithData:data];
        });
    });
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
