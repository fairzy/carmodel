//
//  ImageObject.m
//  Carmodel
//
//  Created by fairzy fan on 12-3-25.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import "ImageObject.h"

@implementation ImageObject

@synthesize imageId;
@synthesize imageLink;
@synthesize imageSize;

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.imageId forKey:@"imageId"];
    [aCoder encodeObject:self.imageLink forKey:@"imageLink"];
    [aCoder encodeObject:self.imageSize forKey:@"imageSize"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if ( self = [super init] ) {
        self.imageId = [aDecoder decodeObjectForKey:@"imageId"];
        self.imageLink = [aDecoder decodeObjectForKey:@"imageLink"];
        self.imageSize = [aDecoder decodeObjectForKey:@"imageSize"];
    }
    
    return self;
}

- (void)initWithObject:(id)object{
    self.imageId = [object objectForKey:@"id"];
    self.imageSize = [object objectForKey:@"size"];
    self.imageLink = [object objectForKey:@"link"];
}

- (id)convertToObject{
    NSDictionary * theobj = [[NSDictionary alloc] initWithObjectsAndKeys:self.imageId, @"id", self.imageLink, @"link", self.imageSize, @"size", nil];    
    return [theobj autorelease]; 
}

-(void)dealloc{
    [imageId release];
    [imageSize release];
    [imageLink release];
    
    [super dealloc];
}

@end
