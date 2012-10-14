//
//  TopicListViewController.h
//  Carmodel
//
//  Created by fairzy fan on 12-3-19.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "CustomNavigationBar.h"
#import "MBProgressHUD.h"

@interface TopicListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, ASIHTTPRequestDelegate,CustomNavigationBarDelegate, MBProgressHUDDelegate>{
    UITableView * tableView;
    MBProgressHUD *HUD;
    
    NSMutableArray * dataArray;
    int currentPage;
    int categoryId;
    NSString * categoryName;
    ASIHTTPRequest * netRequest;
}

@property (nonatomic, retain) UITableView * tableView;
@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSMutableArray * dataArray;
@property (nonatomic, retain) ASIHTTPRequest * netRequest;

- (id)initwithCategoryId:(int)cid title:(NSString *)name;
- (void)requestTopicList;

@end
