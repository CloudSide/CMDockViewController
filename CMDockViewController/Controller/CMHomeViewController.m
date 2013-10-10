//
//  HomeViewController.m
//  Cloud Mario Dock View Controller
//
//  Created by apple on 13-9-11.
//  Copyright (c) 2013年 Bruce ( Cloud Mario ). All rights reserved.
//

#import "CMHomeViewController.h"
#import "Dock.h"
#import "DockItem.h"

#import <QuartzCore/QuartzCore.h>

@interface CMHomeViewController () {
    
    Dock *_dock;
    
    // 存放所有要显示的子控制器
    NSMutableDictionary *_allChilds;
    
    // 当前正在显示的子控制器
    UINavigationController *_currentChild;
    
}

@property (nonatomic,strong) UIViewController *slideDetailViewController;//右侧浮层viewController
@property (nonatomic,strong) UINavigationController *slideDetailViewNav;
@property (nonatomic,strong) UIView *slideCoverView;

@end

@implementation CMHomeViewController

static CMHomeViewController *kSharedInstanceCMHomeViewController = nil;

+ (id)sharedInstance {
    
    if (kSharedInstanceCMHomeViewController == nil) {
        
        kSharedInstanceCMHomeViewController = [[CMHomeViewController alloc] init];
    }
    
    return kSharedInstanceCMHomeViewController;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _allChilds = [NSMutableDictionary dictionary];
    __unsafe_unretained CMHomeViewController *home = self;
    
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
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"CMDockViewController.bundle/image/bg/back"]];
    
    // 3.监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:@"logout" object:nil];
    
    // 4.默认选中全部状态
    [home selectChildWithItem:[DockItem itemWithIcon:nil className:@"UIViewController"]];
    
}


 - (UIStatusBarStyle)preferredStatusBarStyle {
 
     return UIStatusBarStyleLightContent;
}
 

- (void)logout {
    
    //TODO: 退出登录通知
    [self dismissViewControllerAnimated:YES completion:nil];
}

#define kScreenHeight(orientation) ((UIInterfaceOrientationIsLandscape(orientation)?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height))
#define kScreenWidth(orientation) ((UIInterfaceOrientationIsLandscape(orientation)?[UIScreen mainScreen].bounds.size.height:[UIScreen mainScreen].bounds.size.width))

#pragma mark 即将旋转屏幕的时候自动调用

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    self.slideCoverView.frame = CGRectMake(0,0,
                                          kScreenWidth(toInterfaceOrientation),
                                          kScreenHeight(toInterfaceOrientation));
    
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
        
        _currentChild.view.frame = CGRectMake(_dock.frame.size.width, 0 + 8, width, _dock.frame.size.height - 18.0);
#ifdef __IPHONE_7_0
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            
            _currentChild.view.frame = CGRectMake(_dock.frame.size.width, 22 + 8, width, _dock.frame.size.height - 18.0);
        }
#endif
        
        width = 320;
        CGFloat height = kScreenHeight(toInterfaceOrientation)-12;
        
        CGFloat x = ((UIInterfaceOrientationIsLandscape(toInterfaceOrientation)?
                      self.view.frame.size.height+20:
                      self.view.frame.size.width+20));
        
#ifdef __IPHONE_7_0
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            x = ((UIInterfaceOrientationIsLandscape(toInterfaceOrientation)?
                          self.view.frame.size.height:
                          self.view.frame.size.width));
        }
#endif
        
        
        
        self.slideDetailViewNav.view.frame = CGRectMake(x - width,
                                         0,
                                         width,
                                         height);
#ifdef __IPHONE_7_0
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            
            self.slideDetailViewNav.view.frame = CGRectMake(x - width,
                                             22.0,
                                             width,
                                             height - 10.0);
        }
#endif
        
        
    }];
}

