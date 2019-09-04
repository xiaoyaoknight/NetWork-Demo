//
//  Test2ViewController.m
//  SDWebImage-Demo
//
//  Created by 王泽龙 on 2019/6/12.
//  Copyright © 2019 王泽龙. All rights reserved.
//

#import "Test2ViewController.h"

@interface Test2ViewController ()<NSURLConnectionDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSFileHandle *fileHandle;
@property (nonatomic, assign) NSInteger currentLength;
@property (nonatomic, assign) NSInteger fileLength;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation Test2ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"NSURLConnection";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(20, 100, 300, 2)];
    [self.view addSubview:self.progressView];
    self.progressView.backgroundColor = [UIColor brownColor];
    self.progressView.progress = 0;
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 200, 200, 200)];
    [self.view addSubview:self.imageView];
    self.imageView.center = self.view.center;
    self.imageView.backgroundColor = [UIColor greenColor];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(20, 600, 100, 30);
    btn1.backgroundColor = [UIColor blueColor];
    [self.view addSubview:btn1];
    [btn1 setTitle:@"同步请求" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(sendSynchronousRequest) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(200, 600, 100, 30);
    btn2.backgroundColor = [UIColor blueColor];
    [self.view addSubview:btn2];
    [btn2 setTitle:@"异步请求" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(sendAsynchronousRequest) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(320, 600, 100, 30);
    btn3.backgroundColor = [UIColor blueColor];
    [self.view addSubview:btn3];
    [btn3 setTitle:@"代理请求" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(sendRequestDelegate) forControlEvents:UIControlEventTouchUpInside];

    
}

/**
 同步请求
 */
- (void)sendSynchronousRequest {
    
    NSURL *url = [NSURL URLWithString:@"https://upload-images.jianshu.io/upload_images/1877784-b4777f945878a0b9.jpg"];
    NSURLRequest *retquest = [NSURLRequest requestWithURL:url];
    
    // 同步
    [NSURLConnection sendAsynchronousRequest:retquest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSLog(@"同步请求---------%@", response);
        self.imageView.image = [UIImage imageWithData:data];
        
    }];

}


/**
 异步请求
 */
- (void)sendAsynchronousRequest {
    
    
    NSURL *url = [NSURL URLWithString:@"https://upload-images.jianshu.io/upload_images/1877784-b4777f945878a0b9.jpg"];
    NSURLRequest *retquest = [NSURLRequest requestWithURL:url];
    // 异步
    [NSURLConnection sendAsynchronousRequest:retquest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSLog(@"异步请求---------%@", response);
        self.imageView.image = [UIImage imageWithData:data];
        // 可以在这里把下载的文件保存
    }];
    
}

/**
 代理方式
 */
- (void)sendRequestDelegate {
    
//    NSURL *url = [NSURL URLWithString:@"https://upload-images.jianshu.io/upload_images/1877784-b4777f945878a0b9.jpg"];
    NSURL *url = [NSURL URLWithString:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.4.0.dmg"];
    NSURLRequest *retquest = [NSURLRequest requestWithURL:url];
    // 代理的方式
    [NSURLConnection connectionWithRequest:retquest delegate:self];
    
}


#pragma mark <NSURLConnectionDataDelegate> 实现方法
/*
 - (nullable NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(nullable NSURLResponse *)response;
 - (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
 
 - (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
 
 - (nullable NSInputStream *)connection:(NSURLConnection *)connection needNewBodyStream:(NSURLRequest *)request;
 - (void)connection:(NSURLConnection *)connection   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
 totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite;
 
 - (nullable NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse;
 
 - (void)connectionDidFinishLoading:(NSURLConnection *)connection;
 */


/**
 * 接收到响应的时候：创建一个空的沙盒文件
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    // 获得下载文件的总长度
    self.fileLength = response.expectedContentLength;
    
    // 沙盒文件路径
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"QQ_V5.4.0.dmg"];
    
    NSLog(@"File downloaded to: %@",path);
    
    // 创建一个空的文件到沙盒中
    [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    
    // 创建文件句柄
    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
    
}

/**
 * 接收到具体数据：把数据写入沙盒文件中
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    self.imageView.image = [UIImage imageWithData:data];
    // 指定数据的写入位置 -- 文件内容的最后面
    [self.fileHandle seekToEndOfFile];
    
    // 向沙盒写入数据
    [self.fileHandle writeData:data];
    
    // 拼接文件总长度
    self.currentLength += data.length;
    
    // 下载进度
    self.progressView.progress =  1.0 * self.currentLength / self.fileLength;
}

/**
 *  下载完文件之后调用：关闭文件、清空长度
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading---------");
    // 关闭fileHandle
    [self.fileHandle closeFile];
    self.fileHandle = nil;
    
    // 清空长度
    self.currentLength = 0;
    self.fileLength = 0;

}

/**
 错误
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError---------%@", error);
}


- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
