//
//  RootViewController.h
//  Carmodel
//
//  Created by fairzy fan on 12-3-14.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBar.h"
#import "CustomNavigationBar.h"

enum NavigateType {
    NavigateTypeNormal = 0,
    NavigateTypeBack = 1,
    NavigateTypeFav = 2
};

@interface CustomRootViewController : UITabBarController<CustomTabBarDelegate>{
//    NSArray * viewControllers;
    CustomTabBar * customTabBar;
    CustomNavigationBar * customNavBar;
}

//@property (nonatomic, retain) NSArray * viewControllers;
@property (nonatomic, retain) CustomTabBar * customTabBar;
@property (nonatomic, retain) CustomNavigationBar * customNavBar;

- (void)setCustomNavBarTitle:(NSString *)tit;
- (void)setCustomTabBarHidden:(BOOL)hide;
- (void)setCustomNavBarHide:(BOOL)hide;
- (void)setNavigateBarType:(enum NavigateType)type;
@end
