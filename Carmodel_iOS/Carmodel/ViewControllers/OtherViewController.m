//
//  OtherViewController.m
//  Carmodel
//
//  Created by fairzy fan on 12-3-29.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import "OtherViewController.h"


@implementation OtherViewController

//@synthesize helpView;
//@synthesize aboutView;

- (id)initWhitVCType:(enum ViewControllerType)type
{
    self = [super init];
    if (self) {
        // Custom initialization
        vcType = type;
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    // 背景
    UIImageView * bgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"view_background.png"]];
    bgview.frame = CGRectMake(0, 0, 320, 480);
    [self.view addSubview:bgview];
    [bgview release];
    
    // 自定义NavigationBar
    CustomNavigationBar * navbar = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 56)];
    [navbar setBackBtnShow:YES];
    navbar.delegate = self;
    [self.view addSubview:navbar];
    
    // helpView
    NSString * imageName = nil;
    NSString * text = nil;
    float height = 0.0f;
    if ( vcType == VCTypeAbout ) {
        navbar.titleLabel.text = @"关于你和我";
        imageName = @"huluwa1.png";
        text = @"我和你一样\n爱好世界和平\n喜欢楼下的妹子\n我们也为谁谁谁的梦想奋斗\nso,   骚年\n来一发吧!\n\nemail:fairzy@gmail.com";
        height = 180.0f;
    }else if( vcType == VCTypeHelp ){
        navbar.titleLabel.text = @"互撸互助";
        imageName = @"huluwa2.png";
        text = @"so, 发现一张你喜欢的妹子\n\n准备好纸巾\n\n羞涩的练就我们强大的左手吧!";
        height = 120.0f;
    }
    UIImageView * imgview = [[UIImageView alloc] initWithFrame:CGRectMake(60, 50, 200, 164)];
    imgview.image = [UIImage imageNamed:imageName];
    [self.view addSubview:imgview];
    [imgview release];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 230, 320, height)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.textAlignment = UITextAlignmentCenter;
    label.text = text;
    [self.view addSubview:label];
    [label release];
    
    [navbar release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)navigateBack:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
