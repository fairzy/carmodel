//
//  CommentView.h
//  Carmodel
//
//  Created by fairzy fan on 12-3-23.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentView : UIView{
    id delegate;
    
    UITextView * textView;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) UITextView * textView;

@end
