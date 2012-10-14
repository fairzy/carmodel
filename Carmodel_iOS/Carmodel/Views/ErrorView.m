//
//  ErrorView.m
//  Carmodel
//
//  Created by fairzy fan on 12-3-19.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import "ErrorView.h"

@implementation ErrorView

- (id)initWithTitle:(NSString *)tit
{
    CGRect frame = CGRectMake(0, 60, 320, 100);
    self = [super initWithFrame:frame];
    if (self) {
        // 延时加载，错误提示界面
        UIImageView * smileimg = [[UIImageView alloc] initWithFrame:CGRectMake(133, 0, 54, 54)];
        smileimg.image = [UIImage imageNamed:@"image_fail_smile.png"];
        [self addSubview:smileimg];
        [smileimg release];
        
        UILabel * msg = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 320, 20)];
        msg.font = [UIFont systemFontOfSize:14.0f];
        msg.textColor = [UIColor whiteColor];
        msg.backgroundColor = [UIColor clearColor];
        msg.textAlignment = UITextAlignmentCenter;
        msg.text = tit;
        [self addSubview:msg];
        [msg release];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
