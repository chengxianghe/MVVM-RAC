//
//  MRHomeTableView.m
//  MVVM_RAC
//
//  Created by chengxianghe on 2017/1/20.
//  Copyright © 2017年 cn. All rights reserved.
//

#import "MRHomeTableView.h"
#import "MRHomeViewModel.h"
#import "MRHomeCell.h"
#import <MJRefresh.h>

@interface MRHomeTableView () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) MRHomeViewModel *viewModel;

@property (strong, nonatomic) UITableView *mainTableView;

//@property (strong, nonatomic) LSCircleListHeaderView *listHeaderView;


@end

@implementation MRHomeTableView

#pragma mark - system

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupViews];
        [self bindViewModel];
    }
    return self;
}

- (instancetype)initWithViewModel:(MRHomeViewModel *)viewModel {
    
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    if (self) {
        [self setupViews];
        self.viewModel = viewModel;
        [self bindViewModel];
    }
    return self;
}

#pragma mark - private
- (void)setupViews {
    
    [self addSubview:self.mainTableView];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)bindViewModel {
    
    [self.viewModel.refreshDataCommand execute:nil];
    
    @weakify(self);
    
    [self.viewModel.refreshUI subscribeNext:^(id x) {
        
        @strongify(self);
        [self.mainTableView reloadData];
    }];
    
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self);
        
        [self.mainTableView reloadData];
        
        switch ([x integerValue]) {
            case MJRefreshStateIdle: {
                
                [self.mainTableView.mj_header endRefreshing];
                [self.mainTableView.mj_footer endRefreshing];

                if (self.mainTableView.mj_footer == nil) {
                    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                        @strongify(self);
                        [self.viewModel.nextPageCommand execute:nil];
                    }];
                }
            }
                break;
            case MJRefreshStateNoMoreData: {
                
                [self.mainTableView.mj_header endRefreshing];
                self.mainTableView.mj_footer = nil;
            }
                break;
            default:
                break;
        }
    }];
}

#pragma mark - lazyLoad
- (MRHomeViewModel *)viewModel {
    
    if (!_viewModel) {
        
        _viewModel = [[MRHomeViewModel alloc] init];
    }
    
    return _viewModel;
}

- (UITableView *)mainTableView {
    
    if (!_mainTableView) {
        
        _mainTableView = [[UITableView alloc] initWithFrame:self.bounds];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _mainTableView.tableHeaderView = self.listHeaderView;
        [_mainTableView registerNib:[UINib nibWithNibName:@"MRHomeCell" bundle:nil] forCellReuseIdentifier:@"MRHomeCell"];
        
        __weak typeof(self)weakSelf = self;
        
        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [weakSelf.viewModel.refreshDataCommand execute:nil];
        }];
        _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            [weakSelf.viewModel.nextPageCommand execute:nil];
        }];
    }
    
    return _mainTableView;
}


#pragma mark - delegate

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    MRHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MRHomeCell" forIndexPath:indexPath];
    
    if (self.viewModel.dataArray.count > indexPath.row) {
        [cell setInfo:self.viewModel.dataArray[indexPath.row]];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [MRHomeCell heightWithInfo:self.viewModel.dataArray[indexPath.row]];
    return [self.viewModel.dataArray[indexPath.row] homeCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.viewModel.cellClickSubject sendNext:self.viewModel.dataArray[indexPath.row]];
}

@end
