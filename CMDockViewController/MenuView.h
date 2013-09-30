//
//  MenuView.h
//  Cloud Mario Dock View Controller
//
//  Created by apple on 13-9-11.
//  Copyright (c) 2013年 Bruce ( Cloud Mario ). All rights reserved.
//

#import <UIKit/UIKit.h>

@class DockItem;

@interface MenuView : UIView
// 旋转到某一个方向
- (void)rotateToOrientation:(UIInterfaceOrientation)orientation composeFrame:(CGRect)composeFrame;

@property (nonatomic, copy) void (^menuItemClickBlock)(DockItem *item);

// 取消选中全部
- (void)unselectAll;
@end
