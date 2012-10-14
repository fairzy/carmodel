//
//  AppDelegate.h
//  Carmodel
//
//  Created by fairzy fan on 12-3-14.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomRootViewController.h"
#import "HotViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CustomRootViewController *tabBarController;

@end
