//
//  NBRFriendApplyViewController.m
//  NeighborsApp
//
//  Created by jason on 15/5/16.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRFriendApplyViewController.h"
#import "CreaterRequest_User.h"


@interface NBRFriendApplyViewController ()

@end

@implementation NBRFriendApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"邻里申请"];
    applyData = [[NSMutableArray alloc] init];
    
    myTableview =[[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kNBR_SCREEN_W, kNBR_SCREEN_H) style:UITableViewStyleGrouped];
    [myTableview setBackgroundView:nil];
    [myTableview setBackgroundColor:[UIColor clearColor]];
    [myTableview setDelegate:self];
    [myTableview setDataSource:self];
    [myTableview setRowHeight:56.0f];
    [self.view addSubview:myTableview];
    [self GetApplyList];
    
}

#pragma mark data init Method
-(void)GetApplyList
{
    applyRequst = [CreaterRequest_User CreateApplyFriendListRequest];
    __weak ASIHTTPRequest *selfblock = applyRequst;
    [selfblock setCompletionBlock:^{
        NSDictionary *reponseDict = selfblock.responseString.JSONValue;
        [self removeLoadingView];
        
        if ([CreaterRequest_User CheckErrorResponse:reponseDict errorAlertInViewController:self])
        {
            [self showBannerMsgWithString:[reponseDict stringWithKeyPath:@"data\\code\\message"]];
            applyData = (NSMutableArray *)[reponseDict arrayWithKeyPath:@"data\\result"];
            [myTableview reloadData];
            
        }
    }];
    
    [self setDefaultRequestFaild:selfblock];
    
    [self addLoadingView];
    [applyRequst startAsynchronous];

    
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [applyData count];
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
    [nicknameLabel setText:applyData[indexPath.row]];
    [cell addSubview:nicknameLabel];
    
    UILabel *villagenameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nicknameLabel.frame.origin.x, nicknameLabel.frame.origin.y+nicknameLabel.frame.size.height, kNBR_SCREEN_W-100.0f-65.0f, 20.0f)];
    [villagenameLabel setBackgroundColor:[UIColor clearColor]];
    [villagenameLabel setFont:[UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:16.0f]];
    [villagenameLabel setTextColor:kNBR_ProjectColor_MidGray];
    [villagenameLabel setText:applyData[indexPath.row]];
    [cell.contentView addSubview:villagenameLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(kNBR_SCREEN_W-70.0f, 56.0/2-15.0f, 50.0f, 30.0f)];
    [button setTintColor:kNBR_ProjectColor_StandWhite];
    [button setBackgroundColor:kNBR_ProjectColor_StandBlue];
    [button.layer setCornerRadius:4.0];
    [button.layer setMasksToBounds:YES];
    button.tag = indexPath.row;
    [button setTitle:@"同意" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(AddToFriend:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:button];
    return cell;
    
}

#pragma mark Event Method

-(void) AddToFriend:(UIButton *) sender
{
    NSLog(@"sender tag == %d",sender.tag);
    
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
