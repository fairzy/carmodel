//
//  TopicDetailViewController.m
//  Carmodel
//
//  Created by fairzy fan on 12-3-20.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import "TopicDetailViewController.h"
#import "JSONKit.h"
#import "PhotoDetailViewController.h"
#import "MobClick.h"

@implementation TopicDetailViewController

@synthesize topicName;
@synthesize scrollView;
@synthesize imageListData;
@synthesize netRequest;

- (id)initWithTopicName:(NSString *)name TopicId:(int)_id
{
    self = [super init];
    if (self) {
        // Custom initialization
        topicId = _id;
        self.topicName = name;
    }
    return self;
}


#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    
    PhotoScrollView * scrollv = [[PhotoScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    scrollv.responder = self;
    [self.view addSubview:scrollv];
    self.scrollView = scrollv;
    [scrollv release];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self requestTopicImages];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 处理自定义的navigationBar
    CustomRootViewController * tabc = (CustomRootViewController *)self.tabBarController;
    NSLog(@"topic detail title:%@, id:%d", topicName, topicId);
    [tabc setCustomNavBarTitle:topicName];
    tabc.customNavBar.delegate = self;
    [tabc setCustomTabBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark - method
- (void)requestTopicImages{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
    
    NSString * param = [NSString stringWithFormat:@"http://carmodel.sinaapp.com/api/image_list.php?topic_id=%d", topicId];
    NSURL *url = [NSURL URLWithString:param];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    self.netRequest = request;
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)imageClicked:(int)_index{
    id obj = [self.imageListData objectAtIndex:_index];
    
    PhotoDetailViewController * pdv = [[PhotoDetailViewController alloc] initwithImageObject:obj];
    [self.navigationController pushViewController:pdv animated:YES];
    [pdv release];
    
    // umeng统计
    [MobClick event:@"ImageClicked" label:[obj objectForKey:@"id"]];
}

#pragma mark ASIHttpRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [HUD hide:YES];
    
    NSString * responstr = [request responseString];
    id objs = [responstr objectFromJSONString];
    if ( objs && [objs isKindOfClass:[NSArray class]] ) {
        self.imageListData = [NSArray arrayWithArray:objs];
        [self.scrollView loadImages:imageListData];
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
    NSLog(@"topic deail navigate back");
    
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

    
#pragma mark - memory

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    
}

- (void)viewDidUnload
{
    NSLog(@"%s", __func__);
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (void)dealloc{
    NSLog(@"%s", __func__);
    NSLog(@"topicName release:%@", topicName);
    [topicName release];
    NSLog(@"imageListData release");
    [imageListData release];
    NSLog(@"scrollView release, %@", scrollView);
    [scrollView release];
    NSLog(@"netRequest release");
    [netRequest clearDelegatesAndCancel];
    [netRequest release];
    NSLog(@"super release");
    [super dealloc];
    NSLog(@"over release");
}

@end
