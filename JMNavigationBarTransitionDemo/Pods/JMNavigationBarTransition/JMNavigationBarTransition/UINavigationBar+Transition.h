//
//  UINavigationBar+Transition.h
//  Test
//
//  Created by lxb on 2018/5/11.
//  Copyright © 2018年 lxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (Transition)

@property (nonatomic, strong) UIImageView *jm_shadowImgView;

- (void)addShadowViewWithAlpha:(CGFloat)alpha;


@end
