//
//  PhotoScrollView.m
//  Carmodel
//
//  Created by fairzy fan on 12-3-20.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import "PhotoScrollView.h"
#import "URLImageView.h"
#import <QuartzCore/QuartzCore.h>

#define  VIEW_START_TAG 100

@implementation PhotoScrollView

@synthesize responder;


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if ( self ) {
        // 
        leftheight = 0;
        rightheight = 0;
    }
    
    return self;
}

- (void)clearImages{
    for (id subview in self.subviews) {
        if( [subview isKindOfClass:[URLImageView class]] ){
            [subview removeFromSuperview];
        }
    }
    leftheight = 0;
    rightheight = 0;
    [self setContentSize:self.frame.size];
}

- (void)loadImages:(NSArray *)imgArray{
    // 一页有30条数据, 开始load currentPage
    // 左边一行
    for (int i=0; i < [imgArray count]; i++) {
        // __block__
        id imgobj = [imgArray objectAtIndex:i];
        NSString * sizestr = [imgobj objectForKey:@"size"];
        NSArray * sizearray = [sizestr componentsSeparatedByString:@"x"];
        float width = [[sizearray objectAtIndex:0] floatValue];
        float height = [[sizearray objectAtIndex:1] floatValue];
        float trueheight = height/width * 160;
        float truewidth = 160;
        // __block__
        
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked:)];
        // 左边
        if ( i%2 == 0 ) {
            NSLog(@"%d - left", i);
            CGRect aframe = CGRectMake(0, leftheight+1, truewidth, trueheight);
            URLImageView * aimageview = [[URLImageView alloc] initWithFrame:aframe imageObj:imgobj defaultImage:nil lightBg:YES];
            [self addSubview:aimageview];
            aimageview.tag = VIEW_START_TAG + i;
            [aimageview addGestureRecognizer:gesture];
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
            [self addSubview:aimageview];
            aimageview.tag = VIEW_START_TAG + i;
            [aimageview addGestureRecognizer:gesture];
            aimageview.layer.borderColor = [[UIColor blackColor] CGColor];
            aimageview.layer.borderWidth = 1.0f;
            [aimageview startLoadImage];
            [aimageview release];
            //
            rightheight += trueheight+2;
        }
        [gesture release];
    }
    // 调整加载更多btn的位置
    float conentheight = leftheight>rightheight?leftheight:rightheight;

    [self setContentSize:CGSizeMake(self.frame.size.width, conentheight+130)]; // btn.height+tabbar.height
}

- (void)imageClicked:(UIGestureRecognizer *)gesture{
    int i = gesture.view.tag - VIEW_START_TAG;
    
    if ( [responder respondsToSelector:@selector(imageClicked:)] ) {
        [responder imageClicked:i];
    }
}

- (void)dealloc{
    NSLog(@"%s", __func__);
    [super dealloc];
}

@end
