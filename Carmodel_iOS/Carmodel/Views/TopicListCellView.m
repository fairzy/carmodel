//
//  TopicListCellView.m
//  Carmodel
//
//  Created by fairzy fan on 12-3-19.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import "TopicListCellView.h"

@implementation TopicListCellView

@synthesize nameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        for (id theview in self.subviews) {
            [theview removeFromSuperview];
        }
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 11, 200, 20)];
        label.font = [UIFont systemFontOfSize:13.0f];
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
        self.nameLabel = label;
        [label release];
        
        // seperator
        UIImageView * sepimg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 42, 320, 2)];
        sepimg.image = [UIImage imageNamed:@"cell_separator_line.png"];
        [self addSubview:sepimg];
        [sepimg release];
        
        // select bg view
        UIView * selbgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, TOPIC_CELL_HEIGHT)];
        selbgview.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.0f];
        self.selectedBackgroundView = selbgview;
        [selbgview release]; 
        
    }
    return self;
}

//http://image.baidu.com/i?ct=201326592&cl=2&lm=-1&st=-1&tn=baiduimage&istype=2&fm=index&pv=&z=0&word=shoushou&s=0
//http://image.baidu.com/i?ct=201326592&cl=2&lm=-1&st=-1&tn=baiduimage&istype=2&fm=index&pv=&z=0&word=shoushou&s=0#z=2&width=&height=&pn=0

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{
    NSLog(@"namelabel:%@", nameLabel);
    [nameLabel release];
    
    [super dealloc];
}

@end
