//
//  MRHomeViewModel.m
//  MVVM_RAC
//
//  Created by chengxianghe on 2017/1/20.
//  Copyright © 2017年 cn. All rights reserved.
//

#import "MRHomeViewModel.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import <SVProgressHUD.h>

@interface MRHomeViewModel ()

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation MRHomeViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)searchDataWithText:(NSString *)searchText completion:(MRHomeViewModelBlock)completion {
    
}

- (void)setup {
    @weakify(self);
    [self.refreshDataCommand.executionSignals.switchToLatest subscribeNext:^(NSMutableArray *array) {
        
        @strongify(self);
        self.dataArray = array;
        
//        [self.listHeaderViewModel.refreshUISubject sendNext:nil];
        [self.refreshEndSubject sendNext:@(MJRefreshStateIdle)];
        [SVProgressHUD showSuccessWithStatus:@"加载完成"];
    }];
    
    
    [[[self.refreshDataCommand.executing skip:1] take:1] subscribeNext:^(id x) {
        
        if ([x isEqualToNumber:@(YES)]) {
            [SVProgressHUD showWithStatus:@"正在加载"];
        }
    }];
    
    [self.nextPageCommand.executionSignals.switchToLatest subscribeNext:^(NSMutableArray *array) {
        
        @strongify(self);
        
        [self.dataArray addObjectsFromArray:array];
        if (array.count < 20) {
            [self.refreshEndSubject sendNext:@(MJRefreshStateNoMoreData)];
        } else {
            [self.refreshEndSubject sendNext:@(MJRefreshStateIdle)];
        }
        [SVProgressHUD dismiss];
    }];

}

- (RACSubject *)refreshUI {
    
    if (!_refreshUI) {
        
        _refreshUI = [RACSubject subject];
    }
    
    return _refreshUI;
}

- (RACSubject *)refreshEndSubject {
    
    if (!_refreshEndSubject) {
        
        _refreshEndSubject = [RACSubject subject];
    }
    
    return _refreshEndSubject;
}

- (RACCommand *)refreshDataCommand {
    
    if (!_refreshDataCommand) {
        
        @weakify(self);
        _refreshDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                @strongify(self);
                self.currentPage = 1;
                
                NSString *herosString = [[NSBundle mainBundle] pathForResource:@"heros" ofType:@"plist"];
                
                NSMutableArray *herosArray = [NSMutableArray arrayWithContentsOfFile:herosString];
                NSMutableArray *heros = [NSMutableArray array];
                for (NSInteger i = 0; (i < 20 && i < herosArray.count); i ++) {
                    MRHomeModel *hero = [MRHomeModel mj_objectWithKeyValues:herosArray[i]];
                    [heros addObject:hero];
                }
                
                double delayInSeconds = 2.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    BOOL success = random()%10 < 8;
                    if (success) {
                        [subscriber sendNext:heros];
                        [subscriber sendCompleted];
                    } else {
                        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
                        [subscriber sendCompleted];
                    }
                });
                return nil;
            }];
        }];
    }
    
    return _refreshDataCommand;
}

- (RACCommand *)nextPageCommand {
    
    if (!_nextPageCommand) {
        
        @weakify(self);
        _nextPageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                @strongify(self);
                
                NSString *herosString = [[NSBundle mainBundle] pathForResource:@"heros" ofType:@"plist"];
                
                NSMutableArray *herosArray = [NSMutableArray arrayWithContentsOfFile:herosString];
                NSMutableArray *heros = [NSMutableArray array];
                NSInteger start = self.currentPage * 20;
                for (NSInteger i = start; (i < start + 20 && i < herosArray.count); i ++) {
                    MRHomeModel *hero = [MRHomeModel mj_objectWithKeyValues:herosArray[i]];
                    [heros addObject:hero];
                }

                
                double delayInSeconds = 2.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    @strongify(self);
                    BOOL success = random()%10 < 8;
                    if (success) {
                        self.currentPage ++;
                        [subscriber sendNext:heros];
                        [subscriber sendCompleted];
                    } else {
                        self.currentPage --;
                        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
                        [subscriber sendCompleted];
                    }
                });
                return nil;
            }];
        }];
    }
    
    return _nextPageCommand;
}

//- (LSCircleListHeaderViewModel *)listHeaderViewModel {
//    
//    if (!_listHeaderViewModel) {
//        
//        _listHeaderViewModel = [[LSCircleListHeaderViewModel alloc] init];
//        _listHeaderViewModel.title = @"已加入的圈子";
//        _listHeaderViewModel.cellClickSubject = self.cellClickSubject;
//    }
//    
//    return _listHeaderViewModel;
//}

- (NSMutableArray <MRHomeModel *>*)dataArray {
    
    if (!_dataArray) {
        
        _dataArray = [[NSMutableArray alloc] init];
    }
    
    return _dataArray;
}

- (RACSubject *)cellClickSubject {
    
    if (!_cellClickSubject) {
        
        _cellClickSubject = [RACSubject subject];
    }
    
    return _cellClickSubject;
}


@end
