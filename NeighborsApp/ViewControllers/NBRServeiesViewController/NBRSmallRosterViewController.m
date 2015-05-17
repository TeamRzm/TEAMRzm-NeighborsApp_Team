//
//  NBRSmallRosterViewController.m
//  NeighborsApp
//
//  Created by jason on 15/5/17.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRSmallRosterViewController.h"
#import "CreateRequest_Server.h"
#import "NBRFriendInfoViewController.h"


@interface NBRSmallRosterViewController ()

@end

@implementation NBRSmallRosterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"花名册"];
    
    [self initSubView];
    
}

#pragma mark Init Method
-(void) initSubView
{
    memberArr = [[NSMutableArray alloc] init];
    
    myTableview =[[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kNBR_SCREEN_W, kNBR_SCREEN_H) style:UITableViewStyleGrouped];
    [myTableview setBackgroundView:nil];
    [myTableview setBackgroundColor:[UIColor clearColor]];
    [myTableview setDelegate:self];
    [myTableview setDataSource:self];
    [myTableview setRowHeight:56.0f];
    [self.view addSubview:myTableview];
    
    
    [self GetMemberInfo];
    
    
}

-(void) GetMemberInfo
{
    memberinfoReq = [CreateRequest_Server CreateSmallRosterInfoList];
    __weak ASIHTTPRequest *selfblock = memberinfoReq;
    [selfblock setCompletionBlock:^{
        NSDictionary *reponseDict = selfblock.responseString.JSONValue;
        [self removeLoadingView];
        
        if ([CreateRequest_Server CheckErrorResponse:reponseDict errorAlertInViewController:self])
        {
            memberArr = (NSMutableArray *)[reponseDict arrayWithKeyPath:@"data\\result"];
            [myTableview reloadData];
            
        }
    }];
    
    [self addLoadingView];
    [memberinfoReq startAsynchronous];
}


#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [memberArr count];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [memberArr[section][@"members"] count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSMutableDictionary *subdic = memberArr[indexPath.section][@"members"][indexPath.row];
    NSLog(@"subdic ==%@",subdic);
    
    //头像
    EGOImageView *avterImgView = [[EGOImageView alloc] initWithPlaceholderImage: [UIImage imageNamed:@"defaultAvater"]];
    avterImgView.frame = CGRectMake(10.0f, 56 / 2.0f - 43 / 2.0f, 43, 43);
    avterImgView.layer.cornerRadius = avterImgView.frame.size.width / 2.0f;
    avterImgView.layer.masksToBounds = YES;
    [cell.contentView addSubview:avterImgView];
    
    //联系人
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(68.0f,
                                                                    10,
                                                                    kNBR_SCREEN_W - 68.0f - 10,
                                                                    20.0f)];
    titleLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:15.0f];
    titleLable.textColor = kNBR_ProjectColor_DeepGray;
    titleLable.text = subdic[@"linkman"];
    //电话
    
    UILabel *phoneLable = [[UILabel alloc] initWithFrame:CGRectMake(68.0f,
                                                                    titleLable.frame.origin.y+20.0f,
                                                                    kNBR_SCREEN_W - 68.0f - 10,
                                                                    20.0f)];
    phoneLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:15.0f];
    phoneLable.textColor = kNBR_ProjectColor_MidGray;
    phoneLable.text = subdic[@"phone"];
    
//     职位
    UILabel *dutyLable = [[UILabel alloc] initWithFrame:CGRectMake(kNBR_SCREEN_W-68.0f,
                                                                    titleLable.frame.origin.y,
                                                                     68.0f - 10,
                                                                    20.0f)];
    dutyLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:15.0f];
    dutyLable.textColor = kNBR_ProjectColor_MidGray;
    dutyLable.text = subdic[@"duty"];

    
    [cell.contentView addSubview:avterImgView];
    [cell.contentView addSubview:titleLable];
    [cell.contentView addSubview:phoneLable];
    [cell.contentView addSubview:dutyLable];
    
    return cell;
    
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerview = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kNBR_SCREEN_W, 30.0f)];
    NSMutableDictionary *subdic = memberArr[section];
    
    //名称
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f,
                                                                    0.0f,
                                                                    kNBR_SCREEN_W - 68.0f - 10,
                                                                    30.0f)];
    nameLabel.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:15.0f];
    nameLabel.textColor = kNBR_ProjectColor_DeepGray;
    nameLabel.text = subdic[@"name"];
    
    //     人数
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(kNBR_SCREEN_W-68.0f,
                                                                   0.0f,
                                                                   68.0f - 10,
                                                                   30.0f)];
    countLabel.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:15.0f];
    countLabel.textColor = kNBR_ProjectColor_DeepGray;
    countLabel.text = [NSString stringWithFormat:@"%d人",[subdic[@"members"] count]];
    countLabel.textAlignment = NSTextAlignmentRight;
    [headerview addSubview:nameLabel];
    [headerview addSubview:countLabel];
    
    return headerview;

}

-(float) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

-(float) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *subdic = memberArr[indexPath.section][@"members"][indexPath.row];
    NSLog(@"subdic ==%@",subdic);
    NBRFriendInfoViewController *infoview = [[NBRFriendInfoViewController alloc] init];
    [self.navigationController pushViewController:infoview animated:YES];
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
