//
//  PhotoScrollView.h
//  Carmodel
//
//  Created by fairzy fan on 12-3-20.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoScrollView : UIScrollView{

    
    float leftheight;
    float rightheight;
    id responder;
}

@property (nonatomic, assign) id responder;

- (void)loadImages:(NSArray *)imgArray;
- (void)clearImages;

@end
