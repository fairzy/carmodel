//
//  RootViewController.m
//  Carmodel
//
//  Created by fairzy fan on 12-3-14.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import "CustomRootViewController.h"
#import "HotViewController.h"
#import "CategoryViewController.h"
#import "FavViewController.h"
#import "MoreViewController.h"
#import "MobClick.h"

@implementation CustomRootViewController

//@synthesize viewControllers;
@synthesize customTabBar;
@synthesize customNavBar;

- (void)loadView{
    [super loadView];
    self.view.backgroundColor = [UIColor grayColor];
    
    CGRect frame = self.view.frame;
    // view controllers
    HotViewController * hotController = [[HotViewController alloc] init];
    [hotController.view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    hotController.view.tag = 10;
    CategoryViewController * cateController = [[CategoryViewController alloc] init];
    [cateController.view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    cateController.view.tag = 11;
    FavViewController * favController = [[FavViewController alloc] init];
    [favController.view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    favController.view.tag = 12;
    MoreViewController * moreController = [[MoreViewController alloc] init];
    [moreController.view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    moreController.view.tag = 13;
    //
    UINavigationController * hotnavController = [[UINavigationController alloc] initWithRootViewController:hotController];
    hotnavController.navigationBarHidden = YES;
    UINavigationController * catenavController = [[UINavigationController alloc] initWithRootViewController:cateController];
    catenavController.navigationBarHidden = YES;
    UINavigationController * favnavController = [[UINavigationController alloc] initWithRootViewController:favController];
    favnavController.navigationBarHidden = YES;
    UINavigationController * morenavController = [[UINavigationController alloc] initWithRootViewController:moreController];
    morenavController.navigationBarHidden = YES;
    self.viewControllers = [NSArray arrayWithObjects:hotnavController, catenavController, favnavController, morenavController,nil];
    //
    [hotController release];
    [cateController release];
    [favController release];
    [moreController release];
    
    [hotnavController release];
    [catenavController release];
    [favnavController release];
    [morenavController release];

    // 自定义NavigationBar
    CustomNavigationBar * navbar = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 20, 320, 56)];
    navbar.titleLabel.text = @"最热";
    [self.view addSubview:navbar];
    self.customNavBar = navbar;
    [navbar release];
    // 自定义TabBar
    NSLog(@"add");
    CustomTabBar * tabbar = [[CustomTabBar alloc] initWithFrame:CGRectMake(0, 418, 320, 62) delegate:self];
    [self.view addSubview:tabbar];
    self.customTabBar = tabbar;
    [tabbar release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.tabBar setHidden:YES];
    [self.tabBarController.tabBar setHidden:YES];
    UIView * theview = [[self.view subviews] objectAtIndex:0];
    CGRect thefr = theview.frame;
    thefr.size.height += 49.0f;
    [theview setFrame:thefr];
}

#pragma mark 自定义方法
- (void)setNavigateBarType:(enum NavigateType)type{
    if ( type == NavigateTypeNormal ) {
        [self.customNavBar setBackBtnShow:NO];
        [self.customNavBar setClearButtonShow:NO];
    }else if(type == NavigateTypeBack){
        [self.customNavBar setBackBtnShow:YES];
        [self.customNavBar setClearButtonShow:NO];
    }else{
        // 清空按钮
        [self.customNavBar setBackBtnShow:NO];
        [self.customNavBar setClearButtonShow:YES];
    }
}

- (void)setCustomNavBarTitle:(NSString *)tit{
    NSLog(@"settitle");
    self.customNavBar.titleLabel.text = tit;
}


- (void)setCustomNavBarHide:(BOOL)hide{
    [self.customNavBar setHide:hide];
}

- (void)setCustomTabBarHidden:(BOOL)hide{
    CGRect tabframe = self.customTabBar.frame;
    if ( hide==YES && tabframe.origin.y<=418.0f) {
        tabframe.origin.y += tabframe.size.height;
    }else if( hide == NO ){
        tabframe.origin.y = 418.0f;
    }
    [UIView beginAnimations:@"hideCustomTabBar" context:nil];
    [UIView setAnimationDuration:0.5f];
    [self.customTabBar setFrame:tabframe];
    [UIView commitAnimations];
}

#pragma mark CustomTabBarDeleage
- (void)tabbarSelected:(int)index{
    NSLog(@"%d tab selected.", index);
    [self setSelectedIndex:index];
    switch (index) {
        case 0:
            self.customNavBar.titleLabel.text = @"最热";
            break;
        case 1:
            self.customNavBar.titleLabel.text = @"分类";
            break;
        case 2:
            self.customNavBar.titleLabel.text = @"收藏";
            break;
        case 3:
            self.customNavBar.titleLabel.text = @"更多";
            break;
        default:
            break;
    }
    
    // umeng统计
    [MobClick event:@"TabClicked" label:self.customNavBar.titleLabel.text];
}
#pragma mark Memory
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.customNavBar = nil;
    self.customTabBar = nil;
}

- (void)dealloc{
    NSLog(@"%s", __func__);
    [customNavBar release];
    [customTabBar release];
    [super dealloc];
}

@end
