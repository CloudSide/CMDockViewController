//
//  AvatarView.h
//  Cloud Mario Dock View Controller
//
//  Created by apple on 13-9-11.
//  Copyright (c) 2013年 Bruce ( Cloud Mario ). All rights reserved.
//  头像

#import <UIKit/UIKit.h>

@interface AvatarView : UIView

@property (nonatomic,retain) IBOutlet UIImageView *imageView;
@property (nonatomic,retain) IBOutlet UILabel *userNameLabel;
@property (nonatomic,retain) IBOutlet UILabel *usageAmountLabel;//用量


// 旋转到某一个方向
- (void)rotateToOrientation:(UIInterfaceOrientation)orientation;

@end
