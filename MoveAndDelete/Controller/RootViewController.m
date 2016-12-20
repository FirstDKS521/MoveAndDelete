//
//  RootViewController.m
//  MoveAndDelete
//
//  Created by aDu on 2016/12/19.
//  Copyright © 2016年 aDu. All rights reserved.
//

#import "RootViewController.h"
#import "SYLifeManagerController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (IBAction)click:(id)sender {
    SYLifeManagerController *lifeVC = [[SYLifeManagerController alloc] init];
    [self.navigationController pushViewController:lifeVC animated:YES];
}


@end
