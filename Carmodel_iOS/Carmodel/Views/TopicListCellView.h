//
//  TopicListCellView.h
//  Carmodel
//
//  Created by fairzy fan on 12-3-19.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TOPIC_CELL_HEIGHT 44

@interface TopicListCellView : UITableViewCell{
    UILabel * nameLabel;
}


@property (nonatomic, retain) UILabel * nameLabel;

@end
