//
//  HomeViewController.m
//  QQ空间-HD
//
//  Created by apple on 13-9-11.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "HomeViewController.h"
#import "Dock.h"
#import "DockItem.h"

@interface HomeViewController ()
{
    Dock *_dock;
    
    // 存放所有要显示的子控制器
    NSMutableDictionary *_allChilds;
    
    // 当前正在显示的子控制器
    UINavigationController *_currentChild;
}
@end

@implementation HomeViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _allChilds = [NSMutableDictionary dictionary];
    __unsafe_unretained HomeViewController *home = self;
    
    // 1.添加dock
    _dock = [[Dock alloc] init];
    _dock.dockItemClickBlock = ^(DockItem *item) {
        // 根据切换控制器
        [home selectChildWithItem:item];
    };
    [_dock rotateToOrientation:self.interfaceOrientation];
    [self.view addSubview:_dock];
    
    // 2.设置背景
    //self.view.backgroundColor = kGlobalBg;
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"back"]];
    
    // 3.监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:@"logout" object:nil];
    
    // 4.默认选中全部状态
    [home selectChildWithItem:[DockItem itemWithIcon:nil className:@"UIViewController"]];
    
}


 - (UIStatusBarStyle)preferredStatusBarStyle {
 
     return UIStatusBarStyleLightContent;
}
 

- (void)logout
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 即将旋转屏幕的时候自动调用
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        // 根据即将要显示的方向来调整dock内部的布局
        [_dock rotateToOrientation:toInterfaceOrientation];
        
        // 调整当前选中控制器view的frame
        
        CGFloat width = 768 - kDockMenuItemHeight;
        
        if (toInterfaceOrientation == UIDeviceOrientationPortrait || toInterfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
            
            width = 768 - kDockMenuItemHeight - 8;
        
        } else {
        
            width = 768 - 22;
        }
        
        _currentChild.view.frame = CGRectMake(_dock.frame.size.width, 0, width, _dock.frame.size.height - 10.0);
#ifdef __IPHONE_7_0
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            
            _currentChild.view.frame = CGRectMake(_dock.frame.size.width, 22, width, _dock.frame.size.height - 10.0);
        }
#endif
        
    }];
}

#pragma mark 切换控制器
- (void)selectChildWithItem:(DockItem *)item
{
    // 1.从字典中取出即将要显示的子控制器
    UINavigationController *nav = _allChilds[item.className];
    if (nav == nil) {
        Class c = NSClassFromString(item.className);
        UIViewController *vc = [[c alloc] init];
        nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
        // 不要自动伸缩
        nav.view.autoresizingMask = UIViewAutoresizingNone;
        vc.view.backgroundColor = kGetColor(220, 220, 220);
        
        // 模型形式展示控制器
        if (item.modal) {
            nav.modalPresentationStyle = UIModalPresentationFormSheet;
            [self presentViewController:nav animated:YES completion:nil];
            return;
        }
        
        // 添加手势监听器
        [nav.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragNavView:)]];
        
        // 建立控制器之间的父子关系
        // 建议：两个控制器互为父子关系，那么它们的view也应该互为父子关系
        [self addChildViewController:nav];
        [_allChilds setObject:nav forKey:item.className];
    }
    
    if (_currentChild == nav) return;
    
    // 2.移除旧控制器的view
    [_currentChild.view removeFromSuperview];
    
    CGFloat width = 768 - kDockMenuItemHeight;
    
    if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortraitUpsideDown) {
        
        width = 768 - kDockMenuItemHeight - 8;
        
    } else {
        
        width = 768 - 22;
    }
    
    nav.view.frame = CGRectMake(_dock.frame.size.width, 0, width, _dock.frame.size.height - 10.0);
#ifdef __IPHONE_7_0
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        
        nav.view.frame = CGRectMake(_dock.frame.size.width, 22.0, width, _dock.frame.size.height - 10.0);
    }
#endif
    [self.view addSubview:nav.view];
    
    _currentChild = nav;
}

#pragma mark 监听拖拽手势
- (void)dragNavView:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {// 手势结束
        [UIView animateWithDuration:0.2 animations:^{
            pan.view.transform = CGAffineTransformIdentity;
        }];
    } else {
        CGFloat tx = [pan translationInView:pan.view].x;
        pan.view.transform = CGAffineTransformMakeTranslation(tx * 0.5, 0);
    }
}

- (void)dealloc
{
    // 移除通知的监听器
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"logout" object:nil];
}
@end