//
//  MenuItemView.h
//  QQ空间-HD
//
//  Created by apple on 13-9-11.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DockItem;
@interface MenuItemView : UIButton
@property (nonatomic, strong) DockItem *dockItem;
@end
