//
//  CommentCellView.h
//  Carmodel
//
//  Created by fairzy fan on 12-3-31.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import <UIKit/UIKit.h>

#define COMMENT_CELL_HEIGHT 50

@interface CommentCellView : UITableViewCell{
    UILabel * nameLabel;
    UILabel * commentLabel;
}

@property (nonatomic, retain) UILabel * nameLabel;
@property (nonatomic, retain) UILabel * commentLabel;

- (void)setName:(NSString *)name andText:(NSString *)text;

@end
