//
//  CategoryViewController.h
//  Carmodel
//
//  Created by fairzy fan on 12-3-14.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"

@interface CategoryViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate>{
    UITableView * tableView;
    MBProgressHUD *HUD;
    
    NSArray * categoryList; // 他只保留30条数据
    ASIHTTPRequest * netRequest;
    
}

@property (nonatomic, retain) UITableView * tableView;
@property (nonatomic, retain) NSArray * categoryList;
@property (nonatomic, retain) ASIHTTPRequest * netRequest;

- (void)loadCategoryList;

@end
