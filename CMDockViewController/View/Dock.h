//
//  Dock.h
//  Cloud Mario Dock View Controller
//
//  Created by apple on 13-9-11.
//  Copyright (c) 2013年 Bruce ( Cloud Mario ). All rights reserved.
//  左边的目录

#import <UIKit/UIKit.h>
@class DockItem;
@class AvatarView;
@class MenuView;

@interface Dock : UIView

@property (nonatomic,strong) AvatarView *iconView;
@property (nonatomic,strong) MenuView *menuView;

// 旋转到某一个方向
- (void)rotateToOrientation:(UIInterfaceOrientation)orientation;

@property (nonatomic, copy) void (^dockItemClickBlock)(DockItem *item);

@end