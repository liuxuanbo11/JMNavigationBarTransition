//
//  UIViewController+Transition.m
//  Test
//
//  Created by 刘轩博 on 2018/5/4.
//  Copyright © 2018年 lxb. All rights reserved.
//

#import "UIViewController+Transition.h"
#import "UINavigationController+Transition.h"
#import "UINavigationBar+Transition.h"
#import <objc/runtime.h>
#import "JMSwizzel.h"
#import "UIImage+JMColorImage.h"
#import "JMMacros.h"

@implementation UIViewController (Transition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        JMSwizzleMethod([self class], @selector(viewDidLoad), [self class], @selector(jm_viewDidLoad));
        JMSwizzleMethod([self class], @selector(viewWillAppear:), [self class], @selector(jm_viewWillAppear:));
        JMSwizzleMethod([self class], @selector(viewDidAppear:), [self class], @selector(jm_viewDidAppear:));
    });
}

- (void)jm_viewDidLoad {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self jm_viewDidLoad];
}

- (void)jm_viewWillAppear:(BOOL)animated {
    id<UIViewControllerTransitionCoordinator> tc = self.navigationController.transitionCoordinator;
    UIViewController *fromController = [tc viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toController = [tc viewControllerForKey:UITransitionContextToViewControllerKey];

    if (fromController && toController) {
        if (fromController.jm_isNavigationBarHidden || toController.jm_isNavigationBarHidden) {
            [self.navigationController setNavigationBarHidden:self.jm_isNavigationBarHidden animated:YES];
        }
        if (![self isEqualImage:fromController toController:toController]) {
            if (fromController.jm_isNavigationBarHidden || toController.jm_isNavigationBarHidden) {
                UIViewController *vc = toController.jm_isNavigationBarHidden ? fromController : toController;
                [self.navigationController.navigationBar setBackgroundImage:[vc.jm_navBarBackgroundImage imageByAppendAlpha:vc.jm_navBarAlpha] forBarMetrics:UIBarMetricsDefault];
                [self.navigationController.navigationBar addShadowViewWithAlpha:vc.jm_navBarAlpha];
            } else {
                // 改变导航栏透明度的过渡方式
                [self addFakeNavBar:fromController toController:toController];
                [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
                self.navigationController.navigationBar.jm_shadowImgView.image = [UIImage new];
            }
        }
    }
    
    [self jm_viewWillAppear:animated];
}

- (void)jm_viewDidAppear:(BOOL)animated {
    if (self.jm_isNavigationBarHidden) {
        // 首页导航栏隐藏的情况
        [self.navigationController setNavigationBarHidden:self.jm_isNavigationBarHidden animated:NO];
    }
    
    id<UIViewControllerTransitionCoordinator> tc = self.navigationController.transitionCoordinator;
    UIViewController *fromController = [tc viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toController = [tc viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (fromController && toController) {
        // 恢复导航栏默认样式
        if (![self isEqualImage:fromController toController:toController]) {
            if (fromController.jm_isNavigationBarHidden || toController.jm_isNavigationBarHidden) {
                [self.navigationController.navigationBar setBackgroundImage:[self.jm_navBarBackgroundImage imageByAppendAlpha:self.jm_navBarAlpha] forBarMetrics:UIBarMetricsDefault];
                [self.navigationController.navigationBar addShadowViewWithAlpha:self.jm_navBarAlpha];
            } else {
                [self.navigationController.navigationBar setBackgroundImage:[self.jm_navBarBackgroundImage imageByAppendAlpha:self.jm_navBarAlpha] forBarMetrics:UIBarMetricsDefault];
                self.navigationController.navigationBar.jm_shadowImgView.image = self.jm_fakeNavigationBar.jm_shadowImgView.image;
                [self removeFakeNavBar:fromController toController:toController];
            }
        }
        // 导航栏item可能出现的错乱处理(iOS 11之前的bug)
        if (![[self.navigationController.navigationBar.items lastObject] isEqual:self.navigationItem]) {
            [self.navigationController setValue:[UINavigationBar new] forKey:@"navigationBar"];
            [self.navigationController.navigationBar setBackgroundImage:[self.jm_navBarBackgroundImage imageByAppendAlpha:self.jm_navBarAlpha] forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar addShadowViewWithAlpha:self.jm_navBarAlpha];
        }
    }
    
    [self jm_viewDidAppear:animated];
}

// 判断两个控制器的导航栏图片是否相同
- (BOOL)isEqualImage:(UIViewController *)fromController toController:(UIViewController *)toController {
    NSData *fromImgData = UIImagePNGRepresentation(fromController.jm_navBarBackgroundImage);
    NSData *toImgData = UIImagePNGRepresentation(toController.jm_navBarBackgroundImage);
    return ([fromImgData isEqual:toImgData] && fromController.jm_navBarAlpha == toController.jm_navBarAlpha);
}

// 添加临时导航栏
- (void)addFakeNavBar:(UIViewController *)fromController toController:(UIViewController *)toController {
    if (!fromController.jm_fakeNavigationBar) {
        fromController.jm_fakeNavigationBar = [self createFakeNavBarWithController:fromController];
        [fromController.view addSubview:fromController.jm_fakeNavigationBar];
    }
    if (!toController.jm_fakeNavigationBar) {
        toController.jm_fakeNavigationBar = [self createFakeNavBarWithController:toController];
        [toController.view addSubview:toController.jm_fakeNavigationBar];
    }
}

// 移除临时导航栏
- (void)removeFakeNavBar:(UIViewController *)fromController toController:(UIViewController *)toController {
    if (fromController.jm_fakeNavigationBar) {
        [fromController.jm_fakeNavigationBar removeFromSuperview];
        fromController.jm_fakeNavigationBar = nil;
    }
    if (toController.jm_fakeNavigationBar) {
        [toController.jm_fakeNavigationBar removeFromSuperview];
        toController.jm_fakeNavigationBar = nil;
    }
}

// 创建一个临时导航栏
- (UINavigationBar *)createFakeNavBarWithController:(UIViewController *)controller {
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, JM_NavBarHeight - 44, self.navigationController.navigationBar.bounds.size.width, 44)];
    [bar setBackgroundImage:[controller.jm_navBarBackgroundImage imageByAppendAlpha:controller.jm_navBarAlpha] forBarMetrics:UIBarMetricsDefault];
    [bar setShadowImage:[UIImage new]];
    bar.barStyle = self.navigationController.navigationBar.barStyle;
    bar.translucent = self.navigationController.navigationBar.translucent;

    // 阴影
    [bar addShadowViewWithAlpha:controller.jm_navBarAlpha];
    bar.jm_shadowImgView.frame = CGRectMake(CGRectGetMinX(bar.jm_shadowImgView.frame), CGRectGetHeight(bar.jm_shadowImgView.superview.frame), CGRectGetWidth(bar.jm_shadowImgView.frame), CGRectGetHeight(bar.jm_shadowImgView.frame));

    // 状态栏
    UIImageView *statusBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, bar.frame.size.height - JM_NavBarHeight, bar.frame.size.width, JM_NavBarHeight - bar.frame.size.height)];
    CGFloat alpha = controller.jm_navBarAlpha == 1 ? 0.90984 : controller.jm_navBarAlpha;
    statusBar.image = [controller.jm_navBarBackgroundImage imageByAppendAlpha:alpha];
    [bar addSubview:statusBar];

    return bar;
}


