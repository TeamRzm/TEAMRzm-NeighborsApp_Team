//
//  ComplaintsAndRepairDetailViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/24.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "ComplaintsAndRepairDetailViewController.h"
#import "ComplaintsCell.h"
#import "ComplaintsStateCell.h"
#import "CreaterRequest_Complaint.h"
#import "XHImageViewer.h"

@interface ComplaintsAndRepairDetailViewController ()<UITableViewDataSource, UITableViewDelegate,ComplaintsCellDelegate,XHImageViewerDelegate>
{
    UITableView *boundTableView;
    
    NSMutableArray  *boundDataSource;
    
    NSDictionary    *detailDataSource;
    
    ASIHTTPRequest  *complaintStateRequest;
    
    COMPLAINT_CELL_MODE detailMode;
}

@end

@implementation ComplaintsAndRepairDetailViewController

- (void) requestState
{
    complaintStateRequest = [CreaterRequest_Complaint CreateComplaintStateRequestWithId:detailDataSource[@"complaintId"]];
    
    __weak ASIHTTPRequest* blockRequest = complaintStateRequest;
    
    [blockRequest setCompletionBlock:^{
        
        [self removeLoadingView];
        
        NSDictionary *resposneDict = blockRequest.responseString.JSONValue;
        
        if ([CreaterRequest_Complaint CheckErrorResponse:resposneDict errorAlertInViewController:self])
        {
            boundDataSource = [[NSMutableArray alloc] initWithArray:@[
                                                                      @[detailDataSource],
                                                                      [resposneDict arrayWithKeyPath:@"data\\result"],
                                                                      ]];
            [self addBottomView];
            [boundTableView reloadData];
            
            return ;
        }
        
    }];
    
    [self setDefaultRequestFaild:blockRequest];
    
    [blockRequest startAsynchronous];
    [self addLoadingView];
}

- (id) initWithDetaiDataDict : (NSDictionary*) dataDict mode : (COMPLAINT_CELL_MODE) _mode
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self)
    {
        detailDataSource = dataDict;
        detailMode = _mode; 
    }
    return self;
}

- (void) addBottomView
{
    //view bottomView
    UIView *viewControllerBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kNBR_SCREEN_H - 50, kNBR_SCREEN_W, 50)];
    viewControllerBottomView.backgroundColor = [UIColor whiteColor];
    [viewControllerBottomView addBreakLineWithPosition:VIEW_BREAKLINE_POSITION_TOP style:VIEW_BREAKLINE_STYLE_SOLID width:kNBR_SCREEN_W];
    [viewControllerBottomView addBreakLineWithPosition:VIEW_BREAKLINE_POSITION_BOTTOM style:VIEW_BREAKLINE_STYLE_SOLID width:kNBR_SCREEN_W];
    
