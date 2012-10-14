//
//  CategoryCellViewCell.h
//  Carmodel
//
//  Created by fairzy fan on 12-3-16.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CATE_CELL_HEIGHT 70

@interface CategoryCellViewCell : UITableViewCell{
    UIImageView * iconImageView;
    UILabel * titleLabel;
}

@property (nonatomic, retain) UIImageView * iconImageView;
@property (nonatomic, retain) UILabel * titleLabel;

- (void)setCellIcon:(NSString *)path title:(NSString *)title;

@end
