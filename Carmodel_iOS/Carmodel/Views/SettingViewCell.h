//
//  SettingViewCell.h
//  Carmodel
//
//  Created by fairzy fan on 12-3-17.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SETTING_CELL_HEIGHT 50

@interface SettingViewCell : UITableViewCell{
    UIImageView * iconViwe;
    UILabel * textLabel;
}

- (void)setIcon:(NSString *)filep title:(NSString *)_t;

@end