//    UILabel *helpButton = [[UILabel alloc] initWithFrame:CGRectMake(kNBR_SCREEN_W / 2.0f - (70 + 110 + 10) / 2.0f,
//                                                                    50.0f / 2.0f - 30.0f / 2.0f,
//                                                                    70.0f, 30.0f)];
//    helpButton.layer.cornerRadius = 3.0f;
//    helpButton.layer.borderWidth = 1.0f;
//    helpButton.layer.borderColor = kNBR_ProjectColor_DeepBlack.CGColor;
//    helpButton.layer.masksToBounds = YES;
//    helpButton.textColor = kNBR_ProjectColor_DeepBlack;
//    helpButton.text = @"帮助";
//    helpButton.textAlignment = NSTextAlignmentCenter;
//    helpButton.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:14.0f];
//    helpButton.userInteractionEnabled = YES;
//    [viewControllerBottomView addSubview:helpButton];
    
    UILabel *comentButton = [[UILabel alloc] initWithFrame:CGRectMake(kNBR_SCREEN_W / 2.0f - 110.0f / 2.0f,
                                                                      50.0f / 2.0f - 30.0f / 2.0f,
                                                                      110.0f, 30.0f)];
    comentButton.layer.cornerRadius = 3.0f;
    comentButton.layer.borderWidth = 1.0f;
    comentButton.layer.borderColor = kNBR_ProjectColor_StandBlue.CGColor;
    comentButton.layer.masksToBounds = YES;
    comentButton.textColor = kNBR_ProjectColor_StandBlue;
    comentButton.text = @"我要评论";
    comentButton.textAlignment = NSTextAlignmentCenter;
    comentButton.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:14.0f];
    comentButton.userInteractionEnabled = YES;
    [viewControllerBottomView addSubview:comentButton];
    
    [self.view addSubview:viewControllerBottomView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (detailMode == COMPLAINT_CELL_MODE_COMPLAINT)
    {
        self.title = @"投诉详情";
    }
    else if (detailMode == COMPLAINT_CELL_MODE_REPAIR)
    {
        self.title = @"报修详情";
    }
    
    boundTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, kNBR_SCREEN_H - 50) style:UITableViewStyleGrouped];
    boundTableView.dataSource = self;
    boundTableView.delegate = self;
    boundTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    boundTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:boundTableView];
    
    [self requestState];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITabelView Delegate
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, 35)];
    headView.backgroundColor = kNBR_ProjectColor_BackGroundGray;
    
    if (section == 0)
    {
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0, kNBR_SCREEN_W - 20, 35)];
        titleLable.textAlignment = NSTextAlignmentLeft;
        titleLable.textColor = kNBR_ProjectColor_DeepBlack;
        titleLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:13.0f];
        
        if (detailMode == COMPLAINT_CELL_MODE_COMPLAINT)
        {
            titleLable.text = [NSString stringWithFormat:@"投诉号：%@",detailDataSource[@"complaintId"]];
        }
        else if (detailMode == COMPLAINT_CELL_MODE_REPAIR)
        {
            titleLable.text = [NSString stringWithFormat:@"报修号：%@",detailDataSource[@"complaintId"]];
        }
        
        [headView addSubview:titleLable];
        
        NSString *stateString = @"";
        
        switch ([detailDataSource numberWithKeyPath:@"state"])
        {
            case 0: stateString = @"未处理"; break ;
            case 1: stateString = @"处理中"; break ;
            case 2: stateString = @"拒绝处理"; break ;
            case 3: stateString = @"投诉已经关闭"; break ;
            case 4: stateString = @"处理成功"; break ;
                
                break;
                
            default:
                break;
        }
        
        UILabel *stateLable = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0, kNBR_SCREEN_W - 20, 35)];
        stateLable.textAlignment = NSTextAlignmentRight;
        stateLable.textColor = kNBR_ProjectColor_DeepGray;
        stateLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:13.0f];
        stateLable.text = stateString;
        
        [headView addSubview:stateLable];
    }
    else if (section == 1)
    {
        if (boundDataSource.count > 1)
        {
            UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0, kNBR_SCREEN_W - 20, 35)];
            titleLable.textAlignment = NSTextAlignmentLeft;
            titleLable.textColor = kNBR_ProjectColor_DeepBlack;
            titleLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:13.0f];
            titleLable.text = @"投诉进度";
            [headView addSubview:titleLable];
        }
    }
    
    [headView addBreakLineWithPosition:VIEW_BREAKLINE_POSITION_TOP style:VIEW_BREAKLINE_STYLE_SOLID width:kNBR_SCREEN_W];
    [headView addBreakLineWithPosition:VIEW_BREAKLINE_POSITION_BOTTOM style:VIEW_BREAKLINE_STYLE_SOLID width:kNBR_SCREEN_W];
    
    return headView;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return boundDataSource.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray*)boundDataSource[section]).count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        NSDictionary *cellDict = boundDataSource[indexPath.section][indexPath.row];
        return [ComplaintsCell heightForDataDict:cellDict isDetail:YES];
    }
    else if (indexPath.section == 1)
    {
        return 50.0f;
    }
    return 44.0f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        NSDictionary *cellDict = boundDataSource[indexPath.section][indexPath.row];
        
        ComplaintsCell *cell = [[ComplaintsCell alloc] initWithCellMode:COMPLAINT_CELL_MODE_REPAIR dataDict:cellDict isDetail:YES];
        cell.delegate = self;
        
        return cell;
    }
    else if (indexPath.section == 1)
    {
        NSDictionary *cellDict = boundDataSource[indexPath.section][indexPath.row];
        
        ComplaintsStateCell *cell = [[ComplaintsStateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
        
        if (((NSArray*)boundDataSource[indexPath.section]).lastObject == cellDict)
        {
            [cell addBreakLineWithStyle:VIEW_BREAKLINE_STYLE_SOLID postion:CGPointMake(0, 50) width:kNBR_SCREEN_W];
        }
        else
        {
            [cell addBreakLineWithStyle:VIEW_BREAKLINE_STYLE_SOLID postion:CGPointMake(60, 50) width:kNBR_SCREEN_W - 50];
        }
        
        [cell setDateDict:cellDict isAction:!((BOOL)indexPath.row)];
        
        return cell;
    }
    else if (indexPath.section == 2)
    {
        return nil;
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


@end
