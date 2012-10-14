//
//  URLImageView.h
//  Carmodel
//
//  Created by fairzy fan on 12-3-16.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface URLImageView : UIView<ASIHTTPRequestDelegate>{
    UIImageView * theImageView;
    UIActivityIndicatorView * loadingIndicator;
        
    id delegate;
    id imageObject;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) id imageObject;
@property (nonatomic, retain) UIImageView * theImageView;
@property (nonatomic, retain) UIActivityIndicatorView * loadingIndicator;


- (id)initWithFrame:(CGRect)frame imageObj:(id)obj defaultImage:(NSString *)path lightBg:(BOOL)light;
- (void)startLoadImage;
- (void)downImage;
@end
