//
//  Config.h
//  CMDockViewController
//
//  Created by Bruce on 13-9-30.
//  Copyright (c) 2013年 Bruce. All rights reserved.
//

#ifndef CMDockViewController_Config_h
#define CMDockViewController_Config_h

// 获得颜色
#define kGetColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define kGlobalBg kGetColor(46, 46, 46)

// 获取Dock的高度
#define kDockHeight(orientation) ((UIInterfaceOrientationIsLandscape(orientation)?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height) - 20)

/*
 Compose里面item的宽高
 */
// 横屏的宽度
#define kDockComposeItemWidthL 90
// 横屏的高度
#define kDockComposeItemHeightL kDockComposeItemWidthL

// 竖屏的宽度
#define kDockComposeItemWidthP 60
// 竖屏的高度
#define kDockComposeItemHeightP kDockComposeItemWidthP

/*
 Menu里面Item的宽高
 */
#define kDockMenuItemHeight kDockComposeItemHeightP

#import "UIImage+Fit.h"


#endif
