//
//  MRRegisterService.m
//  MVVM_RAC
//
//  Created by chengxianghe on 2017/1/19.
//  Copyright © 2017年 cn. All rights reserved.
//

#import "MRRegisterService.h"

@implementation MRRegisterService

+ (BOOL)isValidPassword:(NSString *)password andSurePassword:(NSString *)surePassword {
    return [password isEqualToString:surePassword];
}

+ (void)registerWithUsername:(NSString *)username password:(NSString *)password complete:(MRRegisterServiceBlock)completeBlock {
    [[NSUserDefaults standardUserDefaults] setValue:password forKey:username];
    [[NSUserDefaults standardUserDefaults] synchronize];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        BOOL success = username.length > 3 && password.length > 3;
        completeBlock(success);
    });
}

@end
