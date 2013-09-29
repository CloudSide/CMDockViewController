//
//  DockItem.m
//  QQ空间-HD
//
//  Created by apple on 13-9-11.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "DockItem.h"

@implementation DockItem
+ (id)itemWithIcon:(NSString *)icon title:(NSString *)title className:(NSString *)className modal:(BOOL)modal
{
    DockItem *item = [[DockItem alloc] init];
    item.icon = icon;
    item.title = title;
    item.className = className;
    item.modal = modal;
    return item;
}

+ (id)itemWithIcon:(NSString *)icon title:(NSString *)title className:(NSString *)className
{
    return [self itemWithIcon:icon title:title className:className modal:NO];
}

+ (id)itemWithIcon:(NSString *)icon className:(NSString *)className modal:(BOOL)modal
{
    return [self itemWithIcon:icon title:nil className:className modal:modal];
}

+ (id)itemWithIcon:(NSString *)icon className:(NSString *)className
{
    return [self itemWithIcon:icon title:nil className:className modal:NO];
}

@end