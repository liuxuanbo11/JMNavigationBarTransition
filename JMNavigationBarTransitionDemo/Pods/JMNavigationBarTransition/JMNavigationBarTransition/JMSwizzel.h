//
//  JMSwizzel.h
//  Test
//
//  Created by liuxuanbo on 2018/5/9.
//  Copyright © 2018年 lxb. All rights reserved.
//

#import <Foundation/Foundation.h>

extern void JMSwizzleMethod(Class originalCls, SEL originalSelector, Class swizzledCls, SEL swizzledSelector);

