//
//  CustomTabBar.m
//  Carmodel
//
//  Created by fairzy fan on 12-3-14.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import "CustomTabBar.h"

@implementation CustomTabBar

@synthesize delegate;
@synthesize hotBtn;
@synthesize categoryBtn;
@synthesize searchBtn;
@synthesize moreBtn;

- (id)initWithFrame:(CGRect)frame delegate:(NSObject <CustomTabBarDelegate>*)_delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = _delegate;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        
        // Initialization code
        UIImageView * bgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 62)];
        bgview.image = [UIImage imageNamed:@"image_tabbar_background.png"];
        [self addSubview:bgview];
        [bgview release];
        // 最热 tab 
        UIButton * hotbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [hotbtn setFrame:CGRectMake(3, 8, 77, 46)]  ;
        [hotbtn setImage:[UIImage imageNamed:@"image_tabbar_button_home_selected.png"] forState:UIControlStateNormal];
        [hotbtn setImage:[UIImage imageNamed:@"image_tabbar_button_home_down.png"] forState:UIControlStateHighlighted];
        hotbtn.tag = 0;
        hotbtn.showsTouchWhenHighlighted = NO;
        hotbtn.adjustsImageWhenHighlighted = NO;
        [hotbtn addTarget:self action:@selector(tabbtnClicked:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:hotbtn];
        self.hotBtn = hotbtn;
            //
        UILabel * hotlabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 40, 77, 16)];
        hotlabel.text = @"最热";
        hotlabel.backgroundColor = [UIColor clearColor];
        hotlabel.font = [UIFont systemFontOfSize:10.0f];
        hotlabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:hotlabel];
        [hotlabel release];
        // 分类 tab
        UIButton * catebtn = [UIButton buttonWithType:UIButtonTypeCustom]; 
        [catebtn setFrame:CGRectMake(82, 8, 77, 46)];
        [catebtn setImage:[UIImage imageNamed:@"image_tabbar_button_category.png"] forState:UIControlStateNormal];
        [catebtn setImage:[UIImage imageNamed:@"image_tabbar_button_category_down.png"] forState:UIControlStateHighlighted];
        catebtn.tag = 1;
        catebtn.showsTouchWhenHighlighted = NO;
        [catebtn addTarget:self action:@selector(tabbtnClicked:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:catebtn];
        self.categoryBtn = catebtn;
            //
        UILabel * catelabel = [[UILabel alloc] initWithFrame:CGRectMake(82, 40, 77, 16)];
        catelabel.text = @"分类";
        catelabel.backgroundColor = [UIColor clearColor];
        catelabel.font = [UIFont systemFontOfSize:10.0f];
        catelabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:catelabel];
        [catelabel release];
        // 搜索 tab
        UIButton * searchbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [searchbtn setFrame:CGRectMake(161, 8, 77, 46)];
        [searchbtn setImage:[UIImage imageNamed:@"image_tabbar_button_search.png"] forState:UIControlStateNormal];
        [searchbtn setImage:[UIImage imageNamed:@"image_tabbar_button_search_down.png"] forState:UIControlStateHighlighted];
        searchbtn.tag = 2;
        searchbtn.showsTouchWhenHighlighted = NO;
        [searchbtn addTarget:self action:@selector(tabbtnClicked:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:searchbtn];
        self.searchBtn = searchbtn;
            //
        UILabel * searchlabel = [[UILabel alloc] initWithFrame:CGRectMake(161, 40, 77, 16)];
        searchlabel.text = @"收藏";
        searchlabel.backgroundColor = [UIColor clearColor];
        searchlabel.font = [UIFont systemFontOfSize:10.0f];
        searchlabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:searchlabel];
        [searchlabel release];
        // 各种 tab
        UIButton * morebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [morebtn setFrame:CGRectMake(240, 8, 77, 46)];
        [morebtn setImage:[UIImage imageNamed:@"image_tabbar_button_more.png"] forState:UIControlStateNormal];
        [morebtn setImage:[UIImage imageNamed:@"image_tabbar_button_more_down.png"] forState:UIControlStateHighlighted];
        morebtn.tag = 3;
        morebtn.showsTouchWhenHighlighted = NO;
        [morebtn addTarget:self action:@selector(tabbtnClicked:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:morebtn];
        self.moreBtn = morebtn;
            //
        UILabel * morelabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 40, 77, 16)];
        morelabel.text = @"各种";
        morelabel.backgroundColor = [UIColor clearColor];
        morelabel.font = [UIFont systemFontOfSize:10.0f];
        morelabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:morelabel];
        [morelabel release];
        
        currentTab = 0;
    }
    return self;
}

- (void)tabbtnClicked:(id)sender{
    NSLog(@"tabbed");
    UIButton * btn = (UIButton *)sender;
    int tag = btn.tag;
    NSLog(@"tag:%d - currenttab:%d", tag, currentTab);
    if ( tag == currentTab ) {
        return;
    }
    switch (tag) {
        case 0:
            [hotBtn setImage:[UIImage imageNamed:@"image_tabbar_button_home_selected.png"] forState:UIControlStateNormal];
            break;
        case 1:
            [categoryBtn setImage:[UIImage imageNamed:@"image_tabbar_button_category_selected.png"] forState:UIControlStateNormal];
            break;
        case 2:
            [searchBtn setImage:[UIImage imageNamed:@"image_tabbar_button_search_selected.png"] forState:UIControlStateNormal];
            break;
        case 3:
            [moreBtn setImage:[UIImage imageNamed:@"image_tabbar_button_more_selected.png"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    switch (currentTab) {
        case 0:
            [hotBtn setImage:[UIImage imageNamed:@"image_tabbar_button_home.png"] forState:UIControlStateNormal];
            break;
        case 1:
            [categoryBtn setImage:[UIImage imageNamed:@"image_tabbar_button_category.png"] forState:UIControlStateNormal];
            break;
        case 2:
            [searchBtn setImage:[UIImage imageNamed:@"image_tabbar_button_search.png"] forState:UIControlStateNormal];
            break;
        case 3:
            [moreBtn setImage:[UIImage imageNamed:@"image_tabbar_button_more.png"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    currentTab = tag;
    
    if ( [delegate respondsToSelector:@selector(tabbarSelected:)] ) {
        [delegate tabbarSelected:currentTab];
    }
}


- (void)dealloc{
    [hotBtn release];
    [categoryBtn release];
    [searchBtn release];
    [moreBtn release];
    [super dealloc];
}

@end
