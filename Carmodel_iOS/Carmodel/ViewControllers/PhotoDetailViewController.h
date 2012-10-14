//
//  PhotoDetailViewController.h
//  Carmodel
//
//  Created by fairzy fan on 12-3-20.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "URLImageView.h"
#import "CustomRootViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "CommentView.h"

@interface PhotoDetailViewController : UIViewController<CustomNavigationBarDelegate, ASIHTTPRequestDelegate, UITableViewDelegate, UITableViewDataSource>{
    UIScrollView * scrollView;
    URLImageView * imageView;
    UITableView * tableView;
    CommentView * commentView;
    UIButton * likeBtn;
    UIButton * favBtn;
    
    NSArray * commentDataArray;
    id imageObject;
    id delegate;
    BOOL liked;
    ASIHTTPRequest * netRequest;
    ASIHTTPRequest * commentRequest;
    int likeCount;
}


@property (nonatomic, retain) UIScrollView * scrollView;
@property (nonatomic, retain) UITableView * tableView;
@property (nonatomic, retain) URLImageView * imageView;
@property (nonatomic, retain) CommentView * commentView;
@property (nonatomic, retain) id imageObject;
@property (nonatomic, retain) NSArray * commentDataArray;
@property (nonatomic, retain) UIButton * likeBtn;
@property (nonatomic, retain) UIButton * favBtn;
@property (nonatomic, retain) ASIHTTPRequest * netRequest;
@property (nonatomic, retain) ASIHTTPRequest * commentRequest;

- (id)initwithImageObject:(id)obj;
- (void)requestLikeCount;
- (void)requestComment;

@end
