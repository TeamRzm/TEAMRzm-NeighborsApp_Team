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
#import "JoinsActivityViewController.h"
#import "CreaterRequest_Activity.h"

@interface ActivityDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *boundTableView;
    NSMutableArray *boundTableViewDataSource;
    
    NSDictionary    *contentStringFormat;
    
    ASIHTTPRequest  *activityJoinsRequest;
    NSDictionary    *joinListDict;
    NSInteger       dateIndex;
}
@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动详情";
    
    boundTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kNBR_SCREEN_W, kNBR_SCREEN_H - 60 - 64) style:UITableViewStyleGrouped];
    boundTableView.delegate = self;
    boundTableView.dataSource = self;
    
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
    
//    boundTableView.tableFooterView = tableViewFootView;
    
    [self requestJoins];
}

- (void) setDateEntity:(ActivityDateEntity *) tdateEntity
{
    _dateEntity = tdateEntity;
    
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
    [commitButton addTarget:self action:@selector(joinThisActivity) forControlEvents:UIControlEventTouchUpInside];
    [tableViewFootView addSubview:commitButton];
    [self.view addSubview:tableViewFootView];
    
    switch (tdateEntity.activityState)
    {
        case ACTIVITY_STATE_VAIL:
        {
            [commitButton setTitle:@"活动已过期" forState:UIControlStateNormal];
            commitButton.enabled = NO;
        }
            break;
            
        case ACTIVITY_STATE_END:
        {
            [commitButton setTitle:@"活动已结束" forState:UIControlStateNormal];
            commitButton.enabled = NO;
        }
            break;
            
        case ACTIVITY_STATE_STARTING:
        {
            [commitButton setTitle:@"报名暂未开始，不能报名" forState:UIControlStateNormal];
            commitButton.enabled = NO;
        }
            break;
            
        case ACTIVITY_STATE_RES:
        {
            [commitButton setTitle:@"我要报名" forState:UIControlStateNormal];
            commitButton.enabled = YES;
        }
            break;
            
        default:
            break;
    }

    return ;
}

- (void) joinThisActivity
{
    JoinsActivityViewController *nVC = [[JoinsActivityViewController alloc] initWithNibName:nil bundle:nil];
    nVC.activityEntity = self.dateEntity;
    [self.navigationController pushViewController:nVC animated:YES];
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
                                                                    ],
                                                                ]];

}

- (void) requestJoins
{
    activityJoinsRequest = [CreaterRequest_Activity CreateJoinsRequestWithID:self.dateEntity.activityID index:[NSString stringWithFormat:@"%d",dateIndex] size:@"9999"];
    
    __weak ASIHTTPRequest *blockRequest = activityJoinsRequest;
    
    [blockRequest setCompletionBlock:^{
        [self removeLoadingView];
        NSDictionary *reponseDict = blockRequest.responseString.JSONValue;
        
        if ([CreaterRequest_Activity CheckErrorResponse:reponseDict errorAlertInViewController:self])
        {
            [self configDate];
            
            joinListDict = reponseDict;
        
            boundTableViewDataSource[2] = [reponseDict arrayWithKeyPath:@"data\\result\\data"];

            [self.view addSubview:boundTableView];
//            [boundTableView reloadData];
//            [boundTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
            
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

        [sectionHeaderView addSubview:sectionHeaderLable];
        
        if (section == 1)
        {
            sectionHeaderLable.text = @"活动描述";
        }
        else if (boundTableViewDataSource.count >= 3)
        {
            NSString *leftStr = ITOS([self.dateEntity.dateDict numberWithKeyPath:@"applies"]);
            NSString *rightStr = ITOS([self.dateEntity.dateDict numberWithKeyPath:@"joins"]);
            
            NSString *joinCountString = [NSString stringWithFormat:@"报名人员 (%@/%@) 人", leftStr, rightStr];
            
            NSDictionary *titleFormat = @{
                                          NSFontAttributeName : [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:14.0f],
                                          NSForegroundColorAttributeName : kNBR_ProjectColor_DeepBlack,
                                          };
            
            NSDictionary *redFormat = @{
                                            NSFontAttributeName : [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:13.0f],
                                            NSForegroundColorAttributeName : kNBR_ProjectColor_StandBlue,
                                        };
            
            NSDictionary *grayFormat = @{
                                         NSFontAttributeName : [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:13.0f],
                                         NSForegroundColorAttributeName : kNBR_ProjectColor_MidGray,
                                         };
            
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:joinCountString];
            [attString addAttributes:titleFormat range:NSMakeRange(0, 4)];
            [attString addAttributes:grayFormat range:NSMakeRange(4, 2)];
            [attString addAttributes:redFormat range:NSMakeRange(6, leftStr.length)];
            [attString addAttributes:grayFormat range:NSMakeRange(6 + leftStr.length, joinCountString.length - (6 + leftStr.length))];
            
            sectionHeaderLable.attributedText = attString;

        }
        
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
        return 56.0f;
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
            if (boundTableViewDataSource.count > 2)
            {
                return ((NSArray*)(boundTableViewDataSource[2])).count;
            }
            else
            {
                return 0;
            }
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
        
        NSMutableDictionary *subdic = boundTableViewDataSource[indexPath.section][indexPath.row];
        
        //头像
        EGOImageView *avterImgView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"defaultAvater"]];
        avterImgView.frame = CGRectMake(10.0f, 56 / 2.0f - 43 / 2.0f, 43, 43);
        avterImgView.layer.cornerRadius = avterImgView.frame.size.width / 2.0f;
        avterImgView.layer.masksToBounds = YES;
        avterImgView.imageURL = [NSURL URLWithString:[subdic stringWithKeyPath:@"userInfo\\avatar"]];
        [cell.contentView addSubview:avterImgView];
        
        //联系人
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(68.0f,
                                                                        10,
                                                                        kNBR_SCREEN_W - 68.0f - 10,
                                                                        20.0f)];
        titleLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:14.0f];
        titleLable.textColor = kNBR_ProjectColor_DeepGray;
        titleLable.text = subdic[@"linkMan"];
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
        
        NSDictionary *redFormat = @{
                                    NSFontAttributeName : [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:13.0f],
                                    NSForegroundColorAttributeName : kNBR_ProjectColor_StandBlue,
                                    };
        
        NSDictionary *grayFormat = @{
                                    NSFontAttributeName : [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:13.0f],
                                    NSForegroundColorAttributeName : kNBR_ProjectColor_MidGray,
                                    };
        
        NSMutableAttributedString *dutyLableAttString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@人", subdic[@"amount"]]];
        
        [dutyLableAttString addAttributes:redFormat range:NSMakeRange(0, dutyLableAttString.length - 1)];
        [dutyLableAttString addAttributes:grayFormat range:NSMakeRange(dutyLableAttString.length - 1, 1)];
        
        dutyLable.attributedText = dutyLableAttString;
        
        [cell.contentView addSubview:avterImgView];
        [cell.contentView addSubview:titleLable];
        [cell.contentView addSubview:phoneLable];
        [cell.contentView addSubview:dutyLable];
        
        return cell;
    }
    
    return nil;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
    {
        NSMutableDictionary *subdic = boundTableViewDataSource[indexPath.section][indexPath.row];
        [self callTel:[subdic stringWithKeyPath:@"phone"]];
        return ;
    }
}

@end
