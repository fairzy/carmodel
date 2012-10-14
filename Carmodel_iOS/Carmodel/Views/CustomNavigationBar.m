//
//  CustomNavigationBar.m
//  Carmodel
//
//  Created by fairzy fan on 12-3-15.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import "CustomNavigationBar.h"

@implementation CustomNavigationBar

@synthesize titleLabel;
@synthesize backBtn;
@synthesize clearBtn;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        isHide = NO;
        // Initialization code
        UIImageView * bgimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image_titlebar_background.png"]];
        [self addSubview:bgimage];
        [bgimage release];
        // title 
        UILabel * tit = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 160, 36)];
        tit.textColor = [UIColor whiteColor];
        tit.backgroundColor = [UIColor clearColor];
        tit.textAlignment = UITextAlignmentCenter;
        tit.text = @"标题";
        [self addSubview:tit];
        self.titleLabel = tit;
        [tit release];
        
        // backbtn
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(5, 6, 54, 34)];
        [btn setImage:[UIImage imageNamed:@"navbar_button_back.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        btn.hidden = YES;
        self.backBtn = btn;
        [btn release];
        
        // 清空按钮
        UIButton * clearbtn = [[UIButton alloc] initWithFrame:CGRectMake(270, 6, 40, 34)];
        // backbtn
        [clearbtn setBackgroundImage:[UIImage imageNamed:@"navbar_button_clear.png"] forState:UIControlStateNormal];
        [clearbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [clearbtn setTitle:@"清空" forState:UIControlStateNormal];
        clearbtn.titleLabel.font = [UIFont systemFontOfSize:11.0f];
        [clearbtn addTarget:self action:@selector(clearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:clearbtn];
        clearbtn.hidden = YES;
        self.clearBtn = clearbtn;
        [clearbtn release];
    }
    return self;
}

- (void)setHide:(BOOL)hide{
    // bug: 
    if ( hide == isHide ) {
        return;
    }
    NSLog(@"hide");
    CGRect frame = self.frame;
    [UIView beginAnimations:@"showAnimation" context:nil];
    [UIView setAnimationDuration:0.5f];
    if ( hide == YES ) {
        frame.origin.y = -76.0f;
    }else{
        NSLog(@"要现实");
        frame.origin.y = 20.0f;
    }
    
    [self setFrame:frame];
    [UIView commitAnimations];
    if ( frame.origin.y < 0 ) {
        isHide = YES;
    }else{
        isHide = NO;
    }
}


#pragma mark 自定义方法
- (void)setBackBtnShow:(BOOL)show{
    self.backBtn.hidden = !show;
}

- (void)setClearButtonShow:(BOOL)show{
    self.clearBtn.hidden = !show;
}


- (void)backBtnClick:(id)sender{
    if ( [delegate respondsToSelector:@selector(navigateBack:)] ) {
        [delegate navigateBack:nil];
    }
}

- (void)clearBtnClick:(id)sender{
    if ( [delegate respondsToSelector:@selector(clearFav)] ) {
        [delegate performSelector:@selector(clearFav)];
    }
}
- (void)dealloc{
    [titleLabel release];
    [backBtn release];
    [clearBtn release];
    
    [super dealloc];
}

@end
