//
//  ActivityDetailViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/22.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "ActivityTableViewCell.h"
#import "EGOImageView.h"

#import "CreaterRequest_Activity.h"

@interface ActivityDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *boundTableView;
    NSMutableArray *boundTableViewDataSource;
    
    NSDictionary    *contentStringFormat;
    
    ASIHTTPRequest  *iWantJoinRequest;
    ASIHTTPRequest  *activityJoinsRequest;
    NSInteger       dateIndex;
}
@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"新家园春季篮球赛";
    
    boundTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, kNBR_SCREEN_H - 60) style:UITableViewStyleGrouped];
    boundTableView.delegate = self;
    boundTableView.dataSource = self;
    [self.view addSubview:boundTableView];
    
    boundTableViewDataSource = [[NSMutableArray alloc] init];
    
    //format
    NSMutableParagraphStyle *contentViewStyle = [[NSMutableParagraphStyle alloc] init];
    contentViewStyle.lineHeightMultiple = 1;
    contentViewStyle.lineSpacing = 4.0f;
    contentViewStyle.paragraphSpacing = 3.0f;
    
    //format attribute string dict
    UIFont *contentFont = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:12];
    
    contentStringFormat = @{
                            NSFontAttributeName               : contentFont,
                            NSParagraphStyleAttributeName     : contentViewStyle,
                            NSForegroundColorAttributeName    : kNBR_ProjectColor_DeepGray,
                            };
    
    //FootView
    //报名按钮
    UIView *tableViewFootView = [[UIView alloc] initWithFrame:CGRectMake(0, kNBR_SCREEN_H - 60, kNBR_SCREEN_W, 60)];
    tableViewFootView.backgroundColor = [UIColor whiteColor];
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(15, 10, kNBR_SCREEN_W - 30, 40);
    commitButton.backgroundColor = kNBR_ProjectColor_StandBlue;
    commitButton.layer.cornerRadius = 5.0f;
    commitButton.layer.masksToBounds = YES;
    commitButton.titleLabel.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:15.0f];
    [commitButton setTitle:@"我要报名" forState:UIControlStateNormal];
    [tableViewFootView addSubview:commitButton];
    
//    boundTableView.tableFooterView = tableViewFootView;
    [self.view addSubview:tableViewFootView];
    
    [self requestJoins];
}

- (void) iWantJoinRequest
{
    iWantJoinRequest = [CreaterRequest_Activity CreateJoinRequestWithID:self.dateEntity.activityID phone:@"" contrace:@"" count:@""];
}

- (void) configDate
{
    //test data
    boundTableViewDataSource = [NSMutableArray arrayWithArray:@[
                                                                @[self.dateEntity],
                                                                @[
                                                                    self.dateEntity.dateDict[@"content"],
                                                                    [self nowDateStringForDistanceDateString:self.dateEntity.dateDict[@"startDate"]],
                                                                    self.dateEntity.dateDict[@"address"],
                                                                    [NSString stringWithFormat:@"%@  %@", self.dateEntity.dateDict[@"linkman"], self.dateEntity.dateDict[@"phone"]],
                                                                    ],
                                                                @[
                                                                    @[
                                                                        @"t_avter_0",
                                                                        @"t_avter_1",
                                                                        @"t_avter_2",
                                                                        @"t_avter_3",
                                                                        @"t_avter_4",
                                                                        @"t_avter_5",
                                                                        @"t_avter_6",
                                                                        @"t_avter_7",
                                                                        @"t_avter_9",
                                                                        ],
                                                                    ],
                                                                ]];

}

