//
//  Dock.m
//  Cloud Mario Dock View Controller
//
//  Created by apple on 13-9-11.
//  Copyright (c) 2013年 Bruce ( Cloud Mario ). All rights reserved.
//

#import "Dock.h"
#import "DockItem.h"
#import "AvatarView.h"
#import "MenuView.h"
#import "ComposeView.h"

@interface Dock()
{
    AvatarView *_iconView;
    MenuView *_menuView;
    ComposeView *_composeView;
    UIImageView *_divider;
}
@end

@implementation Dock
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.头像AvatarView
        _iconView = [[AvatarView alloc] init];
        [_iconView addTarget:self action:@selector(iconClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_iconView];
        
        // 2.菜单MenuView
        _menuView = [[MenuView alloc] init];
        __unsafe_unretained Dock *dock = self;
        _menuView.menuItemClickBlock = ^(DockItem *item){
            if (dock.dockItemClickBlock) {
                dock.dockItemClickBlock(item);
            }
        };
        [self addSubview:_menuView];
        
        // 3.制作（说说、照片、文章）ComposeView
        _composeView = [[ComposeView alloc] init];
        _composeView.composeItemClickBlock = ^(DockItem *item) {
            if (dock.dockItemClickBlock) {
                dock.dockItemClickBlock(item);
            }
        };
        [self addSubview:_composeView];
        
        // 4.分隔线
        _divider = [[UIImageView alloc] init];
        _divider.image = [UIImage resizeImage:@"tabbar_separate_ugc_line_v.png"];
        [self addSubview:_divider];
    }
    return self;
}

#pragma mark 点击了头像
- (void)iconClick
{
    // 1.清除MenuView内部选中的Item
    [_menuView unselectAll];
    
    // 2.通知block
    if (_dockItemClickBlock) {
        DockItem *item = [DockItem itemWithIcon:nil className:@"UIViewController"];
        _dockItemClickBlock(item);
    }
}

#pragma mark 旋转到某个方向
- (void)rotateToOrientation:(UIInterfaceOrientation)orientation
{
    // 1.旋转compose
    [_composeView rotateToOrientation:orientation];
    
    // 2.旋转menu
    [_menuView rotateToOrientation:orientation composeFrame:_composeView.frame];
    
    // 3.设置dock的宽高
    CGFloat dockWidth = _composeView.frame.size.width;
    CGFloat dockHeight = kDockHeight(orientation);
    self.frame = CGRectMake(0, 0, dockWidth, dockHeight);
#ifdef __IPHONE_7_0
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        
        self.frame = CGRectMake(0, 22.0, dockWidth, dockHeight);
    }
#endif
    
    // 4.分隔线
    _divider.frame = CGRectMake(dockWidth, 0, 2, dockHeight);
    
    // 5.旋转icon
    [_iconView rotateToOrientation:orientation];
}
@end