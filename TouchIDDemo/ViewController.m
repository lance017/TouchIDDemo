//
//  ViewController.m
//  TouchIDDemo
//
//  Created by WangPengHui on 16/5/26.
//  Copyright © 2016年 美鲜冻品商城. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

#define SystemVersion [UIDevice currentDevice].systemVersion.doubleValue

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [[UIButton alloc]init];
    button.center = self.view.center;
    button.bounds = CGRectMake(0, 0, 100, 40);
    [button setTitle:@"指纹识别" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)click {
    //只有iOS8以上支持Touch ID
    if (SystemVersion >= 8.0) {
        LAContext *context = [[LAContext alloc]init];
        NSError *error = nil;
        //验证机器是否支持指纹识别
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
            //支持指纹识别
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"APP请求验证" reply:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                    NSLog(@"验证成功");
                }
                
                switch (error.code) {
                    case LAErrorAppCancel:
                        NSLog(@"切换到其他APP，系统取消验证");
                        break;
                    case LAErrorUserCancel:
                        NSLog(@"用户取消验证");
                        break;
                    case LAErrorUserFallback:
                        NSLog(@"用户选择输入密码，切换主线程处理");
                        break;
                    default:
                        break;
                }
                
                if (error) {
                    NSLog(@"%@",error.localizedDescription);
                }
                
            }];
        }else{
            //机器不支持指纹识别
        }
    }else{
        //iOS8以下不支持Touch ID
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
