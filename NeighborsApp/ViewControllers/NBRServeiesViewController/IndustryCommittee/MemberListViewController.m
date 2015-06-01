//
//  MemberListViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/31.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "MemberListViewController.h"
#import "CreaterRequest_Owner.h"
#import "EGOImageView.h"


@interface MemberListViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView         *boundTableView;
    NSMutableArray      *boundDataSource;
    
    ASIHTTPRequest      *memberListRequest;
}
@end

@implementation MemberListViewController

- (void) requestMemberList
{
    memberListRequest = [CreaterRequest_Owner CreateMemberListRequest];
    
    __weak ASIHTTPRequest *blockRequest = memberListRequest;
    
    [blockRequest setCompletionBlock:^{
        
        [self removeLoadingView];
        
        NSDictionary *responseDict = blockRequest.responseString.JSONValue;
        
        if ([CreaterRequest_Owner CheckErrorResponse:responseDict errorAlertInViewController:self])
        {
            boundDataSource = [[NSMutableArray alloc] initWithArray:[responseDict arrayWithKeyPath:@"data\\result\\data"]];
            
            [boundTableView reloadData];
            
            return ;
        }
        
    }];
    
    [self setDefaultRequestFaild:blockRequest];
    
    [self addLoadingView];
    [blockRequest startAsynchronous];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"成员列表";
    
    boundTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, kNBR_SCREEN_H) style:UITableViewStyleGrouped];
    boundTableView.delegate = self;
    boundTableView.dataSource = self;
    
    [self.view addSubview:boundTableView];
    
    [self requestMemberList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --UITableViewDelegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return boundDataSource.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .1f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56.0f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSMutableDictionary *subdic = boundDataSource[indexPath.row];
    
    //头像
    EGOImageView *avterImgView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"defaultAvater"]];
    avterImgView.frame = CGRectMake(10.0f, 56 / 2.0f - 43 / 2.0f, 43, 43);
    avterImgView.layer.cornerRadius = avterImgView.frame.size.width / 2.0f;
    avterImgView.layer.masksToBounds = YES;
    avterImgView.imageURL = [NSURL URLWithString:[subdic stringWithKeyPath:@"avatar"]];
    [cell.contentView addSubview:avterImgView];
    
    //联系人
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(68.0f,
                                                                    10,
                                                                    kNBR_SCREEN_W - 68.0f - 10,
                                                                    20.0f)];
    titleLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:14.0f];
    titleLable.textColor = kNBR_ProjectColor_DeepGray;
    titleLable.text = subdic[@"name"];
    //电话
    
    UILabel *phoneLable = [[UILabel alloc] initWithFrame:CGRectMake(68.0f,
                                                                    titleLable.frame.origin.y+20.0f,
                                                                    kNBR_SCREEN_W - 68.0f - 10,
                                                                    20.0f)];
    phoneLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:13.0f];
    phoneLable.textColor = kNBR_ProjectColor_MidGray;
    phoneLable.text = subdic[@"phone"];
    
    //     职位
    UILabel *dutyLable = [[UILabel alloc] initWithFrame:CGRectMake(kNBR_SCREEN_W-68.0f,
                                                                   0,
                                                                   68.0f - 10,
                                                                   56)];
    dutyLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:13.0f];
    dutyLable.textAlignment = NSTextAlignmentRight;
    dutyLable.textColor = kNBR_ProjectColor_MidGray;
    dutyLable.text = subdic[@"duty"];
    
    
    [cell.contentView addSubview:avterImgView];
    [cell.contentView addSubview:titleLable];
    [cell.contentView addSubview:phoneLable];
    [cell.contentView addSubview:dutyLable];

    
    return cell;
}

@end
