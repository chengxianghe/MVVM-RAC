//
//  MRLoginViewController.m
//  MVVM_RAC
//
//  Created by chengxianghe on 2017/1/19.
//  Copyright © 2017年 cn. All rights reserved.
//

#import "MRLoginViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MRLoginService.h"

@interface MRLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UILabel *signInFailureText;

@end

@implementation MRLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.signInFailureText.hidden = YES;
    
    // 创建信号 username
    RACSignal *validUserNameSignal = [self.usernameTextField.rac_textSignal map:^id(NSString *text) {
        return @([MRLoginService isValidUsername:text]);
    }];
    
    // 创建信号 password
    RACSignal *validPasswordSignal = [self.passwordTextField.rac_textSignal map:^id(NSString *text) {
        return @([MRLoginService isValidPassword:text]);
    }];
    
    // 绑定信号和属性 username 监听处理， 这里相当于根据信号返回的值确定usernameTextField的backgroundColor
    RAC(self.usernameTextField, backgroundColor) = [validUserNameSignal map:^id(NSNumber *usernameValid) {
        return [usernameValid boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
    }];
    
    // 绑定信号和属性 password 监听处理
    RAC(self.passwordTextField, backgroundColor) = [validPasswordSignal map:^id(NSNumber *passwordValid) {
        return [passwordValid boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
    }];

    // 创建信号combineLatest（将多个信号合并起来，并且拿到各个信号的最新的值,必须每个合并的signal至少都有过一次sendNext，才会触发合并的信号。）
    RACSignal *signUpActiveSignal = [RACSignal combineLatest:@[validUserNameSignal, validPasswordSignal] reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid){
        return @([usernameValid boolValue] && [passwordValid boolValue]);
    }];
    
    // 处理signUpActiveSignal信号
    [signUpActiveSignal subscribeNext:^(NSNumber *signUpActive) {
        self.signInButton.enabled = [signUpActive boolValue];
    }];
    
    // 绑定登录按钮事件
    [[[[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(id x) {
        self.signInButton.enabled = NO;
        self.signInFailureText.hidden = YES;
    }] flattenMap:^id(id value) {
        // 此处判断登录是否成功 并返回信号
        return [self signInSignal];
    }] subscribeNext:^(NSNumber *signIn) {
        NSLog(@"sign result: %@", signIn);
        BOOL success = [signIn boolValue];
        self.signInButton.enabled = YES;
        self.signInFailureText.hidden = success;
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"signInSuccess" sender:self];
            });
        }
    }];

    // 绑定注册按钮事件 点击跳转注册页
    [[[self.registerButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(id x) {
        self.registerButton.enabled = NO;
    }] subscribeNext:^(id x) {
        self.registerButton.enabled = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"gotoRegister" sender:nil];
        });
    }];

}

- (RACSignal *)signInSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // sign in
        [MRLoginService signInWithUsername:self.usernameTextField.text
                                  password:self.passwordTextField.text
                                  complete:^(BOOL success) {
                                      [subscriber sendNext:@(success)];
                                      [subscriber sendCompleted];
                                  }];
        return nil;
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
