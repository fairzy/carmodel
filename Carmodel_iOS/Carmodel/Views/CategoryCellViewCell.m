//
//  CategoryCellViewCell.m
//  Carmodel
//
//  Created by fairzy fan on 12-3-16.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import "CategoryCellViewCell.h"

@implementation CategoryCellViewCell

@synthesize iconImageView;
@synthesize titleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        for (id theview in self.subviews) {
            [theview removeFromSuperview];
        }
        // Initialization code
        UIImageView * iconbg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"category_icon_bg.png"]];
        iconbg.frame = CGRectMake(5, 5, 60, 60);
        [self addSubview:iconbg];
        [iconbg release];
        // icon
        UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 46, 38)];
        [self addSubview:icon];
        self.iconImageView = icon;
        [icon release];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(70, 25, 200, 20)];
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
        self.titleLabel = label;
        [label release];
        
        // seperator
        UIImageView * sepimg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 69, 320, 2)];
        sepimg.image = [UIImage imageNamed:@"cell_separator_line.png"];
        [self addSubview:sepimg];
        [sepimg release];
        
        // select bg view
        UIView * selbgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, CATE_CELL_HEIGHT)];
        selbgview.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.0f];
        self.selectedBackgroundView = selbgview;
        [selbgview release];
    }
    return self;
}

- (void)setCellIcon:(NSString *)path title:(NSString *)title{
    self.iconImageView.image = [UIImage imageNamed:path];
    self.titleLabel.text = title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

- (void)dealloc{
    [iconImageView release];
    [titleLabel release];
    
    [super dealloc];
}

@end
