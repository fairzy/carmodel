//
//  FavViewController.h
//  Carmodel
//
//  Created by fairzy fan on 12-3-24.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoScrollView.h"
#import "ErrorView.h"
#import "CustomNavigationBar.h"

@interface FavViewController : UIViewController<CustomNavigationBarDelegate, UIAlertViewDelegate, UIScrollViewDelegate>{
    NSArray * favArray;
    
    PhotoScrollView * scrollView;
    ErrorView * errorView;
    float scrollviewLastpos;
}

@property (nonatomic, retain) NSArray * favArray;
@property (nonatomic, retain) PhotoScrollView * scrollView;
@property (nonatomic, retain) ErrorView * errorView;

@end
