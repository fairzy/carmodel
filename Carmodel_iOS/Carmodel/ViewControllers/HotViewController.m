//
//  HotViewController.m
//  Carmodel
//
//  Created by fairzy fan on 12-3-14.
//  Copyright (c) 2012年 PConline. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "HotViewController.h"
#import "CategoryViewController.h"
#import "CustomRootViewController.h"
#import "CustomTabBar.h"
#import "URLImageView.h"
#import "HotViewController.h"
#import "JSONKit.h"
#import "ErrorView.h"
#import "PhotoDetailViewController.h"
#import "MobClick.h"

#define IMAGE_START_TAG 100
#define LOAD_MORE_BTN_HEIGHT 

@implementation HotViewController

@synthesize scrollView;
@synthesize loadmoreBtn;
@synthesize loadLastBtn;
@synthesize imageArray;
@synthesize errorView;
@synthesize netRequest;

#define VIEW_START_TAG 100

- (void)loadView{
    [super loadView];
    currentPage = -1;
    leftheight = 0;
    rightheight = 0;
    hasMorePage = YES;
    // 背景
    UIImageView * bgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"view_background.png"]];
    bgview.frame = CGRectMake(0, 0, 320, 480);
    [self.view addSubview:bgview];
    [bgview release];

    // Scroll view
    UIScrollView * sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    sv.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sv];
    self.scrollView = sv;
    self.scrollView.delegate = self;
    [sv release];
    
    // loadmore btn
    UIButton * lastbtn = [[UIButton alloc] init ];
    lastbtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [lastbtn setTitle:@"上一页" forState:UIControlStateNormal];
    [lastbtn setBackgroundImage:[UIImage imageNamed:@"button_function.png"] forState:UIControlStateNormal];
    [lastbtn addTarget:self action:@selector(loadPrepageImage) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:lastbtn];
    self.loadLastBtn = lastbtn;
    [lastbtn release];
    
    // loadmore btn
    UIButton * morebtn = [[UIButton alloc] init ];
    morebtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [morebtn setTitle:@"下一页" forState:UIControlStateNormal];
    [morebtn setBackgroundImage:[UIImage imageNamed:@"button_function.png"] forState:UIControlStateNormal];
    [morebtn addTarget:self action:@selector(loadMoreImage) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:morebtn];
    self.loadmoreBtn = morebtn;
    [morebtn release];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // 一次30条
    currentPage = 0;
    [self requestImageList];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 处理navigationbar
    CustomRootViewController * tabc = (CustomRootViewController *)self.tabBarController;
    [tabc setCustomNavBarTitle:@"最热"];
    [tabc setNavigateBarType:NavigateTypeNormal];
    [tabc setCustomTabBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // 处理navigationbar
    CustomRootViewController * tabc = (CustomRootViewController *)self.tabBarController;
    [tabc setCustomTabBarHidden:NO];
}

#pragma mark - method
- (void)imageClicked:(UIGestureRecognizer *)gesture{
    CustomRootViewController * tabc = (CustomRootViewController *)self.tabBarController;
    [tabc setCustomNavBarHide:NO];
    
    int index = gesture.view.tag - VIEW_START_TAG;
    id obj = [self.imageArray objectAtIndex:index];
    
    PhotoDetailViewController * pdv = [[PhotoDetailViewController alloc] initwithImageObject:obj];
    [self.navigationController pushViewController:pdv animated:YES];
    [pdv release];
    
    // umeng统计
    [MobClick event:@"ImageClicked" label:[obj objectForKey:@"id"]];
}

- (void)loadPrepageImage{
     [self clearImages];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    currentPage--;
    [self requestImageList];
}
- (void)loadMoreImage{
    [self clearImages];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    currentPage++;
    [self requestImageList];
}

- (void)clearImages{
    for (id subview in self.scrollView.subviews) {
        if ([subview isKindOfClass:[URLImageView class]]) {
            NSLog(@"%@", subview);
            [subview removeFromSuperview];
        }
    }
    leftheight = 0;
    rightheight = 0;
}

- (void)requestImageList{
    if ( netRequest ) {
        [netRequest clearDelegatesAndCancel];
        [netRequest release];
        netRequest = nil;
    }
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
    
    NSString * param = [NSString stringWithFormat:@"http://carmodel.sinaapp.com/api/hot_list.php?page=%d", currentPage];
    NSURL *url = [NSURL URLWithString:param];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
    self.netRequest = request;
    
    // umeng统计
    [MobClick event:@"loadMorePage" label:[NSString stringWithFormat:@"%d", currentPage]];
}

