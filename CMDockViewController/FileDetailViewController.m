//
//  FileDetailViewController.m
//  CMDockViewController
//
//  Created by hanchao on 13-10-8.
//  Copyright (c) 2013年 Bruce. All rights reserved.
//

#import "FileDetailViewController.h"

#import "AppDelegate.h"

// 获取Dock的高度
#define kScreenHeight(orientation) ((UIInterfaceOrientationIsLandscape(orientation)?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height))

#define kScreenWidth(orientation) ((UIInterfaceOrientationIsLandscape(orientation)?[UIScreen mainScreen].bounds.size.height:[UIScreen mainScreen].bounds.size.width))


@interface FileDetailViewController ()

@property (nonatomic,retain) CALayer *cover;

@end

@implementation FileDetailViewController

-(id)initWithParent:(UIViewController *)parent
{
    if (self = [super init]) {
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        
        self.parentVC = appDelegate.window.rootViewController;
        self.nav = [[UINavigationController alloc] initWithRootViewController:self];
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor greenColor];
//    self.view.backgroundColor = kGetColor(220, 220, 220);
    
    // 不要自动伸缩
    self.nav.view.autoresizingMask = UIViewAutoresizingNone;
    
    // 添加手势监听器
    [self.nav.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(dragNavView:)]];
    
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"关闭"
                                                                                    style:UIBarButtonItemStyleDone
                                                                                   target:self action:@selector(closeAction)]];
    
    
    [self.parentVC addChildViewController:self.nav];
    
    CGFloat width = 320;
    CGFloat height = kScreenHeight([UIApplication sharedApplication].statusBarOrientation) - 20.0;
    
    CGFloat x = ((UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)?
                  self.parentVC.view.frame.size.height:
                  self.parentVC.view.frame.size.width));
    
    self.nav.view.frame = CGRectMake(x,
                                     0,
                                     width,
                                     height);
#ifdef __IPHONE_7_0
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        
        self.nav.view.frame = CGRectMake(x,
                                         22.0,
                                         width,
                                         height - 10.0);
    }
#endif
    
}

#pragma mark 即将旋转屏幕的时候自动调用
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    self.cover.frame = CGRectMake(0,0,
                                  kScreenWidth(toInterfaceOrientation),
                                  kScreenHeight(toInterfaceOrientation));
    
    [UIView animateWithDuration:duration animations:^{
        CGFloat width = 320;
        CGFloat height = kScreenHeight(toInterfaceOrientation) - 20.0;
        
        CGFloat x = ((UIInterfaceOrientationIsLandscape(toInterfaceOrientation)?
                      self.parentVC.view.frame.size.height:
                      self.parentVC.view.frame.size.width));
        
        self.nav.view.frame = CGRectMake(x - width,
                                         0,
                                         width,
                                         height);
#ifdef __IPHONE_7_0
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            
            self.nav.view.frame = CGRectMake(x - width,
                                             22.0,
                                             width,
                                             height - 10.0);
        }
#endif
        
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         CGRect frame = self.nav.view.frame;
                         frame.origin.x -= frame.size.width;
                         
                         self.nav.view.frame = frame;
                         
                         self.cover.backgroundColor = [UIColor colorWithRed:0
                                                                      green:0
                                                                       blue:0
                                                                      alpha:0.5].CGColor;
                         
                     } completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)show
{
    self.cover = [CALayer layer];
    self.cover.frame = CGRectMake(0,0,
                                  kScreenWidth([UIApplication sharedApplication].statusBarOrientation),
                                  kScreenHeight([UIApplication sharedApplication].statusBarOrientation));
    self.cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor;
    
    [self.parentVC.view.layer addSublayer:self.cover];
    
    [self.parentVC.view addSubview:self.nav.view];
    
}

-(void)dismiss
{
    [self closeAction];
}

#pragma mark 监听拖拽手势
- (void)dragNavView:(UIPanGestureRecognizer *)pan {
    
    CGFloat tx = [pan translationInView:pan.view].x;
    
    NSLog(@"=======%f",tx);
    
    
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
}

-(void)closeAction
{
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         CGRect frame = self.nav.view.frame;
                         frame.origin.x += frame.size.width;
                         
                         self.nav.view.frame = frame;
                         
                         self.cover.backgroundColor = [UIColor colorWithRed:0
                                                                      green:0
                                                                       blue:0
                                                                      alpha:0].CGColor;
                         
                     } completion:^(BOOL finished) {
                         [self.nav.view removeFromSuperview];
                         [self.cover removeFromSuperlayer];
                     }];
    
}


//-(void)dealloc
//{
//    self.parentVC = nil;
//    
//    
//    [super dealloc];
//}

@end
