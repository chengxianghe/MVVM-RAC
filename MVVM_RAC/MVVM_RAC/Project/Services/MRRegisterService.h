//
//  MRRegisterService.h
//  MVVM_RAC
//
//  Created by chengxianghe on 2017/1/19.
//  Copyright © 2017年 cn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^MRRegisterServiceBlock)(BOOL);

@interface MRRegisterService : NSObject

+ (BOOL)isValidPassword:(NSString *)password andSurePassword:(NSString *)surePassword;

- (void)registerWithUsername:(NSString *)username password:(NSString *)password complete:(MRRegisterServiceBlock)completeBlock;

@end
