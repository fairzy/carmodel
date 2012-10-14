//
//  TopicListViewController.m
//  Carmodel
//
//  Created by fairzy fan on 12-3-19.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import "TopicListViewController.h"
#import "JSONKit.h"
#import "CustomRootViewController.h"
#import "TopicListCellView.h"
#import "TopicDetailViewController.h"
#import "MobClick.h"

@implementation TopicListViewController

@synthesize tableView;
@synthesize categoryName;
@synthesize dataArray;
@synthesize netRequest;

- (id)initwithCategoryId:(int)cid title:(NSString *)name{
    self = [super init];
    if ( self ) {
        categoryId = cid;
        self.categoryName = name;
        // 设置navba
    }
    return self;
}

- (void)loadView{
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithRed:0.88f green:0.88f blue:0.88f alpha:1.0f];
    
    UITableView * tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, 320, 359)];
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    tv.backgroundColor = [UIColor colorWithRed:0.88f green:0.88f blue:0.88f alpha:1.0f];
    tv.delegate = self;
    tv.dataSource = self;
    [self.view addSubview:tv];
    self.tableView = tv;
    [tv release];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    currentPage = 0;
    if ( dataArray == nil ) {
        self.dataArray = [[NSMutableArray alloc] initWithCapacity:50];
    }
    [self requestTopicList];
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"%s", __func__);
    [super viewWillAppear:animated];
    
    // 处理自定义的navigationBar
    CustomRootViewController * tabc = (CustomRootViewController *)self.tabBarController;
    NSLog(@"tabc:%@", tabc);
    [tabc setCustomNavBarTitle:self.categoryName];
    tabc.customNavBar.delegate = self;
    [tabc setCustomTabBarHidden:NO];
    [tabc setNavigateBarType:NavigateTypeBack];
}

#pragma mark - method
- (void)requestTopicList{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
    
    NSString * url = [NSString stringWithFormat:@"http://carmodel.sinaapp.com/api/topic_list.php?category_id=%d&page=%d", categoryId, currentPage];
    NSURL * rurl = [NSURL URLWithString:url];
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:rurl];
    self.netRequest = request;
    [request setDelegate:self];
    [request startAsynchronous];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return TOPIC_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tv deselectRowAtIndexPath:indexPath animated:YES];
    id theobj = [self.dataArray objectAtIndex:[indexPath row]];
    
    TopicDetailViewController * tavc = [[TopicDetailViewController alloc] initWithTopicName:[theobj objectForKey:@"name"] TopicId:[[theobj objectForKey:@"id"] intValue]];
    [self.navigationController pushViewController:tavc animated:YES];
    [tavc release];
    
    // umeng 统计
    [MobClick event:@"TopicClick" label:[theobj objectForKey:@"name"]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ( dataArray == nil) {
        return 0;
    }else{
        return [dataArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = [indexPath row];
    
    NSString * CellId = @"TopicListCellId";
    UITableViewCell * cell = [tv dequeueReusableCellWithIdentifier:CellId];
    if ( cell == nil ) {
        cell = [[[TopicListCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    id theobj = [self.dataArray objectAtIndex:row];
    ((TopicListCellView *)cell).nameLabel.text = [theobj objectForKey:@"name"];
    
    return cell;
}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request{
    [HUD hide:YES];
    
    NSString * responseStr = [request responseString];
    NSLog(@"responseString:%@", responseStr);
    id obj = [responseStr objectFromJSONString];
    NSArray * data = [obj objectForKey:@"data"];
    if ( data && [data isKindOfClass:[NSArray class]] ) {
        [dataArray addObjectsFromArray:data];
        [self.tableView reloadData];
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    [HUD hide:YES];
    
//    NSError * error = [request error];
//    NSString * errorstr = [NSString stringWithFormat:@"error:%@,%@", error.description, error.userInfo];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请求失败，请重试" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

#pragma mark CustomNavigationBarDelegate
- (void)navigateBack:(id)sender{
    NSLog(@"topiclist vc navigate back");

    // pop
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
	HUD = nil;
}

#pragma mark - Memory
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    
}

//- (void)viewDidUnload
//{
//    NSLog(@"%@", __func__);
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//    
//    
//}

- (void)dealloc{
    NSLog(@"topic list dealloc");
    NSLog(@"%s", __func__);
    [self.netRequest clearDelegatesAndCancel];
    [tableView release];
//    NSLog(@"categoryName:%@", categoryName);
    [categoryName release];
    NSLog(@"dataArray:%@", dataArray);
    [dataArray release];
    [netRequest release];
    
    [super dealloc];
}

@end
