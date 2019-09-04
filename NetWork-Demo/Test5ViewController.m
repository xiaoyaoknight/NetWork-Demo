//
//  Test5ViewController.m
//  SDWebImage-Demo
//
//  Created by 王泽龙 on 2019/6/12.
//  Copyright © 2019 王泽龙. All rights reserved.
//

#import "Test5ViewController.h"

@interface Test5ViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *timeLbl;
@property(nonatomic,strong) NSTimer *countDownTimer;

@end

//倒计时总的秒数
static NSInteger  secondsCountDown = 86400;

@implementation Test5ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"倒计时";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    
    self.timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 300, 30)];
    [self.view addSubview:self.timeLbl];
    
    
    //设置定时器
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
    //启动倒计时后会每秒钟调用一次方法 countDownAction
    
    //设置倒计时显示的时间
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",secondsCountDown/3600];//时
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(secondsCountDown%3600)/60];//分
    NSString *str_second = [NSString stringWithFormat:@"%02ld",secondsCountDown%60];//秒
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    self.timeLbl.text = [NSString stringWithFormat:@"即将开始：%@",format_time];
    //设置文字颜色
    self.timeLbl.textColor = [UIColor blackColor];
    
}

- (void)countDownAction {
    //倒计时-1
    secondsCountDown--;
    
    //重新计算 时/分/秒
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",secondsCountDown/3600];
    
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(secondsCountDown%3600)/60];
    
    NSString *str_second = [NSString stringWithFormat:@"%02ld",secondsCountDown%60];
    
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    //修改倒计时标签及显示内容
    self.timeLbl.text=[NSString stringWithFormat:@"即将开始：%@",format_time];
    
    //当倒计时到0时做需要的操作，比如验证码过期不能提交
    if(secondsCountDown ==0 ){
        
        [_countDownTimer invalidate];
    }

}


- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
