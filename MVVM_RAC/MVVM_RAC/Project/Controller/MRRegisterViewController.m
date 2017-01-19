//
//  MRRegisterViewController.m
//  MVVM_RAC
//
//  Created by chengxianghe on 2017/1/19.
//  Copyright © 2017年 cn. All rights reserved.
//

#import "MRRegisterViewController.h"
#import "MRRegisterService.h"
#import "MRLoginService.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MRRegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgainTextField;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (weak, nonatomic) IBOutlet UILabel *surePasswordFailureLabel;

@end

@implementation MRRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // UI
    self.surePasswordFailureLabel.hidden = YES;
    self.sureButton.enabled = NO;

    // 创建信号 username
    RACSignal *validUserNameSignal = [self.usernameTextField.rac_textSignal map:^id(NSString *text) {
        return @([MRLoginService isValidUsername:text]);
    }];
    
    // 创建信号 password
    RACSignal *validPasswordSignal = [self.passwordTextField.rac_textSignal map:^id(NSString *text) {
        return @([MRLoginService isValidPassword:text]);
    }];
    
    // 创建信号 surepassword
    RACSignal *validSurePasswordSignal = [self.passwordAgainTextField.rac_textSignal map:^id(NSString *text) {
        return @([MRLoginService isValidPassword:text]);
    }];
    
    // 检测信号 两次密码是否一致
    RACSignal *samePasswordSignal = [RACSignal combineLatest:@[validPasswordSignal, validSurePasswordSignal] reduce:^id(NSNumber *passwordValid, NSNumber *surePasswordValid){
        return @([MRRegisterService isValidPassword:self.passwordTextField.text andSurePassword:self.passwordAgainTextField.text]);
    }];
    
    
    // 绑定信号和属性 username 监听处理， 这里相当于根据信号返回的值确定usernameTextField的backgroundColor
    RAC(self.usernameTextField, backgroundColor) = [validUserNameSignal map:^id(NSNumber *usernameValid) {
        return [usernameValid boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
    }];
    
    // 绑定信号和属性 password 监听处理
    RAC(self.passwordTextField, backgroundColor) = [validPasswordSignal map:^id(NSNumber *passwordValid) {
        return [passwordValid boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
    }];

    // 绑定信号和属性 surepassword 监听处理
    RAC(self.passwordAgainTextField, backgroundColor) = [validSurePasswordSignal map:^id(NSNumber *passwordValid) {
        return [passwordValid boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
    }];
    
    // 密码一致性提示
    [samePasswordSignal subscribeNext:^(NSNumber *surePassword) {
        self.surePasswordFailureLabel.hidden = [surePassword boolValue];
    }];
    
    // 错误提示
    // 创建信号combineLatest（将多个信号合并起来，并且拿到各个信号的最新的值,必须每个合并的signal至少都有过一次sendNext，才会触发合并的信号。）
    RACSignal *registerActiveSignal = [RACSignal combineLatest:@[validUserNameSignal, validPasswordSignal, validSurePasswordSignal, samePasswordSignal] reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid, NSNumber *surePasswordValid, NSNumber *samePasswordValid){
        return @([usernameValid boolValue] && [passwordValid boolValue] && [surePasswordValid boolValue] && [samePasswordValid boolValue]);
    }];
    
    // 处理signUpActiveSignal信号
    [registerActiveSignal subscribeNext:^(NSNumber *registerActive) {
        self.sureButton.enabled = [registerActive boolValue];
    }];
    
    // 绑定注册按钮事件
    [[[[self.sureButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(id x) {
        self.sureButton.enabled = NO;
    }] flattenMap:^id(id value) {
        // 此处判断登录是否成功 并返回信号
        RACSignal *registerSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [MRRegisterService registerWithUsername:self.usernameTextField.text
                                      password:self.passwordTextField.text
                                      complete:^(BOOL success) {
                                          [subscriber sendNext:@(success)];
                                          [subscriber sendCompleted];
                                      }];
            return nil;
        }];
        return registerSignal;
    }] subscribeNext:^(NSNumber *registerResult) {
        NSLog(@"register result: %@", registerResult);
        BOOL success = [registerResult boolValue];
        if (success) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            self.sureButton.enabled = NO;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
