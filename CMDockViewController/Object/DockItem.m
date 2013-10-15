//
//  DockItem.m
//  Cloud Mario Dock View Controller
//
//  Created by apple on 13-9-11.
//  Copyright (c) 2013年 Bruce ( Cloud Mario ). All rights reserved.
//

#import "DockItem.h"

@implementation DockItem
+ (id)itemWithIcon:(NSString *)icon title:(NSString *)title badge:(NSString *)badge className:(NSString *)className modal:(BOOL)modal
{
    DockItem *item = [[DockItem alloc] init];
    item.icon = icon;
    item.title = title;
    item.className = className;
    item.modal = modal;
    item.badge = badge;
    return item;
}

+ (id)itemWithIcon:(NSString *)icon title:(NSString *)title badge:(NSString *)badge className:(NSString *)className
{
    return [self itemWithIcon:icon title:title badge:badge className:className modal:NO];
}

+ (id)itemWithIcon:(NSString *)icon className:(NSString *)className modal:(BOOL)modal
{
    return [self itemWithIcon:icon title:nil badge:nil className:className modal:modal];
}

+ (id)itemWithIcon:(NSString *)icon className:(NSString *)className
{
    return [self itemWithIcon:icon title:nil badge:nil className:className modal:NO];
}

- (BOOL)isEqual:(id)object {
    return ([object isKindOfClass:[DockItem class]]
            && [[object className] isEqualToString:self.className]);
}

@end