//
//  JMMacros.h
//  JMNavigationBarTransition
//
//  Created by lxb on 2018/5/24.
//  Copyright © 2018年 lxb. All rights reserved.
//

#define JM_isIPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define JM_NavBarHeight (JM_isIPhoneX ? 88 : 64)


