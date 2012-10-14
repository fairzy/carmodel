//
//  MoreViewController.m
//  Carmodel
//
//  Created by fairzy fan on 12-3-14.
//  Copyright (c) 2012年 PConline. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MoreViewController.h"
#import "SettingViewCell.h"
#import "CustomRootViewController.h"
#import "MobClick.h"
#import "OtherViewController.h"

@implementation MoreViewController

- (void)loadView{
    [super loadView];
    self.view.backgroundColor = [UIColor grayColor];
    UITableView * tv = [[UITableView alloc] initWithFrame:CGRectMake(5, 50, 310, 249) style:UITableViewStylePlain];
    tv.backgroundColor = [UIColor colorWithRed:0.88f green:0.88f blue:0.88f alpha:1.0f];
    tv.scrollEnabled = NO;
    tv.delegate = self;
    tv.dataSource = self;
    [self.view addSubview:tv];
    tv.layer.cornerRadius = 5;
    tv.layer.masksToBounds = YES;
    [tv release];
    // ad
    UILabel * grouptitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 305, 300, 20)];
    grouptitle.textColor = [UIColor whiteColor];
    grouptitle.backgroundColor = [UIColor clearColor];
    grouptitle.text = @"(AD)互助互撸,互撸娃应用推荐:";
    grouptitle.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:grouptitle];
    [grouptitle release];
    
    UIView * appcontainer = [[UIView alloc] initWithFrame:CGRectMake(5, 330, 310, 60)];
    appcontainer.backgroundColor = [UIColor colorWithRed:0.88f green:0.88f blue:0.88f alpha:1.0f]; 
    appcontainer.layer.cornerRadius = 5;
    appcontainer.layer.masksToBounds = YES;
    
    UIImageView *app43btn = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
    app43btn.image = [UIImage imageNamed:@"more_recommand_app43.png"];
    [appcontainer addSubview:app43btn];
    [app43btn release];
    //
    UILabel * app43title = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 250, 50)];
    app43title.backgroundColor = [UIColor clearColor];
    app43title.text = @"应用中心\n每天为你推荐各种应用，各种限免信息,赶走寂寞,开启健康向上的无左手生活.";
    app43title.font = [UIFont systemFontOfSize:12.0f];
    app43title.numberOfLines = 0;
    [appcontainer addSubview:app43title];
    [app43title release];
//    UIButton *lutubtn = [[UIButton alloc] initWithFrame:CGRectMake(60, 5, 50, 50)];
//    [lutubtn setImage:[UIImage imageNamed:@"more_recommand_lutu.png"] forState:UIControlStateNormal];
//    [appcontainer addSubview:lutubtn];
//    [lutubtn release];
//    // 
//    UILabel * lututitle = [[UILabel alloc] initWithFrame:CGRectMake(65, 55, 50, 20)];
//    lututitle.backgroundColor = [UIColor clearColor];
//    lututitle.text = @"路图(微博)";
//    lututitle.font = [UIFont systemFontOfSize:12.0f];
//    [appcontainer addSubview:lututitle];
    
    [self.view addSubview:appcontainer];
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adClick:)];
    [appcontainer addGestureRecognizer:gesture];
    [gesture release];
    [appcontainer release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 处理navigationbar
    CustomRootViewController * tabc = (CustomRootViewController *)self.tabBarController;
    [tabc setCustomNavBarTitle:@"各种"];
    [tabc setNavigateBarType:NavigateTypeNormal];
    [tabc setCustomTabBarHidden:NO];
}

- (void)adClick:(UIGestureRecognizer *)gesture{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/cn/app/ying-yong-zhong-xin/id516943189?mt=8"]];
    // umgne tongji
    [MobClick event:@"AdClick" label:@"app43"];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SETTING_CELL_HEIGHT;
}


- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tv deselectRowAtIndexPath:indexPath animated:YES];
    int row = [indexPath row];
    
    if ( row == 3 ) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"确认" message:@"确认清除缓存?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];;
        [alert show];
        [alert release];
    }else if( row == 1 ){
        [MobClick showFeedback:self];
    }else if( row == 0 ){
        OtherViewController * othervc = [[OtherViewController alloc] initWhitVCType:VCTypeHelp];
        [self presentModalViewController:othervc animated:YES];
        [othervc release];
        
        [MobClick event:@"HelpClick"];
    }else if( row == 2 ){
        OtherViewController * othervc = [[OtherViewController alloc] initWhitVCType:VCTypeAbout];
        [self presentModalViewController:othervc animated:YES];
        [othervc release];
        
        [MobClick event:@"AboutClick"];
    }else if( row == 4 ){
        NSString * url = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=516943189";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

#pragma makr UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = [indexPath row];
    NSString * cellId = @"MoreCellId";
    UITableViewCell * cell = [tv dequeueReusableCellWithIdentifier:cellId];
    if ( cell == nil ) {
        cell = [[[SettingViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    switch ( row ) {
        case 0:
            [((SettingViewCell *)cell) setIcon:@"image_more_icon_help.png" title:@"互撸互助"];
            break;
        case 1:
            [((SettingViewCell *)cell) setIcon:@"image_more_icon_feedback.png" title:@"反馈"];
            break;
        case 2:
            [((SettingViewCell *)cell) setIcon:@"image_more_icon_about.png" title:@"你和我"];
            break;
        case 3:
            [((SettingViewCell *)cell) setIcon:@"image_more_icon_clear_cache.png" title:@"清除缓存"];
            break;
        case 4:
            [((SettingViewCell *)cell) setIcon:@"image_more_icon_praise.png" title:@"GC了!好评!"];
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ( buttonIndex == 1 ) {
        NSString * homepath = NSHomeDirectory();
        NSString * cachedir = [homepath stringByAppendingPathComponent:@"/Library/Caches/ImageCache"];
        [[NSFileManager defaultManager] removeItemAtPath:cachedir error:nil];
    }
}

#pragma mark - memory
- (void)viewDidUnload
{
    NSLog(@"%s", __func__);
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc{
    NSLog(@"%s", __func__);
    [super dealloc];
}

@end