#pragma mark - getter setter method
// 导航栏背景颜色
- (void)setJm_navBarBackgroundColor:(UIColor *)jm_navBarBackgroundColor {
    if (jm_navBarBackgroundColor) {
        objc_setAssociatedObject(self, @selector(jm_navBarBackgroundColor), jm_navBarBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.jm_navBarBackgroundImage = [UIImage imageWithColor:jm_navBarBackgroundColor size:CGSizeMake(1, 1)];        
    }
}

- (UIColor *)jm_navBarBackgroundColor {
    return objc_getAssociatedObject(self, _cmd);
}

// 导航栏背景图片
- (void)setJm_navBarBackgroundImage:(UIImage *)jm_navBarBackgroundImage {
    if (jm_navBarBackgroundImage) {
        objc_setAssociatedObject(self, @selector(jm_navBarBackgroundImage), jm_navBarBackgroundImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self.navigationController.navigationBar setBackgroundImage:[jm_navBarBackgroundImage imageByAppendAlpha:self.jm_navBarAlpha] forBarMetrics:UIBarMetricsDefault];
    }
}

- (UIImage *)jm_navBarBackgroundImage {
    UIImage *image = objc_getAssociatedObject(self, _cmd);
    if (!image) {
        image = [[UINavigationBar appearance] backgroundImageForBarMetrics:UIBarMetricsDefault];
    }
    return image;
}

// 导航栏透明度
- (void)setJm_navBarAlpha:(CGFloat)jm_navBarAlpha {
    objc_setAssociatedObject(self, @selector(jm_navBarAlpha), @(jm_navBarAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.navigationController.navigationBar setBackgroundImage:[self.jm_navBarBackgroundImage imageByAppendAlpha:jm_navBarAlpha] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar addShadowViewWithAlpha:jm_navBarAlpha];
}

- (CGFloat)jm_navBarAlpha {
    NSNumber *alphaNumber = objc_getAssociatedObject(self, _cmd);
    if (!alphaNumber) {
        alphaNumber = @1;
    }
    return [alphaNumber floatValue];
}

- (void)setJm_fakeNavigationBar:(UINavigationBar *)jm_fakeNavigationBar {
    objc_setAssociatedObject(self, @selector(jm_fakeNavigationBar), jm_fakeNavigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UINavigationBar *)jm_fakeNavigationBar {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setJm_isNavigationBarHidden:(BOOL)jm_isNavigationBarHidden {
    objc_setAssociatedObject(self, @selector(jm_isNavigationBarHidden), @(jm_isNavigationBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)jm_isNavigationBarHidden {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}


@end