#pragma mark 切换控制器
- (void)selectChildWithItem:(DockItem *)item {
    
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
        
        
#ifdef __IPHONE_7_0
        
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        
            vc.view.layer.cornerRadius = 3.0f;
            
            //阴影
            nav.view.layer.shadowColor = [UIColor blackColor].CGColor;
            nav.view.layer.shadowOpacity = 0.2;
            UIBezierPath *path = [UIBezierPath bezierPath];
            CGPoint topLeft      = CGPointMake(-8.0, 4.0);
            CGPoint bottomLeft   = CGPointMake(-8.0, CGRectGetHeight(nav.view.bounds));
            CGPoint bottomRight  = CGPointMake(CGRectGetWidth(nav.view.bounds)-20, CGRectGetHeight(nav.view.bounds)+4);
            CGPoint topRight     = CGPointMake(CGRectGetWidth(nav.view.bounds)-20, 0);
            [path moveToPoint:topLeft];
            [path addLineToPoint:bottomLeft];
            [path addLineToPoint:bottomRight];
            [path addLineToPoint:topRight];
            [path addLineToPoint:topLeft];
            [path closePath];
            nav.view.layer.shadowPath = path.CGPath;
            
            [nav.navigationBar setBackgroundImage:[[UIImage imageNamed: @"navbar_background"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0]
                                    forBarMetrics:UIBarMetricsDefault];
            
            
            //使nav顶部圆角
            CALayer *capa = nav.navigationBar.layer;
            //capa.backgroundColor = [UIColor redColor].CGColor;
            //[capa setShadowColor: [[UIColor blackColor] CGColor]];
            //[capa setShadowOpacity:0.85f];
            //[capa setShadowOffset: CGSizeMake(0.0f, 1.5f)];
            //[capa setShadowRadius:2.0f];
            //[capa setShouldRasterize:YES];
            
            //Round
            CGRect bounds = capa.bounds;
            bounds.size.height += 10.0f;    //I'm reserving enough room for the shadow
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                           byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                                 cornerRadii:CGSizeMake(3.0, 3.0)];
            
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.backgroundColor = [UIColor redColor].CGColor;
            maskLayer.frame = bounds;
            maskLayer.path = maskPath.CGPath;
            [capa addSublayer:maskLayer];
            capa.mask = maskLayer;
            
        } else
#endif
        {
            
            //TODO:iOS6 用图片背景实现
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
    
    nav.view.frame = CGRectMake(_dock.frame.size.width, 0 + 8, width, _dock.frame.size.height - 18.0);
#ifdef __IPHONE_7_0
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        
        nav.view.frame = CGRectMake(_dock.frame.size.width, 22.0 + 8, width, _dock.frame.size.height - 18.0);
    }
#endif
    [self.view addSubview:nav.view];
    
    _currentChild = nav;
}

#pragma mark 监听拖拽手势
- (void)dragNavView:(UIPanGestureRecognizer *)pan {
    
    if (pan.view == self.slideDetailViewNav.view) {
        
        CGFloat tx = [pan translationInView:pan.view].x;
        
        if (tx < 0) tx = 0;
        
        if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {// 手势结束
            
            if (tx > 100) {
                [self closeAction];
            }else{
                [UIView animateWithDuration:0.2 animations:^{
                    pan.view.transform = CGAffineTransformIdentity;
                }];
            }
        } else {
            
            pan.view.transform = CGAffineTransformMakeTranslation(tx * 0.5, 0);
        }
    }else{
    
        if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {// 手势结束
            [UIView animateWithDuration:0.2 animations:^{
                pan.view.transform = CGAffineTransformIdentity;
            }];
        } else {
            CGFloat tx = [pan translationInView:pan.view].x;
            pan.view.transform = CGAffineTransformMakeTranslation(tx * 0.5, 0);
        }
    }
}

- (void)dealloc {
    
    // 移除通知的监听器
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"logout" object:nil];
}

#pragma mark - fileDetailView

/*
#define kScreenHeight(orientation) ((UIInterfaceOrientationIsLandscape(orientation)?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height))
#define kScreenWidth(orientation) ((UIInterfaceOrientationIsLandscape(orientation)?[UIScreen mainScreen].bounds.size.height:[UIScreen mainScreen].bounds.size.width))
 */

