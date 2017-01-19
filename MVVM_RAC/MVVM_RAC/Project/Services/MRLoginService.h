//
//  MRLoginService.h
//  MVVM_RAC
//
//  Created by chengxianghe on 2017/1/19.
//  Copyright © 2017年 cn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^MRLoginResponse)(BOOL);

@interface MRLoginService : NSObject

+ (BOOL)isValidUsername:(NSString *)username;

+ (BOOL)isValidPassword:(NSString *)password;

+ (void)signInWithUsername:(NSString *)username password:(NSString *)password complete:(MRLoginResponse)completeBlock;



@end