- (void)addImages{
    // 一页有30条数据, 开始load currentPage
    // 左边一行
    for (int i=0; i < [self.imageArray count]; i++) {
        // __block__
        id imgobj = [self.imageArray objectAtIndex:i];
        NSString * sizestr = [imgobj objectForKey:@"size"];
        NSArray * sizearray = [sizestr componentsSeparatedByString:@"x"];
        float width = [[sizearray objectAtIndex:0] floatValue];
        float height = [[sizearray objectAtIndex:1] floatValue];
        float trueheight = height/width * 160;
        float truewidth = 160;
        // __block__
        
        // 左边
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked:)];
        if ( i%2 == 0 ) {
            NSLog(@"%d - left", i);
            CGRect aframe = CGRectMake(0, leftheight+1, truewidth, trueheight);
            URLImageView * aimageview = [[URLImageView alloc] initWithFrame:aframe imageObj:imgobj defaultImage:nil lightBg:YES];
            aimageview.delegate = self;
            aimageview.tag = VIEW_START_TAG+i;
            [aimageview addGestureRecognizer:gesture];
            [self.scrollView addSubview:aimageview];
            aimageview.layer.borderColor = [[UIColor blackColor] CGColor];
            aimageview.layer.borderWidth = 1.0f;
            [aimageview startLoadImage];
            [aimageview release];
            
            // 修改leftheigh
            leftheight += trueheight+2;
        }else{
        // 右边
            NSLog(@"%d - right", i);
            CGRect aframe = CGRectMake(160, rightheight+1, truewidth, trueheight);
            URLImageView * aimageview = [[URLImageView alloc] initWithFrame:aframe imageObj:imgobj defaultImage:nil lightBg:YES];
            aimageview.delegate = self;
            aimageview.tag = VIEW_START_TAG+i;
            [aimageview addGestureRecognizer:gesture];
            [self.scrollView addSubview:aimageview];
            aimageview.layer.borderColor = [[UIColor blackColor] CGColor];
            aimageview.layer.borderWidth = 1.0f;
            [aimageview startLoadImage];
            [aimageview release];
            //
            rightheight += trueheight+2;
        }
        [gesture release];
    }
    float conentheight = leftheight>rightheight?leftheight:rightheight;
    // 调整加载更多btn的位置
    CGRect frame2 = CGRectMake(240, conentheight+10, 60, 42);
    CGRect frame1 = CGRectMake(20, conentheight+10, 60, 42);
    self.loadLastBtn.frame = frame1;
    self.loadmoreBtn.frame = frame2;
    self.loadmoreBtn.hidden = NO;
    self.loadLastBtn.hidden = NO;
    if ( currentPage == 0 ) {
        self.loadLastBtn.hidden = YES;
    }
    [scrollView setContentSize:CGSizeMake(320, conentheight+130)]; // btn.height+tabbar.height
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)sv{
    scrollviewLastpos = sv.contentOffset.y;
}
- (void)scrollViewDidScroll:(UIScrollView *)sv{
    CustomRootViewController * tabc = (CustomRootViewController *)self.tabBarController;
    if ( sv.contentOffset.y > scrollviewLastpos ) {
        // 是向下滑动
        // 隐藏navigation bar
        [tabc setCustomTabBarHidden:YES];
        [tabc setCustomNavBarHide:YES];
    }else{
        // 隐藏navigation bar
        [tabc setCustomTabBarHidden:NO];
        [tabc setCustomNavBarHide:NO];
    }
}

#pragma mark ASIHttpRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [HUD hide:YES];
    // clear old data
    if ( imageArray ) {
        [imageArray release];
        imageArray = nil;
    }
    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSArray * newdata = [responseString objectFromJSONString];
    
    if ( newdata != nil && [newdata isKindOfClass:[NSArray class]]) {
        self.imageArray = [NSArray arrayWithArray: newdata];
        [self addImages];
    }else{
        loadmoreBtn.hidden = YES;
        if ( currentPage==1 && errorView ) {
            [errorView removeFromSuperview];
            [errorView release];
            errorView = nil;
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [HUD hide:YES];
//    NSError * error = [request error];
//    NSString * errorstr = [NSString stringWithFormat:@"error:%@,%@", error.description, error.userInfo];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请求失败，请重试" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    
    if ( errorView == nil) {
        ErrorView * ev = [[ErrorView alloc] initWithTitle:@"发生错误，加载失败"];
        [self.scrollView addSubview:ev];
        self.errorView = ev;
        [ev release];
    }
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
	HUD = nil;
}

#pragma mark - memrory
- (void)didReceiveMemoryWarning{
    NSLog(@"%s", __func__);
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    NSLog(@"%s", __func__);
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.scrollView = nil;
    
}

- (void)dealloc{
    NSLog(@"%s", __func__);
    [imageArray release];
    [scrollView release];
    [self.netRequest clearDelegatesAndCancel];
    [netRequest release];
    [loadmoreBtn release];
    [loadLastBtn release];
    [errorView release];
    [super dealloc];
}


@end
