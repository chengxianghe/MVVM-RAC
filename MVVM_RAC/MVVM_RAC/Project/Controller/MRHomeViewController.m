//
//  MRHomeViewController.m
//  MVVM_RAC
//
//  Created by chengxianghe on 2017/1/19.
//  Copyright © 2017年 cn. All rights reserved.
//

#import "MRHomeViewController.h"
#import "MRHomeViewModel.h"
#import "MRHeroViewController.h"
#import "MRHomeTableView.h"

@interface MRHomeViewController ()

@property (strong, nonatomic) MRHomeViewModel *viewModel;
@property (strong, nonatomic) MRHomeTableView *tableView;

@end

@implementation MRHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    
    @weakify(self);
    [[self.viewModel.cellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(MRHomeModel *hero) {
        @strongify(self);
        [self performSegueWithIdentifier:@"gotoHero" sender:hero];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MRHomeTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MRHomeTableView alloc] initWithViewModel:self.viewModel];
    }
    
    return _tableView;
}

- (MRHomeViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[MRHomeViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"gotoHero"]) {
        MRHeroViewController *vc = segue.destinationViewController;
        vc.hero = sender;
    }
}

@end
