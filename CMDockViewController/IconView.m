//
//  IconView.m
//  QQ空间-HD
//
//  Created by apple on 13-9-11.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "IconView.h"
#import <QuartzCore/QuartzCore.h>

#define kIconMaxWidth 100
#define kIconMaxHeight 100

@implementation IconView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.layer.cornerRadius = 5;
        self.imageView.layer.masksToBounds = YES;
        
        [self setImage:[UIImage imageNamed:@"default_person_lit.png"] forState:UIControlStateNormal];
        
        [self setTitle:@"哈哈" forState:UIControlStateNormal];
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)rotateToOrientation:(UIInterfaceOrientation)orientation
{
    // 1.设置整个头像的frame
    CGFloat width = self.superview.frame.size.width;
    self.frame = CGRectMake(0, 0, width, width);
    
    // 2.根据方向隐藏文字
    NSString *title = UIInterfaceOrientationIsPortrait(orientation)?nil:@"哈哈";
    [self setTitle:title forState:UIControlStateNormal];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    
    CGFloat iconWidth = contentRect.size.width;
    if (iconWidth > kIconMaxWidth) {
        CGFloat imgX = (iconWidth - kIconMaxWidth) * 0.5;
        CGFloat imgY = 40;
        return CGRectMake(imgX, imgY, kIconMaxWidth, kIconMaxHeight);
    } else {
        CGFloat imgX = 10;
        CGFloat imgY = 10;
        CGFloat imgWidth = iconWidth - 2 * imgX;
        return CGRectMake(imgX, imgY, imgWidth, imgWidth);
    }
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleY = 150;
    CGFloat titleWidth = contentRect.size.width;
    CGFloat titleHeight = 50;
    return CGRectMake(titleX, titleY, titleWidth, titleHeight);
}

@end
