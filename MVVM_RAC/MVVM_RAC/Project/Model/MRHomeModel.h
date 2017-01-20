//
//  MRHomeModel.h
//  MVVM_RAC
//
//  Created by chengxianghe on 2017/1/20.
//  Copyright © 2017年 cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRHomeModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *icon;

@property (assign, nonatomic) float homeCellHeight;

@end
