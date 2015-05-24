//
//  ComplaintsAndRepairViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/20.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "ComplaintsAndRepairViewController.h"
#import "CommitNewContentViewController.h"
#import "ComplaintsAndRepairDetailViewController.h"
#import "CreaterRequest_Complaint.h"
#import "ComplaintsCell.h"
#import "XHImageViewer.h"
#import "RefreshControl.h"

@interface ComplaintsAndRepairViewController ()<UITableViewDataSource, UITableViewDelegate,XHImageViewerDelegate,ComplaintsCellDelegate,RefreshControlDelegate>
{
    NSInteger       currSegmentIndex;
    UIScrollView    *boundScrollView;
    UITableView     *subTableView[2];
    NSMutableArray  *subTableViewDataSource[2];
    NSInteger       dataPageIndex[2];
    NSInteger       totalRecord[2];
    BOOL            hasLoading[2];
    BOOL            fristAppear[2];         //第一次切换到该TableView
    RefreshControl  *refeshController[2];
    
    UIView          *tableViewHeadSegmentView;
    UIView          *segmentLine;
    
    NSArray         *segmentTitleArr;
    
    ASIHTTPRequest *listRequest[2];
}
@end

@implementation ComplaintsAndRepairViewController

- (void) requestListBySegmentIndex : (NSInteger) sIndex
{
    listRequest[sIndex] = [CreaterRequest_Complaint CreateComplaintListRequestWithType:ITOS(sIndex)
                                                                                  flag:@""
                                                                                 index:ITOS((NSInteger)dataPageIndex[sIndex])
                                                                                  size:kNBR_PAGE_SIZE_STR];
    
    __weak ASIHTTPRequest *blockRequest = listRequest[sIndex];
    
    [blockRequest setCompletionBlock:^{
        [self removeLoadingView];
        hasLoading[currSegmentIndex] = NO;
        
        NSDictionary *responseDict = blockRequest.responseString.JSONValue;
        
        if ([CreaterRequest_Complaint CheckErrorResponse:responseDict errorAlertInViewController:self])
        {
            totalRecord[sIndex] = [responseDict numberWithKeyPath:@"data\\result\\totalRecord"];
            
            NSArray *newComplaint = [responseDict arrayWithKeyPath:@"data\\result\\data"];
            
            if (dataPageIndex[sIndex] == 0)
            {
                //刷新
                [refeshController[sIndex] finishRefreshingDirection:RefreshDirectionTop];
                subTableViewDataSource[sIndex] = [[NSMutableArray alloc] initWithArray:newComplaint];
                [subTableView[sIndex] reloadData];
            }
            else
            {
                //追加
                NSMutableArray *insertIndexPath = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < newComplaint.count; i++)
                {
                    [insertIndexPath addObject:[NSIndexPath indexPathForRow:0 inSection:subTableViewDataSource[sIndex].count + i]];
                }
                
                [subTableViewDataSource[sIndex] addObjectsFromArray:newComplaint];
                
                [subTableView[sIndex] reloadData];
            }
            return ;
        }
    }];
    
    [blockRequest setFailedBlock:^{
        hasLoading[currSegmentIndex] = NO;
        
        [self removeLoadingView];
        
        [refeshController[sIndex] finishRefreshingDirection:RefreshDirectionTop];
        
        [self showBannerMsgWithString:@"网络连接失败，请您检查您的网络设置"];
    }];
    
    [blockRequest startAsynchronous];
    hasLoading[currSegmentIndex] = YES;
    [self addLoadingView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"投诉与报修";
    
    currSegmentIndex = 0;

    UIBarButtonItem *rightAddItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tianjia01"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarbuttonAction:)];
    self.navigationItem.rightBarButtonItem = rightAddItem;
    
    //segmentView
    segmentTitleArr = @[@"投诉",@"报修"];
    tableViewHeadSegmentView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kNBR_SCREEN_W, 40.0f)];
    segmentLine = [[UIView alloc] initWithFrame:CGRectMake(0, 40.0f - 4, kNBR_SCREEN_W / segmentTitleArr.count, 4)];
    segmentLine.backgroundColor = kNBR_ProjectColor_StandBlue;
    segmentLine.userInteractionEnabled = YES;
    
    boundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + 40.0f, kNBR_SCREEN_W, kNBR_SCREEN_H - 64 - 40.0f)];
    boundScrollView.showsHorizontalScrollIndicator = NO;
    boundScrollView.showsVerticalScrollIndicator = YES;
    boundScrollView.contentSize = CGSizeMake(kNBR_SCREEN_W * 2, kNBR_SCREEN_H - 64 - 40.0f);
    boundScrollView.pagingEnabled = YES;
    boundScrollView.scrollEnabled = NO;
    boundScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:boundScrollView];
    
    for (int i = 0; i < 2; i++)
    {
        subTableViewDataSource[i] = [[NSMutableArray alloc] init];
        subTableView[i] = [[UITableView alloc] initWithFrame:CGRectMake(kNBR_SCREEN_W * i,
                                                                        -64,
                                                                        kNBR_SCREEN_W,
                                                                        kNBR_SCREEN_H - 40.0f - 64)
                                                       style:UITableViewStyleGrouped];
        subTableView[i].delegate = self;
        subTableView[i].dataSource = self;
        subTableView[i].contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [boundScrollView addSubview:subTableView[i]];
        
        //segment
        UILabel *subSegmentLable = [[UILabel alloc] initWithFrame:CGRectMake(i * kNBR_SCREEN_W / segmentTitleArr.count,
                                                                            0,
                                                                            kNBR_SCREEN_W / segmentTitleArr.count,
                                                                             40.0f)];
        subSegmentLable.text = segmentTitleArr[i];
        subSegmentLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:13.0f];
        subSegmentLable.textAlignment = NSTextAlignmentCenter;
        subSegmentLable.textColor = kNBR_ProjectColor_DeepGray;
        subSegmentLable.backgroundColor = kNBR_ProjectColor_BackGroundGray;
        subSegmentLable.userInteractionEnabled = YES;
        subSegmentLable.tag = i;
        
        UITapGestureRecognizer *segmentTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(segmentLableAction:)];
        [subSegmentLable addGestureRecognizer:segmentTapGesture];
        
        [tableViewHeadSegmentView addSubview:subSegmentLable];
        
        //RefeshController
        refeshController[i] = [[RefreshControl alloc] initWithScrollView:subTableView[i] delegate:self];
        refeshController[i].topEnabled = YES;
    }
    
    [tableViewHeadSegmentView addBreakLineWithPosition:VIEW_BREAKLINE_POSITION_BOTTOM style:VIEW_BREAKLINE_STYLE_SOLID width:kNBR_SCREEN_W];
    [tableViewHeadSegmentView addSubview:segmentLine];
    [self.view addSubview:tableViewHeadSegmentView];

    //投诉默认显示所以当作不是第一次进入该视图
    fristAppear[0] = NO;
    fristAppear[1] = YES;
    [self requestListBySegmentIndex:0];
}

