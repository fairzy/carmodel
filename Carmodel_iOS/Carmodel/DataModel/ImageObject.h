//
//  ImageObject.h
//  Carmodel
//
//  Created by fairzy fan on 12-3-25.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageObject : NSObject<NSCoding>{
    NSString * imageId;
    NSString * imageLink;
    NSString * imageSize;
}

@property (nonatomic, retain) NSString * imageId;
@property (nonatomic, retain) NSString * imageLink;
@property (nonatomic, retain) NSString * imageSize;

- (void)initWithObject:(id)object;
- (id)convertToObject;

@end