-(void)showDetailView:(UIViewController *)vc
{
    if (self.slideDetailViewController) {
        [self.slideDetailViewController removeFromParentViewController];
        [self.slideDetailViewNav.view removeFromSuperview];
        [self.slideCoverView removeFromSuperview];
        
        self.slideDetailViewNav = nil;
        self.slideDetailViewController = nil;
        self.slideCoverView = nil;
    }
    
    self.slideDetailViewController = vc;
    
    self.slideCoverView = [[UIView alloc] init];
    self.slideCoverView.frame = CGRectMake(0,0,
                                  kScreenWidth([UIApplication sharedApplication].statusBarOrientation),
                                  kScreenHeight([UIApplication sharedApplication].statusBarOrientation));
    self.slideCoverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    self.slideDetailViewNav = [[UINavigationController alloc] initWithRootViewController:self.slideDetailViewController];
    
    // 不要自动伸缩
    self.slideDetailViewNav.view.autoresizingMask = UIViewAutoresizingNone;
    
    
    
#ifdef __IPHONE_7_0
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
    
        self.slideDetailViewController.view.layer.cornerRadius = 3.0f;
        
        [self.slideDetailViewNav.navigationBar setBackgroundImage:[[UIImage imageNamed: @"navbar_background"]
                                                                   stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0]
                                forBarMetrics:UIBarMetricsDefault];
        
        //使nav顶部圆角
        CALayer *capa = self.slideDetailViewNav.navigationBar.layer;
        
        //Round
        CGRect bounds = capa.bounds;
        bounds.size.height += 10.0f;    //I'm reserving enough room for the shadow
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                       byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                             cornerRadii:CGSizeMake(3.0, 3.0)];
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = bounds;
        maskLayer.path = maskPath.CGPath;
        [capa addSublayer:maskLayer];
        capa.mask = maskLayer;
        
    } else
#endif
    {
    
        //TODO:iOS6 用图片背景实现
    }

    // 添加手势监听器
    [self.slideDetailViewNav.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                           action:@selector(dragNavView:)]];
    
    
    [self.slideDetailViewController.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"关闭"
                                                                                style:UIBarButtonItemStyleDone
                                                                               target:self action:@selector(closeAction)]];
    
    [self addChildViewController:self.slideDetailViewNav];
    
    CGFloat width = 320;
    CGFloat height = kScreenHeight([UIApplication sharedApplication].statusBarOrientation)-12;
    
    CGFloat x = ((UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)?
                  self.view.frame.size.height:
                  self.view.frame.size.width));
    
    self.slideDetailViewNav.view.frame = CGRectMake(x,
                                     0,
                                     width,
                                     height);
#ifdef __IPHONE_7_0
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        
        self.slideDetailViewNav.view.frame = CGRectMake(x,
                                         22.0,
                                         width,
                                         height - 10.0);
    }
#endif
    
    
    [self.view addSubview:self.slideCoverView];
    
    [self.view addSubview:self.slideDetailViewNav.view];
    
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         CGRect frame = self.slideDetailViewNav.view.frame;
                         frame.origin.x -= frame.size.width;
                         
                         self.slideDetailViewNav.view.frame = frame;
                         
                         self.slideCoverView.backgroundColor = [UIColor colorWithRed:0
                                                                              green:0
                                                                               blue:0
                                                                              alpha:0.5];
                         
                     } completion:nil];
    
    
}

-(void)dismissDetailView
{
    [self closeAction];
}


-(void)closeAction
{
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         CGRect frame = self.slideDetailViewNav.view.frame;
                         frame.origin.x += frame.size.width;
                         
                         self.slideDetailViewNav.view.frame = frame;
                         
                         self.slideCoverView.backgroundColor = [UIColor colorWithRed:0
                                                                              green:0
                                                                               blue:0
                                                                              alpha:0];
                         
                     } completion:^(BOOL finished) {
                         [self.slideDetailViewController removeFromParentViewController];
                         [self.slideDetailViewNav.view removeFromSuperview];
                         [self.slideDetailViewNav removeFromParentViewController];
                         [self.slideCoverView removeFromSuperview];
                         
                         self.slideDetailViewNav = nil;
                         self.slideDetailViewController = nil;
                         self.slideCoverView = nil;
                     }];
    
}


@end