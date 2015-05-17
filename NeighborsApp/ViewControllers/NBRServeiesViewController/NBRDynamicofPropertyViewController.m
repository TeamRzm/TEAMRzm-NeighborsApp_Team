//
//  NBRDynamicofPropertyViewController.m
//  NeighborsApp
//
//  Created by jason on 15/5/17.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRDynamicofPropertyViewController.h"
#import "CreateRequest_Server.h"


@interface NBRDynamicofPropertyViewController ()

@end

@implementation NBRDynamicofPropertyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"物业动态"];
    [self initSubView];
    [self GetDynamicList];
    
}

#pragma mark Init Method
-(void) initSubView
{
    dataArr = [[NSMutableArray alloc] init];
    
    myTableview =[[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kNBR_SCREEN_W, kNBR_SCREEN_H) style:UITableViewStyleGrouped];
    [myTableview setBackgroundView:nil];
    [myTableview setBackgroundColor:[UIColor clearColor]];
    [myTableview setDelegate:self];
    [myTableview setDataSource:self];
    [self.view addSubview:myTableview];
    
}

-(void) GetDynamicList
{
    dynamicReq = [CreateRequest_Server CreateDynamicOfPropertyInfoWithIndex:@"1" Flag:@"0" Size:@"20"];
    __weak ASIHTTPRequest *selfblock = dynamicReq;
    [selfblock setCompletionBlock:^{
        NSDictionary *reponseDict = selfblock.responseString.JSONValue;
        [self removeLoadingView];
        
        if ([CreateRequest_Server CheckErrorResponse:reponseDict errorAlertInViewController:self])
        {
            [self showBannerMsgWithString:[reponseDict stringWithKeyPath:@"data\\code\\message"]];
            dataArr = (NSMutableArray *)[reponseDict arrayWithKeyPath:@"data\\result\\data"];
            [myTableview reloadData];
            
        }
    }];
    
    [self setDefaultRequestFaild:selfblock];
    
    [self addLoadingView];
    [dynamicReq startAsynchronous];
    
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
    return [dataArr count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, kNBR_SCREEN_W-20.0f, 25.0f)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel  setTextColor:kNBR_ProjectColor_StandRed];
    [titleLabel setFont:[UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:16.0f]];
    [titleLabel  setText:@"小雪了，下雪了(小区雪景)!!"];
    [cell.contentView addSubview:titleLabel];
    
    //内容
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, titleLabel.frame.origin.y+titleLabel.frame.size.height+10.0f, kNBR_SCREEN_W-20.0f, 25.0f)];
    [contentLabel setBackgroundColor:[UIColor clearColor]];
    [contentLabel  setTextColor:kNBR_ProjectColor_DeepGray];
    [contentLabel setFont:[UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:16.0f]];
    [contentLabel setNumberOfLines:0];
    [contentLabel  setText:@"经过昨夜一宿的飘雪，今日合肥已化身白色的童话世界。今年的雪好美，大家快出来堆雪人。"];
    [contentLabel sizeToFit];
    
    [contentLabel setFrame:CGRectMake(10.0f, contentLabel.frame.origin.y, kNBR_SCREEN_W-20.0f, contentLabel.frame.size.height)];
    [cell.contentView addSubview:contentLabel];
    
//    图片
    for (int i =0; i<3; i++)
    {
        //头像
        EGOImageView *avterImgView = [[EGOImageView alloc] initWithPlaceholderImage: [UIImage imageNamed:@"t_avter_1"]];
        avterImgView.frame = CGRectMake(10+i*64.0f, contentLabel.frame.size.height+contentLabel.frame.origin.y+10.0f,54,54);
        avterImgView.layer.cornerRadius = avterImgView.frame.size.width / 2.0f;
        avterImgView.layer.masksToBounds = YES;
        [cell.contentView addSubview:avterImgView];
        avterImgView.tag = i;
        [cell.contentView addSubview:avterImgView];

    }
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, contentLabel.frame.size.height+contentLabel.frame.origin.y+84.0f, 14, 18.5)];
    iconView.image = [UIImage imageNamed:@"xiaoQuAddressIcon"];
    [cell.contentView addSubview:iconView];
    
    UILabel *floorLabel = [[UILabel alloc] initWithFrame:CGRectMake( iconView.frame.size.width+iconView.frame.origin.x+5.0f, iconView.frame.origin.y, kNBR_SCREEN_W-20.0f, 25.0f)];
    [floorLabel setBackgroundColor:[UIColor clearColor]];
    [floorLabel  setTextColor:kNBR_ProjectColor_MidGray];
    [floorLabel setFont:[UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:16.0f]];
    [floorLabel  setText:@"新家园小区"];
    [floorLabel sizeToFit];
    [cell.contentView addSubview:floorLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(floorLabel.frame.origin.x+floorLabel.frame.size.width+10, floorLabel.frame.origin.y, 100, floorLabel.frame.size.height)];
    [timeLabel setBackgroundColor:[UIColor clearColor]];
    [timeLabel  setTextColor:kNBR_ProjectColor_MidGray];
    [timeLabel setFont:[UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:16.0f]];
    [timeLabel  setText:@"1小时前"];
    [cell.contentView addSubview:timeLabel];
    [cell setFrame:CGRectMake(0.0f, 0.0f, kNBR_SCREEN_W, timeLabel.frame.origin.y+timeLabel.frame.size.height+10)];
    
    return cell;
    
}

-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

-(float) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0f;
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
