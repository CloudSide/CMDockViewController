//
//  AvatarView.m
//  Cloud Mario Dock View Controller
//
//  Created by apple on 13-9-11.
//  Copyright (c) 2013年 Bruce ( Cloud Mario ). All rights reserved.
//

#import "AvatarView.h"
#import <QuartzCore/QuartzCore.h>

#define kIconMaxWidth 50
#define kIconMaxHeight 50


@implementation AvatarView

-(void)awakeFromNib
{
    self.imageView.layer.cornerRadius = 5;
    self.imageView.layer.masksToBounds = YES;
}

- (void)rotateToOrientation:(UIInterfaceOrientation)orientation
{
    // 1.设置整个头像的frame
    CGFloat width = self.superview.frame.size.width;
    self.frame = CGRectMake(0, 0, width, 80);
    
    // 2.根据方向隐藏文字
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        self.userNameLabel.hidden = YES;
        self.usageAmountLabel.hidden = YES;
        
        CGRect frame = self.imageView.frame;
        frame.origin.x = 5;
        self.imageView.frame = frame;
        
    }else{
        self.userNameLabel.hidden = NO;
        self.usageAmountLabel.hidden = NO;
        
        CGRect frame = self.imageView.frame;
        frame.origin.x = 8;
        self.imageView.frame = frame;
    }
    
}

//- (CGRect)imageRectForContentRect:(CGRect)contentRect
//{
//    
//    CGFloat iconWidth = contentRect.size.width;
//    if (iconWidth > kIconMaxWidth) {
//        CGFloat imgX = (iconWidth - kIconMaxWidth) * 0.5;
//        CGFloat imgY = 40;
//        return CGRectMake(imgX, imgY, kIconMaxWidth, kIconMaxHeight);
//    } else {
//        CGFloat imgX = 10;
//        CGFloat imgY = 10;
//        CGFloat imgWidth = iconWidth - 2 * imgX;
//        return CGRectMake(imgX, imgY, imgWidth, imgWidth);
//    }
//}
//
//- (CGRect)titleRectForContentRect:(CGRect)contentRect
//{
//    CGFloat titleX = 0;
//    CGFloat titleY = 150;
//    CGFloat titleWidth = contentRect.size.width;
//    CGFloat titleHeight = 50;
//    return CGRectMake(titleX, titleY, titleWidth, titleHeight);
//}

@end
