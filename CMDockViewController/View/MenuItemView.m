//
//  MenuItemView.m
//  Cloud Mario Dock View Controller
//
//  Created by apple on 13-9-11.
//  Copyright (c) 2013年 Bruce ( Cloud Mario ). All rights reserved.
//

#import "MenuItemView.h"
#import "DockItem.h"

#import "MKNumberBadgeView.h"
#import <objc/runtime.h>

static char const * const badgeKey = "badge";

@interface MenuItemView()
{
    UIImageView *_divider;
}

-(MKNumberBadgeView *)badgeView;
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
        _divider.image = [UIImage resizeImage:@"CMDockViewController.bundle/image/tabbar/tabbar_separate_line.png"];
        _divider.frame = CGRectMake(0, kDockMenuItemHeight, 0, 2);
        _divider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_divider];
        
        // 3.设置被选中的背景
        [self setBackgroundImage:[UIImage resizeImage:@"CMDockViewController.bundle/image/tabbar/tabbar_separate_selected_bg.png"] forState:UIControlStateSelected];
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
    
    self.badge = dockItem.badge;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, kDockMenuItemHeight, kDockMenuItemHeight);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
//    self.badge = self.badge;
    
    CGFloat width = contentRect.size.width - kDockMenuItemHeight;
    return CGRectMake(kDockMenuItemHeight, 0, width, kDockMenuItemHeight);
}

-(void)setBadge:(NSString *)newBadge
{
    MKNumberBadgeView *badgeView = [self badgeView];
    badgeView.value = newBadge;
    
    badgeView.hidden = (newBadge == nil);
    
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
    
        badgeView.frame = CGRectMake(self.frame.size.width - 20,
                                     10,
                                     badgeView.badgeSize.width+10,
                                     self.frame.size.height);
        badgeView.showDot = YES;
    
    }else{
        
        badgeView.showDot = NO;
        badgeView.frame = CGRectMake((self.frame.size.width-badgeView.badgeSize.width) - 20,
                                     0,
                                     badgeView.badgeSize.width+10,
                                     self.frame.size.height);

    }
}

-(NSString *)badge
{
    MKNumberBadgeView *badgeView = [self badgeView];
    return badgeView.value;
}

-(MKNumberBadgeView *)badgeView;
{
    MKNumberBadgeView *badgeView = (MKNumberBadgeView *)objc_getAssociatedObject(self, badgeKey);
    badgeView.userInteractionEnabled = NO;
    if(!badgeView){
        badgeView = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self addSubview:badgeView];
        badgeView.hidden = YES;
        objc_setAssociatedObject(self, badgeKey, badgeView, OBJC_ASSOCIATION_RETAIN);
    }
    return badgeView;
}

// 旋转到某一个方向
- (void)rotateToOrientation:(UIInterfaceOrientation)orientation
{
    MKNumberBadgeView *badgeView = [self badgeView];
    
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        
        badgeView.frame = CGRectMake(self.frame.size.width - 20,
                                     10,
                                     badgeView.badgeSize.width+10,
                                     self.frame.size.height);
        badgeView.showDot = YES;
        
    }else{
        
        badgeView.showDot = NO;
        badgeView.frame = CGRectMake((self.frame.size.width-badgeView.badgeSize.width) - 20,
                                     0,
                                     badgeView.badgeSize.width+10,
                                     self.frame.size.height);
        
    }

    [badgeView setNeedsDisplay];
}





@end