//
//  SettingViewCell.m
//  Carmodel
//
//  Created by fairzy fan on 12-3-17.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import "SettingViewCell.h"

@implementation SettingViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        for (id theview in self.subviews) {
            [theview removeFromSuperview];
        }
        // 
        iconViwe = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 32, 32)];
        [self addSubview:iconViwe];
        
        // 
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, 200, 20)];
        textLabel.font = [UIFont systemFontOfSize:12.0f];
        textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:textLabel];
        
        // seperator
        UIImageView * sepimg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 48, 320, 2)];
        sepimg.image = [UIImage imageNamed:@"cell_separator_line.png"];
        [self addSubview:sepimg];
        [sepimg release];
        
        // select bg view
        UIView * selbgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, SETTING_CELL_HEIGHT)];
        selbgview.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.0f];
        self.selectedBackgroundView = selbgview;
        [selbgview release];
        
    }
    return self;
}

- (void)setIcon:(NSString *)filep title:(NSString *)_t{
    iconViwe.image = [UIImage imageNamed:filep];
    textLabel.text = _t;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{
    [iconViwe release];
    [textLabel release];
    
    [super dealloc];
}

@end
