//
//  MenuItemView.h
//  Cloud Mario Dock View Controller
//
//  Created by apple on 13-9-11.
//  Copyright (c) 2013年 Bruce ( Cloud Mario ). All rights reserved.
//

#import <UIKit/UIKit.h>
@class DockItem;
@interface MenuItemView : UIButton
@property (nonatomic, strong) DockItem *dockItem;

@property (nonatomic,assign) NSString *badge;


// 旋转到某一个方向
- (void)rotateToOrientation:(UIInterfaceOrientation)orientation;
@end
