//
//  CommentView.m
//  Carmodel
//
//  Created by fairzy fan on 12-3-23.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import "CommentView.h"

@implementation CommentView

@synthesize delegate;
@synthesize textView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor blackColor];
        // Initialization code
        UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 45)];
        titleView.backgroundColor = [UIColor blackColor];
        titleView.text = @"评论";
        titleView.textAlignment = UITextAlignmentCenter;
        titleView.textColor = [UIColor whiteColor];
        [self addSubview:titleView];
        [titleView release];
        
        // 输入框
        UITextView * tv = [[UITextView alloc] initWithFrame:CGRectMake(5, 45, 290, 100)];
        [tv setFont:[UIFont systemFontOfSize:14.0f]];
        [self addSubview:tv];
        self.textView = tv;
        [tv release];
        
        // 分割线
        UIView * sepview = [[UIView alloc] initWithFrame:CGRectMake(140, 145, 20, 44)];
        sepview.backgroundColor = [UIColor whiteColor];
        [self addSubview:sepview];
        [sepview release];
        
        UIButton * cancelbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 145, 150, 44)];
        cancelbtn.backgroundColor = [UIColor blackColor];
        [cancelbtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelbtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelbtn];
        [cancelbtn release];
        
        UIButton * confirmbtn = [[UIButton alloc] initWithFrame:CGRectMake(151, 145, 150, 44)];
        confirmbtn.backgroundColor = [UIColor blackColor];
        [confirmbtn setTitle:@"确认" forState:UIControlStateNormal];
        [confirmbtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:confirmbtn];
        [confirmbtn release];
        
        
    }
    return self;
}

- (void)cancelBtnClick:(id)sender{
    NSLog(@"取消点了");
    [self.textView resignFirstResponder];
    
    if ( [delegate respondsToSelector:@selector(commentCancel)] ) {
        [delegate performSelector:@selector(commentCancel)];
    }
}

- (void)confirmBtnClick:(id)sender{
    NSString * str = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"确认点了:%@", str);
    if( str.length == 0 ){
        return;
    }
    [self.textView resignFirstResponder];
    if ( [delegate respondsToSelector:@selector(commentConfirm:)] ) {
        [delegate performSelector:@selector(commentConfirm:) withObject:str];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc{
    [textView release];
    
    [super dealloc];
}

@end
