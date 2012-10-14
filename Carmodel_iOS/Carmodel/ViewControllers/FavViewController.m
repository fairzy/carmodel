//
//  FavViewController.m
//  Carmodel
//
//  Created by fairzy fan on 12-3-24.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import "FavViewController.h"
#import "ImageObject.h"
#import "PhotoDetailViewController.h"
#import "CustomRootViewController.h"
#import "MobClick.h"

@implementation FavViewController

@synthesize favArray;
@synthesize scrollView;
@synthesize errorView;

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{   
    [super loadView];
    
    PhotoScrollView * sv = [[PhotoScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    sv.hidden = NO;
    [self.view addSubview:sv];
    self.scrollView = sv;
    self.scrollView.delegate = self;
    sv.responder = self;
    [sv release];
    
    ErrorView * ev = [[ErrorView alloc] initWithTitle:@"你还木有收藏吖"];
    ev.hidden = YES;
    [self.view addSubview:ev];
    self.errorView = ev;
    [ev release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"%s", __func__);
    [super viewWillAppear:animated];
    
    // 处理navigationbar
    CustomRootViewController * tabc = (CustomRootViewController *)self.tabBarController;
    [tabc setCustomNavBarTitle:@"收藏"];
    [tabc setNavigateBarType:NavigateTypeFav];
    [tabc setCustomTabBarHidden:NO];
    tabc.customNavBar.delegate = self;
    
    // 清楚旧的图片吖
    NSLog(@"clear");
    [self.scrollView clearImages];
    // 读取list
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:FAV_USER_DEFAULT_KEY];
    NSArray * array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"data:%@", array);
    if ( array == nil || [array count]==0) {
        NSLog(@"nothing int there");
        errorView.hidden = NO;
        self.scrollView.hidden = YES;
    }else{
        errorView.hidden = YES;
        self.scrollView.hidden = NO;
        NSLog(@"array个数:%d", [array count]);
        NSMutableArray * realarray = [NSMutableArray arrayWithCapacity:[array count]];
        for (ImageObject * aobj in array) {
            [realarray addObject:[aobj convertToObject] ];
        }
        NSLog(@"realarray个数:%d", [realarray count]);
        self.favArray = [NSArray arrayWithArray:realarray];
        [self.scrollView loadImages:realarray];
    }
}

#pragma mark delegate

- (void)imageClicked:(int)_index{
    id obj = [self.favArray objectAtIndex:_index];
    
    PhotoDetailViewController * pdv = [[PhotoDetailViewController alloc] initwithImageObject:obj];
    [self.navigationController pushViewController:pdv animated:YES];
    [pdv release];
    
    // umeng统计
    [MobClick event:@"ImageClicked" label:[obj objectForKey:@"id"]];
}

- (void)clearFav{
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:FAV_USER_DEFAULT_KEY];
    if ( data == nil ) {
        return;
    }
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"确认" message:@"确认清空收藏?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
    [alert release];
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ( buttonIndex == 1 ) {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:FAV_USER_DEFAULT_KEY];
        [self.scrollView clearImages];
        
        self.errorView.hidden = NO;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)sv{
    NSLog(@"begin drag:%f", sv.contentOffset.y);
    scrollviewLastpos = sv.contentOffset.y;
}
- (void)scrollViewDidScroll:(UIScrollView *)sv{
    NSLog(@"contentoffset.y:%f", sv.contentOffset.y);
    CustomRootViewController * tabc = (CustomRootViewController *)self.tabBarController;
    if ( sv.contentOffset.y > scrollviewLastpos ) {
        // 是向下滑动
        NSLog(@"隐藏");
        // 隐藏navigation bar
        [tabc setCustomTabBarHidden:YES];
        [tabc setCustomNavBarHide:YES];
    }else{
        NSLog(@"显示");
        // 隐藏navigation bar
        [tabc setCustomTabBarHidden:NO];
        [tabc setCustomNavBarHide:NO];
    }
}

#pragma mark memory
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc{
    NSLog(@"%s", __func__);
    [favArray release];
    [scrollView release];
    [errorView release];
    [super dealloc];
}

@end
