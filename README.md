# iOS Touch ID使用记录
由于最近的项目中用到了Touch ID，这里就给大家介绍下用法
  
  1)首先你需要导入```LocalAuthentication.framework```，如下图所示
  
  ![Touch_ID](http://upload-images.jianshu.io/upload_images/1178923-fb057346b582090a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
 
  2)在需要使用的文件导入```#import <LocalAuthentication/LocalAuthentication.h>```
  
  3)因为TouchID只适用于iOS8及以上，所以我们首先需要判断系统是否为iOS8及以上```
  SystemVersion [UIDevice currentDevice].systemVersion.doubleValue >= 8```
  
  然后判断机型是否支持TouchID，判断的方法为
  
  ```
- (BOOL)canEvaluatePolicy:(LAPolicy)policy error:(NSError *__autoreleasing *)error;
  ```
  
  然后直接调用以下的方法直接调用TouchID
  
  ```
- (void)evaluatePolicy:(LAPolicy)policy localizedReason:(NSString *)localizedReason reply:(void(^)(BOOL success, NSError *error))reply;
   
   ```
  
[我的简书][1]
[1]: http://www.jianshu.com/users/988436fc80e7/latest_articles

##### 具体的代码在这
```
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
@end
```
