//
//  ComposeView.m
//  QQ空间-HD
//
//  Created by apple on 13-9-11.
//  Copyright (c) 2013年 itcast. All rights reserved.
//



#import "ComposeView.h"
#import "DockItem.h"

@interface ComposeView()
{
    NSArray *_dockItems;
    
    // 所有的按钮
    NSMutableArray *_btns;
    // 所有的分隔线
    NSMutableArray *_dividers;
}
@end

@implementation ComposeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.添加所有的DockItem
        [self addDockItems];
        
        // 2.添加所有的按钮
        [self addBtns];
    }
    return self;
}

#pragma mark 添加所有的DockItem
- (void)addDockItems
{
    _dockItems = @[
       [DockItem itemWithIcon:@"tabbar_mood.png" className:nil modal:YES],
       [DockItem itemWithIcon:@"tabbar_photo.png" className:nil modal:YES],
       [DockItem itemWithIcon:@"tabbar_blog.png" className:nil modal:YES]
                   ];
}

#pragma mark 添加所有的按钮
- (void)addBtns
{
    _btns = [NSMutableArray array];
    _dividers = [NSMutableArray array];
    
    int count = _dockItems.count;
    for (int i = 0; i<count; i++) {
        DockItem *item = _dockItems[i];
        
        // 1.添加按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        // 设置图片
        [btn setImage:[UIImage imageNamed:item.icon] forState:UIControlStateNormal];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(composeItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btns addObject:btn];
        
        // 2.添加分隔线
        if (i != 0) {
            UIImageView *divider = [[UIImageView alloc] init];
            divider.image = [UIImage imageNamed:@"tabbar_separate_ugc_line_v.png"];
            [self addSubview:divider];
            [_dividers addObject:divider];
        }
    }
}

- (void)composeItemClick:(UIButton *)btn
{
    if (_composeItemClickBlock) {
        _composeItemClickBlock(_dockItems[btn.tag]);
    }
}

#pragma mark 旋转到某一个方向
- (void)rotateToOrientation:(UIInterfaceOrientation)orientation
{
    CGFloat x = 0;
    CGFloat width = 0;
    CGFloat height = 0;
    
    if (UIInterfaceOrientationIsLandscape(orientation)) { // 横屏
        // 1.设置按钮的frame
        int btnCount = _btns.count;
        for (int i = 0; i<btnCount; i++) {
            UIButton *btn = _btns[i];
            btn.frame = CGRectMake(i * kDockComposeItemWidthL, 0, kDockComposeItemWidthL, kDockComposeItemHeightL);
        }
        width = btnCount * kDockComposeItemWidthL;
        height = kDockComposeItemHeightL;
        
        // 2.分隔线的frame
        int dividerCount = _dividers.count;
        for (int i = 0; i<dividerCount; i++) {
            UIImageView *divider = _dividers[i];
            divider.hidden = NO;
            divider.frame = CGRectMake((i + 1) * kDockComposeItemWidthL, 0, 2, kDockComposeItemHeightL);
        }
    } else { // 竖屏
        // 1.设置按钮的frame
        int btnCount = _btns.count;
        for (int i = 0; i<btnCount; i++) {
            UIButton *btn = _btns[i];
            btn.frame = CGRectMake(0, i * kDockComposeItemHeightP, kDockComposeItemWidthP, kDockComposeItemHeightP);
        }
        width = kDockComposeItemWidthP;
        height = btnCount * kDockComposeItemHeightP;
        
        // 2.分隔线的frame
        int dividerCount = _dividers.count;
        for (int i = 0; i<dividerCount; i++) {
            UIImageView *divider = _dividers[i];
            divider.hidden = YES;
        }
    }
    
    CGFloat y = kDockHeight(orientation) - height;
    self.frame = CGRectMake(x, y, width, height);
}
@end
