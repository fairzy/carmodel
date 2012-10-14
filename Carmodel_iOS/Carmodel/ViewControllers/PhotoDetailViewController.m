//
//  PhotoDetailViewController.m
//  Carmodel
//
//  Created by fairzy fan on 12-3-20.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PhotoDetailViewController.h"
#import "JSONKit.h"
#import "ImageObject.h"
#import "MobClick.h"
#import "CommentCellView.h"
#import "iToast.h"

@implementation PhotoDetailViewController

@synthesize scrollView;
@synthesize imageView;
@synthesize imageObject;
@synthesize commentDataArray;
@synthesize tableView;
@synthesize commentView;
@synthesize likeBtn;
@synthesize favBtn;
@synthesize netRequest;
@synthesize commentRequest;

- (id)initwithImageObject:(id)obj{
    self = [super init];
    if ( self  ) {
        self.imageObject = obj;
        liked = NO;
        likeCount = 0;
    }
    return self;
}

#pragma mark - View lifecycle
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithRed:0.88f green:0.88f blue:0.88f alpha:1.0f];
    UIScrollView * sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, 320, 421)];
    sv.backgroundColor = [UIColor colorWithRed:0.88f green:0.88f blue:0.88f alpha:1.0f];
    [self.view addSubview:sv];
    self.scrollView = sv;
    [sv release];
    
    // 图片，要计算高度
    NSString * sizestr = [self.imageObject objectForKey:@"size"];
    NSArray * sizearray = [sizestr componentsSeparatedByString:@"x"];
    float width = [[sizearray objectAtIndex:0] floatValue];
    float height = [[sizearray objectAtIndex:1] floatValue];
    float trueheight = height/width * 300;
    float truewidth = 300;
    URLImageView * imgv = [[URLImageView alloc] initWithFrame:CGRectMake(10, 10, truewidth, trueheight) imageObj:self.imageObject defaultImage:nil lightBg:YES];
    [self.scrollView addSubview:imgv];
    self.imageView = imgv;
    [imgv release]; 
    
    float btnorgy = 10 + trueheight + 10;
    UIButton * likeb = [[UIButton alloc] initWithFrame:CGRectMake(10, btnorgy, 70, 30)];
    [likeb setBackgroundImage:[UIImage imageNamed:@"button_function.png"] forState:UIControlStateNormal];
    NSString * likestr = [NSString stringWithFormat:@"喜欢(%d)", 0];
    likeb.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [likeb setTitle:likestr forState:UIControlStateNormal];
    [likeb addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:likeb];
    self.likeBtn = likeb;
    [likeb release];
    
    UIButton * favb = [[UIButton alloc] initWithFrame:CGRectMake(85, btnorgy, 60, 30)];
    [favb setBackgroundImage:[UIImage imageNamed:@"button_function.png"] forState:UIControlStateNormal];
    [favb setTitle:@"收藏" forState:UIControlStateNormal];
    favb.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [favb addTarget:self action:@selector(favBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:favb];
    self.favBtn = favb;
    [favb release];
    
    // 评论按钮
    UIButton * commentbtn = [[UIButton alloc] initWithFrame:CGRectMake(250, btnorgy, 60, 30)];
    [commentbtn setBackgroundImage:[UIImage imageNamed:@"button_function.png"] forState:UIControlStateNormal];
    [commentbtn setTitle:@"评论" forState:UIControlStateNormal];
    [commentbtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    commentbtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.scrollView addSubview:commentbtn];
    [commentbtn release];
    
    float ctvorgy = btnorgy+35;
    UITableView * ctv = [[UITableView alloc] initWithFrame:CGRectMake(10, ctvorgy, 300, 40) style:UITableViewStylePlain];
    ctv.backgroundColor = [UIColor whiteColor];
    ctv.layer.cornerRadius = 5.0f;
    ctv.delegate = self;
    ctv.dataSource = self;
    ctv.scrollEnabled = NO;
    self.tableView = ctv;
    [self.scrollView addSubview:ctv];
    [ctv release];
    
    [self.scrollView setContentSize:CGSizeMake(320, ctvorgy+50)]; // btn.height+tabbar.height
    
    CommentView * cv = [[CommentView alloc] initWithFrame:CGRectMake(10, 10, 300, 190)];
    cv.layer.cornerRadius = 5.0f;
    cv.delegate = self;
    [self.view addSubview:cv];
    cv.hidden = YES;
    self.commentView = cv;
    [cv release];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    // 读取收藏列表
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:FAV_USER_DEFAULT_KEY];
    if ( data ) {
        NSArray * favarray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        for (ImageObject * oneimage in favarray) {
            if ( [oneimage.imageId intValue] == [[self.imageObject objectForKey:@"id"] intValue]  ) {
                NSLog(@"id:%d -- self:%d", [oneimage.imageId intValue], [[self.imageObject objectForKey:@"id"] intValue] );
                [self.favBtn setTitle:@"已收藏" forState:UIControlStateNormal]; 
                break;
            }
        }
    }else{
        NSLog(@"没有收藏");
    }
    
    [self.imageView startLoadImage];
    // 请求喜欢的人数
    [self requestLikeCount];
    // 请求评论列表
    [self requestComment];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 读取userdefaults查看是否已经喜欢过
    NSString * likeidstr = [[NSUserDefaults standardUserDefaults] objectForKey:LIKE_USER_DEFAULT_KEY];
    NSLog(@"likeidstr:%@", likeidstr);
    NSArray *ids =  [likeidstr componentsSeparatedByString:@","];
    if ( ids ) {
        for ( id aid  in ids) {
            if ( [aid intValue] == [[self.imageObject objectForKey:@"id"] intValue] ) {
                // 找到喜欢的了
                NSLog(@"找到喜欢的了");
                liked = YES;
                break;
            }
        }
    }
    
    // 处理自定义的navigationBar
    CustomRootViewController * tabc = (CustomRootViewController *)self.tabBarController;
    tabc.customNavBar.delegate = self;
    [tabc setCustomNavBarTitle:@"仔细看看"];
    [tabc setNavigateBarType:NavigateTypeBack];
    [tabc setCustomNavBarHide:NO];
    [tabc setCustomTabBarHidden:YES];
}

