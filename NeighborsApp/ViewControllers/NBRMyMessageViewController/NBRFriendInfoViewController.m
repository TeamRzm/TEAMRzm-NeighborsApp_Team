//
//  NBRFriendInfoViewController.m
//  NeighborsApp
//
//  Created by jason on 15/5/16.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRFriendInfoViewController.h"
#import "EGOImageView.h"


@interface NBRFriendInfoViewController ()

@end

@implementation NBRFriendInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"详细资料"];
    leftArr = [[NSMutableArray alloc] initWithObjects:@"所在小区",@"个性签名",@"个人爱好", nil];
    rightArr = [[NSMutableArray alloc] initWithObjects:@"新家园小区",@"新年新气象，快乐生活每一天",@"游泳，爬山，电影", nil];
    myTableview =[[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kNBR_SCREEN_W, kNBR_SCREEN_H) style:UITableViewStylePlain];
    [myTableview setBackgroundView:nil];
    [myTableview setBackgroundColor:[UIColor clearColor]];
    [myTableview setDelegate:self];
    [myTableview setDataSource:self];
    [self.view addSubview:myTableview];
    
    [self CreateHeaderView];
    [self CreateFooterView];
    
    UIImageView *bottomview = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, kNBR_SCREEN_H-154.0f, kNBR_SCREEN_W, 154.0f)];
    [bottomview setImage:[UIImage imageNamed:@"bg02.jpg"]];
    [self.view addSubview:bottomview];
    
    
    
}

#pragma mark Header and Footer View
-(void) CreateHeaderView
{
    UIView *headerbgview = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kNBR_SCREEN_W, 96.0f)];
    [headerbgview setBackgroundColor:[UIColor clearColor]];
    
    UIView *headerview = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kNBR_SCREEN_W, 76.0f)];
    [headerview setBackgroundColor:kNBR_ProjectColor_StandWhite];
    [headerbgview addSubview:headerview];
    
    //头像
    EGOImageView *avterImgView = [[EGOImageView alloc] initWithPlaceholderImage: [UIImage imageNamed:@"t_avter_1"]];
    avterImgView.frame = CGRectMake(10.0f, 76 / 2.0f - 50 / 2.0f, 50.0f, 50.0f);
    avterImgView.layer.cornerRadius = avterImgView.frame.size.width / 2.0f;
    avterImgView.layer.masksToBounds = YES;
    [headerview addSubview:avterImgView];
    
    //用户昵称
    UILabel *nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(avterImgView.frame.origin.x+avterImgView.frame.size.width+10.0f, avterImgView.frame.origin.y, 100.0f, 30.0f)];
    [nicknameLabel setBackgroundColor:[UIColor clearColor]];
    [nicknameLabel setFont:[UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:16.0f]];
    [nicknameLabel setTextColor:kNBR_ProjectColor_DeepGray];
    [nicknameLabel setText:@"左邻"];
    [nicknameLabel sizeToFit];
    [nicknameLabel setFrame:CGRectMake(nicknameLabel.frame.origin.x, nicknameLabel.frame.origin.y, nicknameLabel.frame.size.width, 30.0f)];
    [headerview addSubview:nicknameLabel];
    
    //用户性别
    UIImageView *sexImgview = [[UIImageView alloc] initWithFrame:CGRectMake(nicknameLabel.frame.origin.x+nicknameLabel.frame.size.width+10.0f, nicknameLabel.frame.origin.y+9, 25.0/2, 27.0/2)];
    [sexImgview setImage:[UIImage imageNamed:@"nan"]];
    [headerview addSubview:sexImgview];
    
    
//    用户小区信息
    UILabel *floorLabel = [[UILabel alloc] initWithFrame:CGRectMake(nicknameLabel.frame.origin.x, nicknameLabel.frame.origin.y+nicknameLabel.frame.size.height, kNBR_SCREEN_W-70.0f, 30.0f)];
    [floorLabel setBackgroundColor:[UIColor clearColor]];
    [floorLabel setFont:[UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:16.0f]];
    [floorLabel setTextColor:kNBR_ProjectColor_MidGray];
    [floorLabel setText:@"1-502"];
    [headerview addSubview:floorLabel];
    
    [myTableview setTableHeaderView:headerbgview];
}

-(void) CreateFooterView
{
    UIView *footerview = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kNBR_SCREEN_W, 76.0f)];
    [footerview setBackgroundColor:[UIColor clearColor]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(10.0f, 20.0f, kNBR_SCREEN_W-20.0f, 40.0f)];
    [button setTintColor:kNBR_ProjectColor_StandWhite];
    [button setBackgroundColor:kNBR_ProjectColor_StandBlue];
    [button.layer setCornerRadius:4.0];
    [button.layer setMasksToBounds:YES];
    [button setTitle:@"申请加为邻居" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(AddToFriend) forControlEvents:UIControlEventTouchUpInside];
    
    [footerview addSubview:button];
    
    [myTableview setTableFooterView:footerview];

}


#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [leftArr count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FriendInfoCell"];
    UILabel *leftlabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 2.0f, 80.0f, 40.0f)];
    [leftlabel setBackgroundColor:[UIColor clearColor]];
    [leftlabel setFont:[UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:16.0f]];
    [leftlabel setTextColor:kNBR_ProjectColor_DeepGray];
    [leftlabel setText:leftArr[indexPath.row]];
    [cell.contentView addSubview:leftlabel];
    
    UILabel *rightlabel = [[UILabel alloc] initWithFrame:CGRectMake(leftlabel.frame.size.width+leftlabel.frame.origin.x+10.0f, 2.0f, kNBR_SCREEN_W-leftlabel.frame.size.width-leftlabel.frame.origin.x-20.0f, 40.0f)];
    [rightlabel setBackgroundColor:[UIColor clearColor]];
    [rightlabel setFont:[UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:16.0f]];
    [rightlabel setTextColor:kNBR_ProjectColor_MidGray];
    [rightlabel setText:rightArr[indexPath.row]];
    [cell.contentView addSubview:rightlabel];
    
    return cell;
    
}

#pragma mark EVENT Method

-(void) AddToFriend
{
    
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
