//
//  Dock.h
//  QQ空间-HD
//
//  Created by apple on 13-9-11.
//  Copyright (c) 2013年 itcast. All rights reserved.
//  左边的目录

#import <UIKit/UIKit.h>
@class DockItem;
@interface Dock : UIView

// 旋转到某一个方向
- (void)rotateToOrientation:(UIInterfaceOrientation)orientation;


@property (nonatomic, copy) void (^dockItemClickBlock)(DockItem *item);
@end