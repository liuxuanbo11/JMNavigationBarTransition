//
//  UINavigationBar+Transition.m
//  Test
//
//  Created by lxb on 2018/5/11.
//  Copyright © 2018年 lxb. All rights reserved.
//

#import "UINavigationBar+Transition.h"
#import <objc/runtime.h>
#import "UIImage+JMColorImage.h"
#import "JMMacros.h"

@implementation UINavigationBar (Transition)

- (void)setJm_shadowImgView:(UIImage *)jm_shadowImgView {
    objc_setAssociatedObject(self, @selector(jm_shadowImgView), jm_shadowImgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)jm_shadowImgView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)addShadowViewWithAlpha:(CGFloat)alpha {
    if (!self.jm_shadowImgView) {
        UIView *barBackgroundView = [self valueForKey:@"_backgroundView"];
        self.jm_shadowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, JM_NavBarHeight, self.frame.size.width, 0.5)];
        [barBackgroundView addSubview:self.jm_shadowImgView];
    }
    self.jm_shadowImgView.image = [UIImage imageWithColor:[[UIColor blackColor] colorWithAlphaComponent:0.3 * alpha] size:CGSizeMake(1, 1)];
}


@end
