//
//  MRHomeViewModel.h
//  MVVM_RAC
//
//  Created by chengxianghe on 2017/1/20.
//  Copyright © 2017年 cn. All rights reserved.
//

/**
 职责：
 获取新数据
 处理数据
 */

#import <Foundation/Foundation.h>
#import "MRHomeModel.h"
#import <ReactiveCocoa.h>

typedef void(^MRHomeViewModelBlock)(NSMutableArray <__kindof MRHomeModel *>*);

@interface MRHomeViewModel : NSObject

@property (nonatomic, strong) RACSubject *refreshEndSubject;

@property (nonatomic, strong) RACSubject *refreshUI;

@property (nonatomic, strong) RACCommand *refreshDataCommand;

@property (nonatomic, strong) RACCommand *nextPageCommand;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) RACSubject *cellClickSubject;

- (void)searchDataWithText:(NSString *)searchText completion:(MRHomeViewModelBlock)completion;

@end
