//
//  CustomTabBar.h
//  Carmodel
//
//  Created by fairzy fan on 12-3-14.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomTabBarDelegate

@required
- (void)tabbarSelected:(int)index;

@end

@interface CustomTabBar : UIView{
    int currentTab;
    NSObject <CustomTabBarDelegate>* delegate;
    
    UIButton * hotBtn;
    UIButton * categoryBtn;
    UIButton * searchBtn;
    UIButton * moreBtn;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) UIButton * hotBtn;
@property (nonatomic, retain) UIButton * categoryBtn;
@property (nonatomic, retain) UIButton * searchBtn;
@property (nonatomic, retain) UIButton * moreBtn;

- (id)initWithFrame:(CGRect)frame delegate:(NSObject <CustomTabBarDelegate>*)_delegate;

@end
