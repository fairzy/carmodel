//
//  HotViewController.h
//  Carmodel
//
//  Created by fairzy fan on 12-3-14.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"

@interface HotViewController : UIViewController<ASIHTTPRequestDelegate, UIScrollViewDelegate, MBProgressHUDDelegate>{
    UIScrollView * scrollView;
    UIButton * loadmoreBtn;
    UIButton * loadLastBtn;
    UIView * errorView;
    MBProgressHUD *HUD;
    
    int currentPage;
    NSArray * imageArray;
    float leftheight;
    float rightheight;
    float scrollviewLastpos;
    ASIHTTPRequest *netRequest;
    BOOL hasMorePage;
}

@property (nonatomic, retain) UIScrollView * scrollView;
@property (nonatomic, retain) UIButton * loadmoreBtn;
@property (nonatomic, retain) UIButton * loadLastBtn;
@property (nonatomic, retain) UIView * errorView;

@property (nonatomic, retain) NSArray * imageArray;
@property (nonatomic, retain) ASIHTTPRequest *netRequest;

- (void)requestImageList;
- (void)clearImages;
@end
