//
//  URLImageView.m
//  Carmodel
//
//  Created by fairzy fan on 12-3-16.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import "URLImageView.h"
#import "ASIHTTPRequest.h"
#import "RegexKitLite.h"

@implementation URLImageView

@synthesize imageObject;
@synthesize delegate;
@synthesize theImageView;
@synthesize loadingIndicator;

- (id)initWithFrame:(CGRect)frame imageObj:(id)obj defaultImage:(NSString *)path lightBg:(BOOL)light
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if ( light ) {
            self.backgroundColor = [UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f];
        }else{
            self.backgroundColor = [UIColor colorWithRed:0.17f green:0.17f blue:0.17f alpha:1.0f];
        }
        self.imageObject = obj;
        // 菊花
        loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        CGRect indiframe = loadingIndicator.frame;
        indiframe.origin.x = (frame.size.width-indiframe.size.width)/2;
        indiframe.origin.y = (frame.size.height-indiframe.size.height)/2;
        [loadingIndicator setFrame:indiframe];
        loadingIndicator.hidesWhenStopped = YES;
        [self addSubview:loadingIndicator];
        // 图片
        UIImageView * imgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        if ( path ) {
            imgview.image = [UIImage imageNamed:path];
        }
        [self addSubview:imgview];
        self.theImageView = imgview;
        [imgview release];
        
//        UITapGestureRecognizer * tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self 
//                                                                                      action:@selector(imgClicked:)];
//        [self addGestureRecognizer:tapgesture];
//        [tapgesture release];
    }
    return self;
}

- (void)startLoadImage{
    NSLog(@"startloadimage");
    loadingIndicator.hidden = NO;
    [loadingIndicator startAnimating];
    
    [self performSelectorInBackground:@selector(downImage) withObject:nil];
    
    // 请求图片
//    NSString * imgurl = [imageObject objectForKey:@"link"];
//    NSURL *url = [NSURL URLWithString:imgurl];
//    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//    self.imageRequest = request;
//    [request setDelegate:self];
//    [request startAsynchronous];
}

- (void)downImage{
    NSAutoreleasePool * pool = [NSAutoreleasePool new];
    NSString * imgurl = [imageObject objectForKey:@"link"];
    NSURL *url = [NSURL URLWithString:imgurl];
    
    // 带缓存的哦
    NSString * homepath = NSHomeDirectory();
    NSString * cachedir = [homepath stringByAppendingPathComponent:@"/Library/Caches/ImageCache"];
    NSString * filename = [imgurl stringByReplacingOccurrencesOfRegex:@"/|:|&|=|\\?" withString:@"_"];
    NSString * filepath = [cachedir stringByAppendingPathComponent:filename];
    NSLog(@"cachename:%@", filepath);
    
    NSData * imgData = nil;
    NSFileManager * filemanager = [NSFileManager defaultManager];

    if ( [filemanager fileExistsAtPath:filepath] ) {
        NSLog(@"有缓存，读取");
        imgData = [NSData dataWithContentsOfFile:filepath];
        // 写入缓存
    }else{
        NSLog(@"无缓存，写入");
        imgData = [NSData dataWithContentsOfURL:url];
        // 创建dir
        if ( ![filemanager fileExistsAtPath:cachedir] ) {
            [filemanager createDirectoryAtPath:cachedir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        [imgData writeToFile:filepath atomically:YES];
    }
    
    UIImage * img = [UIImage imageWithData: imgData];
    theImageView.image = img;
    
    [pool release];
}

- (void)imgClicked:(UIGestureRecognizer *)gesture{
    NSLog(@"我点");
    if (delegate && [delegate respondsToSelector:@selector(imageClicked:)] ) {
        [delegate performSelector:@selector(imageClicked:) withObject:imageObject];
    }
}   

- (void)dealloc{
    NSLog(@"__%s__", __func__);
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [theImageView release];
    [loadingIndicator release];
    [imageObject release];
    
    [super dealloc];
}

@end
