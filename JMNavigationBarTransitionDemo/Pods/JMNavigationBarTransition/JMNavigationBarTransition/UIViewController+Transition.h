//
//  UIViewController+Transition.h
//  Test
//
//  Created by 刘轩博 on 2018/5/4.
//  Copyright © 2018年 lxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Transition)

@property (nonatomic, strong) UINavigationBar *jm_fakeNavigationBar;

@property (nonatomic, strong) UIColor *jm_navBarBackgroundColor;

@property (nonatomic, strong) UIImage *jm_navBarBackgroundImage;

// 控制导航栏透明度
@property (nonatomic, assign) CGFloat jm_navBarAlpha;
// 导航栏是否隐藏
@property (nonatomic, assign) BOOL jm_isNavigationBarHidden;

@end
