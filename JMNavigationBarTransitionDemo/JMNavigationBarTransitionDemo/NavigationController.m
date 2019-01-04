//
//  NavigationController.m
//  Test
//
//  Created by 刘轩博 on 17/4/18.
//  Copyright © 2017年 刘轩博. All rights reserved.
//

#import "NavigationController.h"
#import "UINavigationController+Transition.h"

@interface NavigationController ()<UINavigationControllerDelegate>

@property (nonatomic, weak) id popDelegate;

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.popDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
    self.interactivePopGestureRecognizer.delegate = nil;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isEqual:self.viewControllers[0]]) {
        self.interactivePopGestureRecognizer.delegate = self.popDelegate;
    } else {
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
