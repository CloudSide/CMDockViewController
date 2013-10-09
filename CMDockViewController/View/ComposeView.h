//
//  ComposeView.h
//  Cloud Mario Dock View Controller
//
//  Created by apple on 13-9-11.
//  Copyright (c) 2013年 Bruce ( Cloud Mario ). All rights reserved.
//

#import <UIKit/UIKit.h>
@class DockItem;
@interface ComposeView : UIView
// 旋转到某一个方向
- (void)rotateToOrientation:(UIInterfaceOrientation)orientation;

@property (nonatomic, copy) void (^composeItemClickBlock)(DockItem *item);
@end