- (void) segmentLableAction : (UITapGestureRecognizer*) senderTap
{
    [self changedSegmengWithIndex:senderTap.view.tag];
    
    if (fristAppear[senderTap.view.tag])
    {
        [self requestListBySegmentIndex:senderTap.view.tag];
        fristAppear[senderTap.view.tag] = NO;
    }
}

- (void) changedSegmengWithIndex : (NSInteger) index
{
    currSegmentIndex = index;
    
    [UIView animateWithDuration:.25f animations:^{
       segmentLine.frame = CGRectMake(index * (kNBR_SCREEN_W / segmentTitleArr.count),
                                      40.0f - 2,
                                      kNBR_SCREEN_W / segmentTitleArr.count,
                                      2);
        
        [boundScrollView setContentOffset:CGPointMake(index * kNBR_SCREEN_W, -64) animated:YES];
    }];
}

- (void) rightBarbuttonAction : (id) sender
{
    if (currSegmentIndex == 0)
    {
        CommitNewContentViewController *newContentViewControlelr = [[CommitNewContentViewController alloc] initWithNibName:nil bundle:nil];
        newContentViewControlelr.title = @"我要投诉";
        newContentViewControlelr.mode = COMMIT_TO_MODE_COMPLAIN;
        
        [self.navigationController pushViewController:newContentViewControlelr animated:YES];
    }
    
    if (currSegmentIndex == 1)
    {
        CommitNewContentViewController *newContentViewControlelr = [[CommitNewContentViewController alloc] initWithNibName:nil bundle:nil];
        newContentViewControlelr.title = @"我要报修";
        newContentViewControlelr.mode = COMMIT_TO_MODE_REPAIR;
        
        [self.navigationController pushViewController:newContentViewControlelr animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == subTableView[0])
    {
        return subTableViewDataSource[0].count;
    }
    
    if (tableView == subTableView[1])
    {
        return subTableViewDataSource[1].count;
    }
    
    return 0;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cellDict;
    
    if (tableView == subTableView[0])
    {
        cellDict = [subTableViewDataSource[0] objectAtIndex:indexPath.section];
    }
    
    if (tableView == subTableView[1])
    {
        cellDict = [subTableViewDataSource[1] objectAtIndex:indexPath.section];
    }
    
    return [ComplaintsCell heightForDataDict:cellDict isDetail:NO];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == subTableView[0])
    {
        NSDictionary *cellDict = [subTableViewDataSource[0] objectAtIndex:indexPath.section];
        
        ComplaintsCell *cell = [[ComplaintsCell alloc] initWithCellMode:COMPLAINT_CELL_MODE_COMPLAINT dataDict:cellDict isDetail:NO];
        cell.delegate = self;
        
        return cell;
    }
    
    if (tableView == subTableView[1])
    {
        NSDictionary *cellDict = [subTableViewDataSource[1] objectAtIndex:indexPath.section];
        
        ComplaintsCell *cell = [[ComplaintsCell alloc] initWithCellMode:COMPLAINT_CELL_MODE_REPAIR dataDict:cellDict isDetail:NO];
        cell.delegate = self;
        
        return cell;
    }
    
    return nil;
}

