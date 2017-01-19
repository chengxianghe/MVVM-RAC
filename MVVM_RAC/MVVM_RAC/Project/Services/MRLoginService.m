//
//  MRLoginService.m
//  MVVM_RAC
//
//  Created by chengxianghe on 2017/1/19.
//  Copyright © 2017年 cn. All rights reserved.
//

#import "MRLoginService.h"

@implementation MRLoginService

+ (BOOL)isValidUsername:(NSString *)username {
    return username.length > 3;
}

+ (BOOL)isValidPassword:(NSString *)password {
    return password.length > 3;
}

+ (void)signInWithUsername:(NSString *)username password:(NSString *)password complete:(MRLoginResponse)completeBlock {
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSString *pass = [[NSUserDefaults standardUserDefaults] valueForKey:username];
        BOOL success = [pass isEqualToString:password];
        completeBlock(success);
    });
}


@end
