//
//  BaseViewController.h
//  JMNavigationBarTransitionDemo
//
//  Created by lxb on 2018/5/23.
//  Copyright © 2018年 lxb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Transition.h"

@interface BaseViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) BOOL nextNavBarDifferentColor;

@property (nonatomic, assign) BOOL nextNavBarHidden;

@property (nonatomic, assign) CGFloat nextNavBarAlpha;


- (void)addBackButton;


@end