- (void) complaintsCell : (ComplaintsCell*) _cell tapSubImageViews : (UIImageView*) tapView allSubImageViews : (NSMutableArray *) _allSubImageviews;
{
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    imageViewer.delegate = self;
    [imageViewer showWithImageViews:_allSubImageviews selectedView:tapView];
}

- (void)imageViewer:(XHImageViewer *)imageViewer  willDismissWithSelectedView:(UIImageView*)selectedView
{
    return ;
}

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction
{
    if (direction == RefreshDirectionTop)
    {
        dataPageIndex[currSegmentIndex] = 0;
        [self requestListBySegmentIndex:currSegmentIndex];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == subTableView[0])
    {
        NSDictionary *cellDict = [subTableViewDataSource[0] objectAtIndex:indexPath.section];
        
        ComplaintsAndRepairDetailViewController *detailViewController = [[ComplaintsAndRepairDetailViewController alloc] initWithDetaiDataDict:cellDict mode:COMPLAINT_CELL_MODE_COMPLAINT];
        
        [self.navigationController pushViewController:detailViewController animated:YES];
        
        return ;
    }
    
    if (tableView == subTableView[1])
    {
        NSDictionary *cellDict = [subTableViewDataSource[1] objectAtIndex:indexPath.section];
        
        ComplaintsAndRepairDetailViewController *detailViewController = [[ComplaintsAndRepairDetailViewController alloc] initWithDetaiDataDict:cellDict mode:COMPLAINT_CELL_MODE_REPAIR];
        
        [self.navigationController pushViewController:detailViewController animated:YES];
        
        return ;
    }
}

#pragma mark UIScrollView Delegate (UITabelView)
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (subTableViewDataSource[currSegmentIndex].count >= totalRecord[currSegmentIndex])
    {
        return ;
    }
    else
    {
        UITableViewCell *lastCell = [subTableView[currSegmentIndex] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:subTableViewDataSource[currSegmentIndex].count - 1]];
        
        if ([subTableView[currSegmentIndex].visibleCells containsObject:lastCell])
        {
            if (hasLoading[currSegmentIndex])
            {
                return ;
            }
            
            dataPageIndex[currSegmentIndex] ++;
            [self requestListBySegmentIndex:currSegmentIndex];
        }
    }
}

@end
