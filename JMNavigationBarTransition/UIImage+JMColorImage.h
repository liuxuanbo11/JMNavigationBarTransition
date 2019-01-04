//
//  UIImage+JMColorImage.h
//  JMNavigationTransition
//
//  Created by lxb on 2018/5/23.
//  Copyright © 2018年 lxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JMColorImage)

//生成纯色图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

// 修改图片透明度
- (UIImage *)imageByAppendAlpha:(CGFloat)alpha;

@end
