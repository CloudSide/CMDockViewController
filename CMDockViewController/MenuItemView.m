//
//  MenuItemView.m
//  QQ空间-HD
//
//  Created by apple on 13-9-11.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MenuItemView.h"
#import "DockItem.h"

@interface MenuItemView()
{
    UIImageView *_divider;
}
@end

@implementation MenuItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.设置内容模式
        self.imageView.contentMode = UIViewContentModeCenter;
        self.adjustsImageWhenHighlighted = NO;
        
        // 2.添加分隔线
        _divider = [[UIImageView alloc] init];
        _divider.image = [UIImage resizeImage:@"tabbar_separate_line.png"];
        _divider.frame = CGRectMake(0, kDockMenuItemHeight, 0, 2);
        _divider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_divider];
        
        // 3.设置被选中的背景
        [self setBackgroundImage:[UIImage resizeImage:@"tabbar_separate_selected_bg.png"] forState:UIControlStateSelected];
    }
    return self;
}

#pragma mark 覆盖高亮时所做的行为
- (void)setHighlighted:(BOOL)highlighted {}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    _divider.hidden = selected;
}

- (void)setDockItem:(DockItem *)dockItem
{
    _dockItem = dockItem;
    
    // 1.设置图片
    [self setImage:[UIImage imageNamed:dockItem.icon] forState:UIControlStateNormal];
    
    // 2.设置文字
    [self setTitle:dockItem.title forState:UIControlStateNormal];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, kDockMenuItemHeight, kDockMenuItemHeight);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat width = contentRect.size.width - kDockMenuItemHeight;
    return CGRectMake(kDockMenuItemHeight, 0, width, kDockMenuItemHeight);
}
@end