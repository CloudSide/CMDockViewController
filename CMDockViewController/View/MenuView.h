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
- (void)rotateToOrientation:(UIInterfaceOrientation)orientation iconFrame:(CGRect)composeFrame;

@property (nonatomic, copy) void (^menuItemClickBlock)(DockItem *item);

@property (nonatomic,strong) NSArray *dockItems;

@property (nonatomic,strong) NSMutableArray *menuItemViews;

// 取消选中全部
- (void)unselectAll;
@end
