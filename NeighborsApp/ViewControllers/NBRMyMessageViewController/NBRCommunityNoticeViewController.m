//
//  NBRCommunityNoticeViewController.m
//  NeighborsApp
//
//  Created by jason on 15/5/16.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRCommunityNoticeViewController.h"

@interface NBRCommunityNoticeViewController ()

@end

@implementation NBRCommunityNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"社区通知"];
    [self initSubView];
    [self CreateHeaderView];
    [self GetNoticeList];
    
}

#pragma mark Init Method
-(void) initSubView
{
    noticeArr = [[NSMutableArray alloc] init];
    
    myTableview =[[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kNBR_SCREEN_W, kNBR_SCREEN_H) style:UITableViewStyleGrouped];
    [myTableview setBackgroundView:nil];
    [myTableview setBackgroundColor:[UIColor clearColor]];
    [myTableview setDelegate:self];
    [myTableview setDataSource:self];
    [myTableview setRowHeight:70.0f];
    [self.view addSubview:myTableview];
    
}

-(void) GetNoticeList
{
    
}

-(void) CreateHeaderView
{
    UIView *headerview = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kNBR_SCREEN_W, 190.0f)];
    UIImageView *bgview = [[UIImageView alloc] initWithFrame:headerview.frame];
    [bgview setImage:[UIImage imageNamed:@"pic01"]];
    [headerview addSubview:bgview];
    
    UIView *contentbgview = [[UIView alloc] initWithFrame:CGRectMake(0.0f, headerview.frame.size.height-26.0f, kNBR_SCREEN_W, 26.0f)];
    [contentbgview setBackgroundColor:kNBR_ProjectColor_DeepBlack];
    [contentbgview setAlpha:0.7];
    [headerview addSubview:contentbgview];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, contentbgview.frame.origin.y, kNBR_SCREEN_W-20.0f, 26.0f)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:[UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:16.0f]];
    [titleLabel setTextColor:kNBR_ProjectColor_StandWhite];
    [headerview addSubview:titleLabel];
    [titleLabel setText:@"关于2015年03月15日停水通知"];

    [myTableview setTableHeaderView:headerview];
    
    
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [noticeArr count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ApplyCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    //头像
    EGOImageView *avterImgView = [[EGOImageView alloc] initWithPlaceholderImage: [UIImage imageNamed:@"t_avter_1"]];
    avterImgView.frame = CGRectMake(10.0f, 56 / 2.0f - 43 / 2.0f, 43, 43);
    avterImgView.layer.cornerRadius = avterImgView.frame.size.width / 2.0f;
    avterImgView.layer.masksToBounds = YES;
    [cell.contentView addSubview:avterImgView];
    avterImgView.tag = indexPath.row;
    [cell.contentView addSubview:avterImgView];
    
    
    UILabel *nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(65.0f, avterImgView.frame.origin.y, kNBR_SCREEN_W-100.0f-65.0f, 20.0f)];
    [nicknameLabel setBackgroundColor:[UIColor clearColor]];
    [nicknameLabel setFont:[UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:16.0f]];
    [nicknameLabel setTextColor:kNBR_ProjectColor_DeepGray];
    [nicknameLabel setText:noticeArr[indexPath.row]];
    [cell addSubview:nicknameLabel];
    
    UILabel *villagenameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nicknameLabel.frame.origin.x, nicknameLabel.frame.origin.y+nicknameLabel.frame.size.height, kNBR_SCREEN_W-100.0f-65.0f, 20.0f)];
    [villagenameLabel setBackgroundColor:[UIColor clearColor]];
    [villagenameLabel setFont:[UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:16.0f]];
    [villagenameLabel setTextColor:kNBR_ProjectColor_MidGray];
    [villagenameLabel setText:noticeArr[indexPath.row]];
    [cell.contentView addSubview:villagenameLabel];
    
    return cell;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
