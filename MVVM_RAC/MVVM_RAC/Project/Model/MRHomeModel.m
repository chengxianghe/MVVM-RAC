//
//  MRHomeModel.m
//  MVVM_RAC
//
//  Created by chengxianghe on 2017/1/20.
//  Copyright © 2017年 cn. All rights reserved.
//

#import "MRHomeModel.h"
#import <MJExtension.h>
#import <UIKit/UIKit.h>

@implementation MRHomeModel

- (void)mj_keyValuesDidFinishConvertingToObject {
    float h = 51;
    float wordH = [self.intro boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 105, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil].size.height;
    self.homeCellHeight =  MAX(95, h + wordH);
}

@end
