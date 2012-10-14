//
//  CategoryViewController.m
//  Carmodel
//
//  Created by fairzy fan on 12-3-14.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import "CategoryViewController.h"
#import "JSONKit.h"
#import "CategoryCellViewCell.h"
#import "TopicListViewController.h"
#import "CustomRootViewController.h"
#import "MobClick.h"

@implementation CategoryViewController

@synthesize tableView;
@synthesize categoryList;
@synthesize netRequest;

- (void)loadView{
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithRed:0.88f green:0.88f blue:0.88f alpha:1.0f];
    
    UITableView * tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, 320, 359) style:UITableViewStylePlain];
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    tv.backgroundColor = [UIColor colorWithRed:0.88f green:0.88f blue:0.88f alpha:1.0f];
    tv.delegate = self;
    tv.dataSource = self;
    [self.view addSubview:tv];
    self.tableView = tv;
    [tv release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadCategoryList];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 处理navigationbar
    CustomRootViewController * tabc = (CustomRootViewController *)self.tabBarController;
    [tabc setCustomNavBarTitle:@"分类"];
    [tabc setNavigateBarType:NavigateTypeNormal];
    [tabc setCustomTabBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)loadCategoryList{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
    
    NSURL *url = [NSURL URLWithString:@"http://carmodel.sinaapp.com/api/category_list.php"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    self.netRequest = request;
    [request setDelegate:self];
    [request startAsynchronous];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CATE_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = [indexPath row];
    [tv deselectRowAtIndexPath:indexPath animated:YES];
    
    id theobj = [self.categoryList objectAtIndex:row];
    int theid = [[theobj objectForKey:@"id"] intValue];
    TopicListViewController * topicvc = [[TopicListViewController alloc] initwithCategoryId:theid title:[theobj objectForKey:@"name"]];
    [self.navigationController pushViewController:topicvc animated:YES];
    [topicvc release];
    
    // umeng统计
    [MobClick event:@"CategoryClick" label:[theobj objectForKey:@"name"]];
}

#pragma makr UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section{
    if ( self.categoryList == nil ) {
        return 0;
    }else{
        return [self.categoryList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = [indexPath row];
    NSString * cellId = [NSString stringWithFormat:@"CategoryCellId_%d", row];
    UITableViewCell * cell = [tv dequeueReusableCellWithIdentifier:cellId];
    if ( cell == nil ) {
        cell = [[[CategoryCellViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    id cate = [self.categoryList objectAtIndex:row];
    NSString * title = [cate objectForKey:@"name"];
    NSString * iconpath = [NSString stringWithFormat:@"image_category_icon_%d.png", row%10];
    [((CategoryCellViewCell *)cell) setCellIcon:iconpath title:title ];
    
    return cell;
}

#pragma mark ASIHttpRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [HUD hide:YES];
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSLog(@"category responseString:%@", responseString);
    self.categoryList = [responseString objectFromJSONString];
    [self.tableView reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [HUD hide:YES];
    
//    NSError * error = [request error];
//    NSString * errorstr = [NSString stringWithFormat:@"error:%@,%@", error.description, error.userInfo];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请求失败，请重试" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
	HUD = nil;
}

#pragma mark release

- (void)viewDidUnload
{
    NSLog(@"%s", __func__);
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.tableView = nil;
}

- (void)dealloc{
    NSLog(@"%s", __func__);
    [tableView release];
    [categoryList release];
    [netRequest clearDelegatesAndCancel];
    [netRequest release];
    
    [super dealloc];
}

@end
