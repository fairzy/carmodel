//
//  OtherViewController.h
//  Carmodel
//
//  Created by fairzy fan on 12-3-29.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNavigationBar.h"

enum ViewControllerType {
    VCTypeHelp,
    VCTypeAbout,
    VCTypeFeedBack
    };

@interface OtherViewController : UIViewController<CustomNavigationBarDelegate>{
    enum ViewControllerType vcType;
    
//    // 帮助view
//    UIView * helpView;
//    UIView * aboutView;
}

//@property (nonatomic, retain) UIView * helpView;
//@property (nonatomic, retain) UIView * aboutView;
- (id)initWhitVCType:(enum ViewControllerType)type;

@end
