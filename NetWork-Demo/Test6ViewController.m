//
//  Test6ViewController.m
//  SDWebImage-Demo
//
//  Created by 王泽龙 on 2019/6/13.
//  Copyright © 2019 王泽龙. All rights reserved.
//

#import "Test6ViewController.h"


@interface Test6ViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImageView *imageView2;
@end

@implementation Test6ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"SDWebImage-Demo";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
//    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn1.frame = CGRectMake(20, 80, 300, 50);
//    [self.view addSubview:btn1];
//    [btn1 setBackgroundColor:[UIColor blueColor]];
//    [btn1 setTitle:@"根据图片数据获取图片类型" forState:UIControlStateNormal];
//    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btn1 addTarget:self action:@selector(getImageType) forControlEvents:UIControlEventTouchUpInside];
//
//    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn2.frame = CGRectMake(20, 150, 400, 50);
//    [btn2 setBackgroundColor:[UIColor redColor]];
//    [self.view addSubview:btn2];
//    [btn2 setTitle:@"获取一张图片的两倍或者三倍屏幕下面对应图片" forState:UIControlStateNormal];
//    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btn2 addTarget:self action:@selector(getScaleImage) forControlEvents:UIControlEventTouchUpInside];
//
//
//    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 200, 200, 100)];
//    [self.view addSubview:self.imageView];
//    self.imageView.backgroundColor = [UIColor greenColor];
//
//
//    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn3.frame = CGRectMake(20, 320, 300, 50);
//    [self.view addSubview:btn3];
//    [btn3 setBackgroundColor:[UIColor blueColor]];
//    [btn3 setTitle:@"图片的解压缩" forState:UIControlStateNormal];
//    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btn3 addTarget:self action:@selector(unZipImage) forControlEvents:UIControlEventTouchUpInside];
//
//
//    self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 400, 200, 100)];
//    [self.view addSubview:self.imageView2];
//    self.imageView2.backgroundColor = [UIColor grayColor];
}



- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
