//
//  CustomNavigationBar.h
//  Carmodel
//
//  Created by fairzy fan on 12-3-15.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomNavigationBarDelegate

@optional
- (void)navigateBack:(id)sender;

@end

@interface CustomNavigationBar : UIView{
    UILabel * titleLabel;
    UIButton * backBtn;
    UIButton * clearBtn;
    
    NSObject <CustomNavigationBarDelegate>* delegate;
    BOOL isHide;
}

@property (nonatomic, assign) NSObject <CustomNavigationBarDelegate>* delegate;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIButton * backBtn;
@property (nonatomic, retain) UIButton * clearBtn;

- (void)setHide:(BOOL)hide;
- (void)setBackBtnShow:(BOOL)show;
- (void)setClearButtonShow:(BOOL)show;

@end