#pragma mark - method
- (void)requestLikeCount{
    int imageid = [[self.imageObject objectForKey:@"id"] intValue];
    NSString * urlstr = [NSString stringWithFormat:@"http://carmodel.sinaapp.com/api/image_likecount.php?image_id=%d", imageid];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlstr ]];
    [request setCompletionBlock:^{
//        int 
        id obj = [[request responseString] objectFromJSONString];
        int likec = [[obj objectForKey:@"like"] intValue];
        likeCount = likec;
        NSLog(@"喜欢次数:%d", likec);
        NSString * likestr = [NSString stringWithFormat:@"喜欢(%d)", likec];
        [likeBtn setTitle:likestr forState:UIControlStateNormal];
    }];
    [request startAsynchronous];
}

- (void)requestComment{
    int imageid = [[self.imageObject objectForKey:@"id"] intValue];
    NSString * urlstr = [NSString stringWithFormat:@"http://carmodel.sinaapp.com/api/image_commentlist.php?image_id=%d", imageid];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlstr ]];
    self.netRequest = request;
    request.delegate = self;
    [request startAsynchronous];
}

- (void)reloadView{
    [self.tableView reloadData];
    // 计算tableView高度
    float height = [commentDataArray count] * COMMENT_CELL_HEIGHT;
    CGRect tvframe = self.tableView.frame;
    tvframe.size.height = height;
    [self.tableView setFrame:tvframe];
    //
    [self.scrollView setContentSize:CGSizeMake(320, tvframe.origin.y+tvframe.size.height+20)];
    // 
    [self.tableView reloadData];
}

- (void)commentBtnClick:(id)sender{
    self.commentView.hidden = NO;
    [self.commentView.textView becomeFirstResponder];
    
    CustomRootViewController * tabc = (CustomRootViewController *)self.tabBarController;
    [tabc setCustomNavBarHide:YES];
    
    // umeng统计
    [MobClick event:@"CommentClick" label:[self.imageObject objectForKey:@"id"]];
}

- (void)likeBtnClick:(id)sender{
    NSLog(@"likebtnClick");
    if ( liked == YES ) {
        [[iToast makeText:@"已经喜欢过啦"] show];
        return;
    }else{
        NSString * imgid = [NSString stringWithFormat:@"%@", [self.imageObject objectForKey:@"id"]] ;
        NSString * urlstr = [NSString stringWithFormat:@"http://carmodel.sinaapp.com/api/like_image.php?image_id=%@", imgid];
        NSLog(@"urlstr:%@", urlstr);
        ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlstr]];
        [request startAsynchronous];
        [request setCompletionBlock:^{
            NSLog(@"responseStr:%@", [request responseString]);
            likeCount++;
            NSString * likestr = [NSString stringWithFormat:@"喜欢(%d)", likeCount];
            [likeBtn setTitle:likestr forState:UIControlStateNormal];
            // 写入userdefaults
            NSString * likeidstr = [[NSUserDefaults standardUserDefaults] objectForKey:LIKE_USER_DEFAULT_KEY];
            int objid = [[self.imageObject objectForKey:@"id"] intValue];
            if ( likeidstr  ) {
                likeidstr = [likeidstr stringByAppendingFormat:@",%d", objid];
            }else{
                likeidstr = [NSString stringWithFormat:@"%d", objid];
            }
            [[NSUserDefaults standardUserDefaults] setObject:likeidstr forKey:LIKE_USER_DEFAULT_KEY];
        } ];
        
        // umeng统计
        [MobClick event:@"LikeClick" label:[self.imageObject objectForKey:@"id"]];
        liked = YES;
    }
}

