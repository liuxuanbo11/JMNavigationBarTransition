//
//  UINavigationController+Transition.m
//  Test
//
//  Created by lxb on 2018/5/9.
//  Copyright © 2018年 lxb. All rights reserved.
//

#import "UINavigationController+Transition.h"
#import "UINavigationBar+Transition.h"
#import "JMSwizzel.h"
#import <objc/runtime.h>
#import "UIImage+JMColorImage.h"

@implementation UINavigationController (Transition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        JMSwizzleMethod([self class], @selector(viewDidLoad), [self class], @selector(jm_viewDidLoad));
    });
}

- (void)jm_viewDidLoad {
    // 初始化navigationBar属性
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor greenColor] size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setTranslucent:YES];
    // 自定义阴影
    [self.navigationBar addShadowViewWithAlpha:1];
    
    [self jm_viewDidLoad];
}


@end

