//
//  Test4ViewController.m
//  SDWebImage-Demo
//
//  Created by 王泽龙 on 2019/6/12.
//  Copyright © 2019 王泽龙. All rights reserved.
//

#import "Test4ViewController.h"

@interface Test4ViewController ()
@property (strong, nonatomic)  UIImageView *imageView;

@property (strong, nonatomic)  UIButton *breakpointButton;

@property (strong, nonatomic)  UILabel *progressLabel;

//文件的沙盒路径
@property(nonatomic,strong) NSString *filePaths;

//本地已经下载的文件的大小
@property(nonatomic,assign) NSInteger fileSize;

//文件总共的大小
@property(nonatomic,assign) NSInteger altogetherSize;

@property (nonatomic, strong) NSURLSessionDownloadTask *task;

@property (nonatomic, strong) NSData *resumeData;

@property (nonatomic, strong) NSURLSession *session;
@end

@implementation Test4ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"断点下载";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];

    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 200, 200, 200)];
    [self.view addSubview:self.imageView];
    self.imageView.center = self.view.center;
    self.imageView.backgroundColor = [UIColor greenColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(20, 600, 120, 30);
    btn1.backgroundColor = [UIColor blueColor];
    [self.view addSubview:btn1];
    [btn1 setTitle:@"breakpointData" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(breakpointData:) forControlEvents:UIControlEventTouchUpInside];
    
    self.filePaths = 0;
    self.fileSize = 0;
    self.altogetherSize = 0;
    
}

#pragma mark --- 断点下载 ---

- (void)breakpointData:(UIButton *)sender {
    
    if (self.task == nil) { // 开始（继续）下载
        
        if (self.resumeData) { // 恢复
            
            [sender setTitle:@"暂停" forState:UIControlStateNormal];
            
            [self resume];
        } else { // 开始
            [self start];
            
            [sender setTitle:@"暂停" forState:UIControlStateNormal];
            
        }
    } else { // 暂停
        
        [sender setTitle:@"继续" forState:UIControlStateNormal];
        
        [self pause];
    }
    
    
}

//懒加载
- (NSURLSession *)session
{
    if (!_session) {
        // 获得session
        NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:cfg delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}



- (void)start
{
    // 1.创建一个下载任务
    NSURL *url = [NSURL URLWithString:@"http://www.deskcar.com/desktop/fengjing/20125700336/18.jpg"];
    self.task = [self.session downloadTaskWithURL:url];
    
    // 2.开始任务
    [self.task resume];
}


- (void)resume
{
    // 传入上次暂停下载返回的数据，就可以恢复下载
    self.task = [self.session downloadTaskWithResumeData:self.resumeData];
    
    // 开始任务
    [self.task resume];
    
    // 清空
    self.resumeData = nil;
}


- (void)pause
{
    __weak typeof(self) vc = self;
    [self.task cancelByProducingResumeData:^(NSData *resumeData) {
        //  resumeData : 包含了继续下载的开始位置\下载的url
        vc.resumeData = resumeData;
        vc.task = nil;
    }];
}

#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    //根据请求头中的文件名在沙盒中直接创建路径
    NSURLResponse *response = downloadTask.response;
    
    NSString *filePaths =[self cacheDir:response.suggestedFilename];
    
    self.filePaths = filePaths;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //将临时的下载文件(在内存中)放入沙盒中.
    [fileManager moveItemAtURL:location toURL:[NSURL fileURLWithPath:filePaths] error:nil];
    
    self.imageView.image = [UIImage imageWithContentsOfFile:self.filePaths];
    
    
    
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
    if (totalBytesExpectedToWrite > self.altogetherSize) {
        
        self.altogetherSize = totalBytesExpectedToWrite;
        
        NSLog(@"%ld",(long)self.altogetherSize);
    }
    
    NSLog(@"%f",(double)totalBytesWritten / self.altogetherSize);
    
    self.progressLabel.text = [NSString stringWithFormat:@"%.0f ％",(double)100*totalBytesWritten / self.altogetherSize];
    
    if ((double)totalBytesWritten / self.altogetherSize == 1) {
        
        
        //关掉用户交互
        [self.breakpointButton setTitle:@"完成" forState:UIControlStateNormal];
        
        
        self.breakpointButton.userInteractionEnabled = NO;
        
    }
}



#pragma mark --- 输入一个字符串,则在沙盒中生成路径
// 传入字符串,直接在沙盒Cache中生成路径
- (NSString *)cacheDir:(NSString *)paths
{
    NSString *cache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    
    return [cache stringByAppendingPathComponent:[paths lastPathComponent]];
}


- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