- (void)favBtnClick:(id)sender{
    NSLog(@"favBtnClick");
    if ( [[self.favBtn titleForState:UIControlStateNormal] isEqualToString:@"已收藏"] ) {
        return;
    }
    NSMutableArray * favarray = nil;
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:FAV_USER_DEFAULT_KEY];
    if ( data != nil ) {
        favarray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    // 转换为可存储的ImageObject
    ImageObject * obj = [[ImageObject alloc] init];
    [obj initWithObject:self.imageObject];
    
    if ( favarray == nil ) {
        NSLog(@"没有吖");
        favarray = [NSMutableArray arrayWithObject:obj];
    }else{
        NSLog(@"有吖,个数:%d", [favarray count]);
        [favarray addObject:obj];
    }
    NSLog(@"saveArray:%@", favarray);
    NSData * saveData = [NSKeyedArchiver archivedDataWithRootObject:favarray];
    [[NSUserDefaults standardUserDefaults] setObject:saveData forKey:FAV_USER_DEFAULT_KEY];
    // 按钮文字
    [self.favBtn setTitle:@"已收藏" forState:UIControlStateNormal];
    [obj release];
    
    // umeng统计
    [MobClick event:@"FavouriteClick" label:[self.imageObject objectForKey:@"id"]];
}

#pragma mark - 评论
- (void)commentCancel{
    CustomRootViewController * tabc = (CustomRootViewController *)self.tabBarController;
    [tabc setCustomNavBarHide:NO];
    
    NSLog(@"delegate取消评论");
    self.commentView.hidden = YES;
}

- (void)commentConfirm:(NSString *)str{
    CustomRootViewController * tabc = (CustomRootViewController *)self.tabBarController;
    [tabc setCustomNavBarHide:NO];
    
    NSLog(@"delegate确认评论");
    self.commentView.hidden = YES;
    
    NSString * urlstr = @"http://carmodel.sinaapp.com/api/comment_image.php";
    NSString * imgid = [NSString stringWithFormat:@"%@", [self.imageObject objectForKey:@"id"]] ;
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlstr]];
    self.commentRequest = request;
    [request setPostValue:str forKey:@"text"];
    [request setPostValue:imgid forKey:@"image_id"];
    [request setCompletionBlock:^{
        // Use when fetching text data
        //NSString *responseString = [request responseString];
        [self requestComment];
    }];
    [request setFailedBlock:^{
        //NSError *error = [request error];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"提交评论评论失败,请重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }];
    [request startAsynchronous];
}

#pragma mark ASIHttpRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString * responstr = [request responseString];
    NSLog(@"response str:%@", responstr);
    id objs = [responstr objectFromJSONString];
    if ( objs && [objs isKindOfClass:[NSArray class]] ) {
        self.commentDataArray = [NSArray arrayWithArray:objs];
        [self reloadView];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request{
//    NSError * error = [request error];
//    NSString * errorstr = [NSString stringWithFormat:@"error:%@,%@", error.description, error.userInfo];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请求失败, 请重试" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return COMMENT_CELL_HEIGHT;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section{
    if ( commentDataArray == nil ) {
        return 0;
    }else{
        return [commentDataArray count];
    }
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = [indexPath row];
    NSString * cellId = @"CommentCellId";
    UITableViewCell * cell = [tv dequeueReusableCellWithIdentifier:cellId];
    if ( cell == nil ) {
        cell = [[[CommentCellView alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    id onecomment = [commentDataArray objectAtIndex:row];
    [((CommentCellView *)cell) setName:[onecomment objectForKey:@"username"] andText:[onecomment objectForKey:@"text"]];
//    cell.textLabel.text = [onecomment objectForKey:@"username"];
//    NSLog(@"text:%@", cell.textLabel.text);
//    cell.detailTextLabel.text = [onecomment objectForKey:@"text"];
//    NSLog(@"text:%@", cell.detailTextLabel.text);
    return cell;
}


#pragma mark CustomNavigationBarDelegate
- (void)navigateBack:(id)sender{
    NSLog(@"photo detail navigate back");
    // pop
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - memeory

- (void)viewDidUnload
{
    NSLog(@"%s", __func__);
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.scrollView = nil;
    self.imageView = nil;
    self.tableView = nil;
   
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc{
    NSLog(@"photo detail dealloc");
    NSLog(@"%s", __func__);
    [self.netRequest clearDelegatesAndCancel];
    [self.commentRequest clearDelegatesAndCancel];
    [netRequest release];
    [commentRequest release];
    [scrollView release];
    [imageView release];
    [imageObject release];
    [tableView release];
    [favBtn release];
    [likeBtn release];
    [commentView release];
    [commentDataArray release];
    [super dealloc];
}

@end
