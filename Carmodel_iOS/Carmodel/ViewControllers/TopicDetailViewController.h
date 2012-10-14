//
//  TopicDetailViewController.h
//  Carmodel
//
//  Created by fairzy fan on 12-3-20.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBar.h"
#import "CustomRootViewController.h"
#import "PhotoScrollView.h"
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"

@interface TopicDetailViewController : UIViewController<CustomNavigationBarDelegate, ASIHTTPRequestDelegate, MBProgressHUDDelegate>{
    NSString * topicName;
    int topicId;
    NSArray * imageListData;

    PhotoScrollView * scrollView;
    MBProgressHUD *HUD;
    
    ASIHTTPRequest * netRequest;
}

@property (nonatomic, retain) PhotoScrollView * scrollView;
@property (nonatomic, retain) NSString * topicName;
@property (nonatomic, retain) NSArray * imageListData;
@property (nonatomic, retain) ASIHTTPRequest * netRequest;

- (id)initWithTopicName:(NSString *)name TopicId:(int)_id;
- (void)requestTopicImages;

@end
