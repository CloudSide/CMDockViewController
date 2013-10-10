//
//  MenuView.m
//  Cloud Mario Dock View Controller
//
//  Created by apple on 13-9-11.
//  Copyright (c) 2013年 Bruce ( Cloud Mario ). All rights reserved.
//

#import "MenuView.h"
#import "MenuItemView.h"
#import "DockItem.h"

@interface MenuView()
{
    NSArray *_dockItems;
    
    MenuItemView *_currentItemView;
}
@end

@implementation MenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.先添加DockItem
        [self addDockItems];
        
        // 2.添加按钮
        [self addMenuItemViews];
        
        // 3.添加顶部的分隔线
        UIImageView *divider = [[UIImageView alloc] init];
        divider.image = [UIImage resizeImage:@"CMDockViewController.bundle/image/tabbar/tabbar_separate_line.png"];
        divider.frame = CGRectMake(0, 0, frame.size.width, 2);
        divider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:divider];
    }
    return self;
}

#pragma mark 先添加DockItem
- (void)addDockItems
{
    _dockItems = @[
                   [DockItem itemWithIcon:@"CMDockViewController.bundle/image/tabbar/tab_bar_feed_icon.png" title:@"我的微盘" badge:@"New" className:@"TestTableViewController"],
                   [DockItem itemWithIcon:@"CMDockViewController.bundle/image/tabbar/tab_bar_passive_feed_icon.png" title:@"已下载" badge:@"asdd" className:@"UIViewController"],
                   [DockItem itemWithIcon:@"CMDockViewController.bundle/image/tabbar/tab_bar_pic_wall_icon.png" title:@"好友分享" badge:nil className:@"UIViewController"],
                   [DockItem itemWithIcon:@"CMDockViewController.bundle/image/tabbar/tab_bar_friend_icon.png" title:@"找资源" badge:nil className:@"UIViewController"],
                   [DockItem itemWithIcon:@"CMDockViewController.bundle/image/tabbar/tab_bar_app_icon.png" title:@"更多" badge:@"水电费的是否" className:@"UIViewController"],
                   ];
}

#pragma mark 添加按钮
- (void)addMenuItemViews
{
    int count = _dockItems.count;
    for (int i = 0; i<count; i++) {
        MenuItemView *btn = [[MenuItemView alloc] init];
        btn.frame = CGRectMake(0, i * kDockMenuItemHeight, self.frame.size.width, kDockMenuItemHeight);
        btn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        btn.dockItem = _dockItems[i];
        [btn addTarget:self action:@selector(menuItemClick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:btn];
    }
}

- (void)menuItemClick:(MenuItemView *)itemView
{
    if(![itemView.dockItem.title isEqualToString:@"设置"]) {
        _currentItemView.selected = NO;
        itemView.selected = YES;
        _currentItemView = itemView;
    }
    
    // 将事件传递给block
    if (_menuItemClickBlock) {
        _menuItemClickBlock(itemView.dockItem);
    }
}

- (void)rotateToOrientation:(UIInterfaceOrientation)orientation iconFrame:(CGRect)iconFrame
{
    // 设置MenuView的frame
    CGFloat width = iconFrame.size.width;
    CGFloat height = _dockItems.count * kDockMenuItemHeight;
    CGFloat y = iconFrame.origin.y + iconFrame.size.height;//composeFrame.origin.y - height;
    self.frame = CGRectMake(0, y, width, height);
    
    for (UIView *view in self.subviews) {
        if ([view isMemberOfClass:[MenuItemView class]]) {
            MenuItemView *itemView = (MenuItemView *)view;
            [itemView rotateToOrientation:orientation];
        }
    }
}

- (void)unselectAll
{
    _currentItemView.selected = NO;
    _currentItemView = nil;
}
@end