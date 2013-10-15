

//
//  HomeViewController.h
//  Cloud Mario Dock View Controller
//
//  Created by apple on 13-9-11.
//  Copyright (c) 2013年 Bruce ( Cloud Mario ). All rights reserved.
//  主页

#import <UIKit/UIKit.h>

@class Dock;
@class DockItem;

@interface CMHomeViewController : UIViewController

@property (nonatomic,strong) Dock *dock;

// 当前正在显示的子控制器
@property (nonatomic,strong,readonly) UINavigationController *currentChild;

+ (id)sharedInstance;

- (void)showDetailView:(UIViewController *)vc;
- (void)dismissDetailView;

- (void)selectChildWithItem:(DockItem *)item;


@end
