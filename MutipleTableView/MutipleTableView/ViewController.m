//
//  ViewController.m
//  MutipleTableView
//
//  Created by wuyine on 2017/9/29.
//  Copyright © 2017年 wuyine. All rights reserved.
//

#import "ViewController.h"
#import "LeftTableViewController.h"
#import "RightTableViewController.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (nonatomic,strong) LeftTableViewController *leftVC;
@property (nonatomic,strong) RightTableViewController *rightVC;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"left"];
    __weak __typeof(self) weakSelf = self;
    [self.leftVC setLeftCellClickBlock:^(NSInteger selectIndex, NSString *categoryName) {
        weakSelf.rightVC.selectIndex = selectIndex;
        [weakSelf.rightVC.tableView reloadData];
    }];
    [self.leftView addSubview:self.leftVC.view];
    [self addChildViewController:self.leftVC];
    [self.leftVC didMoveToParentViewController:self];

    
    self.rightVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"right"];
    [self.rightView addSubview:self.rightVC.view];
    [self addChildViewController:self.rightVC];
    [self.rightVC didMoveToParentViewController:self];
    [self.rightVC beginAppearanceTransition:YES animated:YES];
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
