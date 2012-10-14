//
//  CommentCellView.m
//  Carmodel
//
//  Created by fairzy fan on 12-3-31.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import "CommentCellView.h"

@implementation CommentCellView

@synthesize nameLabel;
@synthesize commentLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        for (id theview in self.subviews) {
            [theview removeFromSuperview];
        }
        
        UILabel * nl = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 250, 20)];
        nl.font = [UIFont systemFontOfSize:12.0f];
        nl.textColor = [UIColor darkTextColor];
        [self addSubview:nl];
        self.nameLabel = nl;
        [nl release];
        
        UILabel * tl = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 250, 20)];
        tl.font = [UIFont systemFontOfSize:13.0f];
        [self addSubview:tl];
        self.commentLabel = tl;
        [tl release];
    }
    return self;
}

- (void)setName:(NSString *)name andText:(NSString *)text{
    self.nameLabel.text = [NSString stringWithFormat:@"%@说道:", name];
    self.commentLabel.text = text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{
    [nameLabel release];
    [commentLabel release];
    
    [super dealloc];
}

@end