- (void) requestJoins
{
    activityJoinsRequest = [CreaterRequest_Activity CreateJoinsRequestWithID:self.dateEntity.activityID index:[NSString stringWithFormat:@"%d",dateIndex] size:kNBR_PAGE_SIZE_STR];
    
    __weak ASIHTTPRequest *blockRequest = activityJoinsRequest;
    
    [blockRequest setCompletionBlock:^{
        [self removeLoadingView];
        NSDictionary *reponseDict = blockRequest.responseString.JSONValue;
        
        if ([CreaterRequest_Activity CheckErrorResponse:reponseDict errorAlertInViewController:self])
        {
            [self configDate];
            [boundTableView reloadData];
            return ;
        }
        
    }];
    
    [self setDefaultRequestFaild:blockRequest];
    [self addLoadingView];
    [activityJoinsRequest startAsynchronous];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableView delegate

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1f;
    }
    else
    {
        return 30;
    }
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return [[UIView alloc] init];
    }
    else
    {
        UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, 30)];
        sectionHeaderView.backgroundColor = kNBR_ProjectColor_BackGroundGray;
        sectionHeaderView.layer.borderColor = kNBR_ProjectColor_LineLightGray.CGColor;
        sectionHeaderView.layer.borderWidth = 0.5f;
        
        UILabel *sectionHeaderLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kNBR_SCREEN_W - 30, 30)];
        sectionHeaderLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:14.0f];
        sectionHeaderLable.textColor = kNBR_ProjectColor_DeepBlack;
        sectionHeaderLable.text = section == 1 ? @"活动描述" : @"报名人员";
        [sectionHeaderView addSubview:sectionHeaderLable];
        
        return sectionHeaderView;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return [ActivityTableViewCell heightWithEntity:self.dateEntity isDetail:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 0)
    {
        NSString *contentString = boundTableViewDataSource[indexPath.section][indexPath.row];
        
        CGRect contentStringSize = [contentString boundingRectWithSize:CGSizeMake(kNBR_SCREEN_W - 20, 1000)
                                                               options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                            attributes:contentStringFormat
                                                               context:nil];
        
        return contentStringSize.size.height + 30;
    }
    else if (indexPath.section == 2)
    {
        NSArray *jionUserList = boundTableViewDataSource[indexPath.section][indexPath.row];
        
        if (jionUserList.count > 6) //H : 45
        {
            return 55.0f;
        }
        else
        {
            return 100.0f;
        }
    }
    
    return 40.0f;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return boundTableViewDataSource.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            return 1;
        }
            break;
            
        case 1:
        {
            return 4;
        }
            break;
            
        case 2:
        {
            return 1;
        }
            break;
            
        default:
        {
            return 0;
        }
            break;
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        ActivityTableViewCell *cell = [[ActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
        cell.layer.masksToBounds = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell configWithEntity:self.dateEntity isDetail:YES];
        
        return cell;
    }
    else if (indexPath.section == 1)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row <= 0)
        {
            NSString *contentString = boundTableViewDataSource[indexPath.section][indexPath.row];
            
            CGRect contentStringSize = [contentString boundingRectWithSize:CGSizeMake(kNBR_SCREEN_W - 20, 1000)
                                                                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                attributes:contentStringFormat
                                                                   context:nil];
            
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:contentString];
            
            [attString addAttributes:contentStringFormat range:NSMakeRange(0, attString.length)];
            
            UILabel *contentLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, contentStringSize.size.width, contentStringSize.size.height)];
            
            contentLable.textColor = kNBR_ProjectColor_BackGroundGray;
            contentLable.attributedText = attString;
            contentLable.numberOfLines = 0;
            
            [cell.contentView addSubview:contentLable];

            return cell;
        }
        else
        {
            NSArray *titleArray = @[@"活动时间",@"活动地点",@"联系人"];
            
            NSString *contentString = boundTableViewDataSource[indexPath.section][indexPath.row];
            
            //标题
            UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 55, 40)];
            titleLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:12.0f];
            titleLable.textColor = kNBR_ProjectColor_DeepBlack;
            titleLable.textAlignment = NSTextAlignmentRight;
            titleLable.text = titleArray[indexPath.row - 1];
            [cell.contentView addSubview:titleLable];
            
            //内容
            UILabel *contentLable = [[UILabel alloc] initWithFrame:CGRectMake(titleLable.frame.origin.x + titleLable.frame.size.width + 5,
                                                                              0,
                                                                              kNBR_SCREEN_W - (titleLable.frame.origin.x + titleLable.frame.size.width + 10 * 2),
                                                                              40)];
            contentLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:12.0f];
            contentLable.textColor = kNBR_ProjectColor_DeepGray;
            contentLable.text = contentString;
            [cell.contentView addSubview:contentLable];
         
            return cell;
        }
    }
    else if (indexPath.section == 2)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray *jionUserList = boundTableViewDataSource[indexPath.section][indexPath.row];
        
        for (int i = 0; i < jionUserList.count; i++)
        {
            EGOImageView *subIconImageView = [[EGOImageView alloc] initWithFrame:CGRectMake(
                                                                                            10 + (50 * (i % 6)),
                                                                                            5,
                                                                                            45, 45
                                                                                            )];
            
            subIconImageView.image = [UIImage imageNamed:jionUserList[i]];
            subIconImageView.layer.cornerRadius = CGRectGetHeight(subIconImageView.frame) / 2.0f;
            subIconImageView.layer.masksToBounds = YES;
            
            [cell.contentView addSubview:subIconImageView];
        }
        
        return cell;
    }
    
    return nil;
}

@end
