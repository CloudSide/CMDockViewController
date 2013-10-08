//
//  FileDetailViewController.h
//  CMDockViewController
//
//  Created by hanchao on 13-10-8.
//  Copyright (c) 2013年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileDetailViewController : UIViewController

@property (nonatomic,retain) UIViewController *parentVC;
@property (nonatomic,retain) UINavigationController *nav;

-(id)initWithParent:(UIViewController *)parent;

-(void)show;
-(void)dismiss;

@end
