//
//  NBRCommunityNoticeViewController.m
//  NeighborsApp
//
//  Created by jason on 15/5/16.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRCommunityNoticeViewController.h"
#import "NBRNoticeDetailViewController.h"

#import "CreaterRequest_Notice.h"


@interface NBRCommunityNoticeViewController ()

@end

@implementation NBRCommunityNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"社区通知"];
    currentindx = 1;
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
    noticeReq = [CreaterRequest_Notice CreateListRequestWithIndex:[NSString stringWithFormat:@"%d",currentindx] size:@"20" flag:@"1"];
    __weak ASIHTTPRequest *selfblock = noticeReq;
    [selfblock setCompletionBlock:^{
        NSDictionary *reponseDict = selfblock.responseString.JSONValue;
        [self removeLoadingView];
        
        if ([CreaterRequest_Notice CheckErrorResponse:reponseDict errorAlertInViewController:self])
        {
            [self showBannerMsgWithString:[reponseDict stringWithKeyPath:@"data\\code\\message"]];
            noticeArr = (NSMutableArray *)[reponseDict arrayWithKeyPath:@"data\\result\\data"];
            [myTableview reloadData];
            
        }
    }];
    
    [self setDefaultRequestFaild:selfblock];
    
    [self addLoadingView];
    [noticeReq startAsynchronous];
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
    
    
    NSMutableDictionary *subdic = noticeArr[indexPath.row];
    
    //头像
    EGOImageView *avterImgView = [[EGOImageView alloc] initWithPlaceholderImage: [UIImage imageNamed:@"t_avter_1"]];
    avterImgView.frame = CGRectMake(kNBR_SCREEN_W-80.0f, 70 / 2.0f - 54 / 2.0f,54,54);
    avterImgView.layer.cornerRadius = avterImgView.frame.size.width / 2.0f;
    avterImgView.layer.masksToBounds = YES;
    [cell.contentView addSubview:avterImgView];
    avterImgView.tag = indexPath.row;
    [cell.contentView addSubview:avterImgView];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, avterImgView.frame.origin.y+5.0f, kNBR_SCREEN_W-90.0f, 20.0f)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:[UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:16.0f]];
    [titleLabel setTextColor:kNBR_ProjectColor_DeepGray];
    [titleLabel setText:subdic[@"title"]];
    [titleLabel setNumberOfLines:0];
    [titleLabel sizeToFit];
    [cell addSubview:titleLabel];
    
    UILabel *timelabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y+titleLabel.frame.size.height+5.0f, kNBR_SCREEN_W-90, 20.0f)];
    [timelabel setBackgroundColor:[UIColor clearColor]];
    [timelabel setFont:[UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:16.0f]];
    [timelabel setTextColor:kNBR_ProjectColor_MidGray];
    [timelabel setText:subdic[@"created"]];
    [cell.contentView addSubview:timelabel];
    
    return cell;
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NBRNoticeDetailViewController *detailview = [[NBRNoticeDetailViewController alloc] init];
    [self.navigationController pushViewController:detailview animated:YES];
    
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
