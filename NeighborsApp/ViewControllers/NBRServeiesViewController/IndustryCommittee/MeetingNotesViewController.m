//
//  MeetingNotesViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/6/3.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "MeetingNotesViewController.h"
#import "RefreshControl.h"
#import "CreateRequest_Server.h"

@interface MeetingNotesViewController ()<UITableViewDataSource, UITableViewDelegate,RefreshControlDelegate>
{
    UITableView     *boundTableView;
    NSMutableArray  *boundMothList;
    NSMutableArray  *boundDataSource;
    RefreshControl  *refreshController;
    NSInteger        totalRecord;
    NSInteger       pageIndex;
    BOOL            isLoading;
    
    ASIHTTPRequest  *mettingNoteRequest;
}

@end

@implementation MeetingNotesViewController

- (void) requestMeetingNoteList
{
    mettingNoteRequest = [CreateRequest_Server CreateDynamicOfPropertyInfoWithIndex:ITOS(pageIndex) Flag:@"3" Size:kNBR_PAGE_SIZE_STR];
    
    __weak ASIHTTPRequest *selfblock = mettingNoteRequest;
    
    [selfblock setCompletionBlock:^{

        isLoading = NO;
        
        [self removeLoadingView];
        [refreshController finishRefreshingDirection:RefreshDirectionTop];
        NSDictionary *reponseDict = selfblock.responseString.JSONValue;
        
        totalRecord = [reponseDict numberWithKeyPath:@"data\\result\\totalRecord"];
        
        if (pageIndex == 0)
        {
            boundDataSource = [[NSMutableArray alloc] init];
            boundMothList = [[NSMutableArray alloc] init];
        }
        
        if ([CreateRequest_Server CheckErrorResponse:reponseDict errorAlertInViewController:self])
        {
            
            NSArray *tempNewMeetingNotes = [reponseDict arrayWithKeyPath:@"data\\result\\data"];
            
            for (NSDictionary *subMeetingNoteDict in tempNewMeetingNotes)
            {
                NSDate *meetingDate = [self dateWithString:[subMeetingNoteDict stringWithKeyPath:@"created"]];
                
                NSDateFormatter *yearFormat = [[NSDateFormatter alloc] init];
                yearFormat.dateFormat = @"yyyy";
                
                NSDateFormatter *mothForamt = [[NSDateFormatter alloc] init];
                mothForamt.dateFormat = @"MM";
                
                //获得月份,年份
                NSString *meetingYear = [yearFormat stringFromDate:meetingDate];
                NSString *meetingMoth = [mothForamt stringFromDate:meetingDate];
                NSString *indexString = [NSString stringWithFormat:@"%@|%@", meetingYear,meetingMoth];
                
                if ([boundMothList containsObject:indexString])
                {
                    NSInteger mothIndex = [boundMothList indexOfObject:indexString];
                    
                    [((NSMutableArray*)boundDataSource[mothIndex]) addObject:subMeetingNoteDict];
                }
                else
                {
                    [boundDataSource addObject:[NSMutableArray arrayWithObject:subMeetingNoteDict]];
                    [boundMothList addObject:indexString];
                }
            }
            
            [boundTableView reloadData];
        }
    }];
    
    [selfblock setFailedBlock:^{
        isLoading = NO;
        [self removeLoadingView];
        [refreshController finishRefreshingDirection:RefreshDirectionTop];
        [self showBannerMsgWithString:@"网络连接失败，请您检查您的网络设置"];
    }];
    
    [self addLoadingView];
    [selfblock startAsynchronous];
    isLoading = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会议纪要";
    
    boundMothList = [[NSMutableArray alloc] init];
    boundDataSource = [[NSMutableArray alloc] init];

    boundTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kNBR_SCREEN_W, kNBR_SCREEN_H - 64) style:UITableViewStyleGrouped];
    boundTableView.delegate = self;
    boundTableView.dataSource = self;
    [self.view addSubview:boundTableView];
    
    refreshController = [[RefreshControl alloc] initWithScrollView:boundTableView delegate:self];
    refreshController.topEnabled= YES;
    
    [self requestMeetingNoteList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --UITableViewDelegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return boundMothList.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray*)boundDataSource[section]).count;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, 30)];
    sectionHeaderView.backgroundColor = kNBR_ProjectColor_BackGroundGray;
    sectionHeaderView.layer.borderColor = kNBR_ProjectColor_LineLightGray.CGColor;
    sectionHeaderView.layer.borderWidth = 0.5f;
    
    UILabel *sectionHeaderLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kNBR_SCREEN_W - 30, 30)];
    sectionHeaderLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:14.0f];
    sectionHeaderLable.textColor = kNBR_ProjectColor_DeepBlack;
    sectionHeaderLable.text = [[boundMothList[section] componentsSeparatedByString:@"|"][1] stringByAppendingString:@"月"];
    [sectionHeaderView addSubview:sectionHeaderLable];
    
    return sectionHeaderView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *cellDict = boundDataSource[indexPath.section][indexPath.row];
    
    NSDate *meetingDate = [self dateWithString:[cellDict stringWithKeyPath:@"created"]];

    NSDateFormatter *mothForamt = [[NSDateFormatter alloc] init];
    mothForamt.dateFormat = @"dd";

    UIImageView *dataIconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 65.0f / 2.0f - 27 / 2.0f, 27, 27)];
    dataIconImgView.image = [UIImage imageNamed:@"rili02"];
    UILabel *dayLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 27, 27)];
    dayLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:18.0f];
    dayLable.textColor = kNBR_ProjectColor_DeepBlack;
    dayLable.textAlignment = NSTextAlignmentCenter;
    dayLable.text = [mothForamt stringFromDate:meetingDate];
    [dataIconImgView addSubview:dayLable];
    [cell.contentView addSubview:dataIconImgView];
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10 + 27 + 10, 5, kNBR_SCREEN_W - 10 + 27 + 10 * 2, 18)];
    titleLable.textColor = kNBR_ProjectColor_StandBlue;
    titleLable.textAlignment = NSTextAlignmentLeft;
    titleLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14.0f];
    titleLable.text = [cellDict stringWithKeyPath:@"title"];
    [cell.contentView addSubview:titleLable];
    
    UILabel *contentLable = [[UILabel alloc] initWithFrame:CGRectMake(10 + 27 + 10, titleLable.frame.origin.y + titleLable.frame.size.height, kNBR_SCREEN_W - 10 - 27 - 10 * 2, 65 - 3 - 20)];
    contentLable.textColor = kNBR_ProjectColor_MidGray;
    contentLable.textAlignment = NSTextAlignmentLeft;
    contentLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:13.0f];
    contentLable.numberOfLines = 2;
    contentLable.text = [cellDict stringWithKeyPath:@"info"];
    [cell.contentView addSubview:contentLable];
    
    return cell;
}

- (void) refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction
{
    if (direction == RefreshDirectionTop)
    {
        pageIndex = 0;
        [self requestMeetingNoteList];
    }
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (pageIndex * kNBR_PAGE_SIZE >= totalRecord)
    {
        return ;
    }
    
    UITableViewCell *lastCell = [boundTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:boundDataSource.count - 1]];
    
    if ([boundTableView.visibleCells containsObject:lastCell])
    {
        if (isLoading)
        {
            return ;
        }
        
        pageIndex++;
        
        [self requestMeetingNoteList];
    }
}


@end
