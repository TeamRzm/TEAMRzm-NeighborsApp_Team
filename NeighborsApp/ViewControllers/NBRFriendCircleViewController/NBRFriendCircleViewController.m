//
//  NBRFriendCircleViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/3/26.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRFriendCircleViewController.h"
#import "CommentTableViewCell.h"
#import "ActivityTableViewCell.h"
#import "CommitNewContentViewController.h"
#import "CommitActivityContentViewController.h"
#import "XHImageViewer.h"
#import "ComentDetailViewController.h"
#import "ActivityDetailViewController.h"

#import "CreaterRequest_Logroll.h"
#import "CreaterRequest_Activity.h"
#import "CreaterRequest_Show.h"

@interface NBRFriendCircleViewController ()<UITableViewDataSource,UITableViewDelegate,CommentTableViewCellDelegate,XHImageViewerDelegate>
{
    UIScrollView    *boundScrollView;
    UITableView     *subTableView[3];
    UILabel         *segmentLabel[3];
    
    UIView *segmentChangedView;
    UIView *selectTagView;
    
    NSInteger     currentSegmentIndex;
    
    NSMutableArray  *boundTableViewDateSource[3];
    NSInteger       dataIndex[3];
    
    ASIHTTPRequest  *listRequest[3];
    
    FRIENDCIRCLECONTROLLER_MODE viewControllerMode;
}
@end

@implementation NBRFriendCircleViewController

- (id) initWithMode : (FRIENDCIRCLECONTROLLER_MODE) _mode
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self)
    {
        viewControllerMode = _mode;
    }
    return self;
}

- (void) configViewControllerMode
{
    switch (viewControllerMode)
    {
        case FRIENDCIRCLECONTROLLER_MODE_NONE:
        case FRIENDCIRCLECONTROLLER_MODE_NOMAL:
        {
            [self requestList0WithType:@"0"];
            [self requestList0WithType:@"1"];
            [self requestList1WithFlag:@"0"];
        }
            break;
            
        case FRIENDCIRCLECONTROLLER_MODE_LOROLL:
        {
            [self requestList0WithType:@"0"];
            
            boundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, kNBR_SCREEN_H)];
            boundScrollView.contentSize = CGSizeMake(kNBR_SCREEN_W * 1.0f, kNBR_SCREEN_H);
            boundScrollView.contentOffset = CGPointMake(kNBR_SCREEN_W * 0.0f, 0);
            
            for (int i = 0; i < 3; i++)
            {
                [segmentLabel[i] removeFromSuperview];
            }
        }
            break;
            
        case FRIENDCIRCLECONTROLLER_MODE_ACTIVITY:
        {
            [self requestList1WithFlag:@"1"];
            
            boundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, kNBR_SCREEN_H)];
            boundScrollView.contentSize = CGSizeMake(kNBR_SCREEN_W * 2.0f, kNBR_SCREEN_H);
            boundScrollView.contentOffset = CGPointMake(kNBR_SCREEN_W * 1.0f, 0);
            
            for (int i = 0; i < 3; i++)
            {
                [segmentLabel[i] removeFromSuperview];
            }
        }
            break;
            
        case FRIENDCIRCLECONTROLLER_MODE_WARNNING:
        {
            [self requestList0WithType:@"1"];
            
            boundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, kNBR_SCREEN_H)];
            boundScrollView.contentSize = CGSizeMake(kNBR_SCREEN_W * 3.0f, kNBR_SCREEN_H);
            boundScrollView.contentOffset = CGPointMake(kNBR_SCREEN_W * 2.0f, 0);
            
            for (int i = 0; i < 3; i++)
            {
                [segmentLabel[i] removeFromSuperview];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kNBR_ProjectColor_BackGroundGray;
    
    //容器
    boundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + 40, kNBR_SCREEN_W, kNBR_SCREEN_H - 64 - 40 - 49)];
    boundScrollView.contentSize = CGSizeMake(kNBR_SCREEN_W * 3.0f, kNBR_SCREEN_H);
    boundScrollView.scrollEnabled = NO;
    boundScrollView.showsHorizontalScrollIndicator = NO;
    boundScrollView.pagingEnabled = YES;
    
    segmentChangedView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kNBR_SCREEN_W, 40.0f)];
    
    for (int i = 0; i < 3; i++)
    {
        //datesource
        boundTableViewDateSource[i] = [[NSMutableArray alloc] init];
        
        //segment
        segmentLabel[i] = [[UILabel alloc] initWithFrame:CGRectMake(i * kNBR_SCREEN_W / 3.0f, 0, kNBR_SCREEN_W / 3.0f, 40.0f)];
        segmentLabel[i].font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:13.0f];
        segmentLabel[i].textAlignment = NSTextAlignmentCenter;
        segmentLabel[i].textColor = kNBR_ProjectColor_DeepGray;
        segmentLabel[i].backgroundColor = kNBR_ProjectColor_BackGroundGray;
        segmentLabel[i].text = @[@"里手帮",@"活动召集",@"安全预警"][i];
        segmentLabel[i].userInteractionEnabled = YES;
        segmentLabel[i].tag = i;
        UITapGestureRecognizer *leftChangedGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(segmentChangedWithIndex:)];
        [segmentLabel[i] addGestureRecognizer:leftChangedGesture];
        [segmentChangedView addSubview:segmentLabel[i]];
        
        //表格
        subTableView[i] = [[UITableView alloc] initWithFrame:CGRectMake(i * kNBR_SCREEN_W, 0, kNBR_SCREEN_W, kNBR_SCREEN_H - 64 - 40 - 49) style:UITableViewStyleGrouped];
        subTableView[i].backgroundColor = kNBR_ProjectColor_BackGroundGray;
        subTableView[i].delegate = self;
        subTableView[i].dataSource = self;
        [boundScrollView addSubview:subTableView[i]];
    }
    
    //单独配置表格
    [subTableView[1] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UIView *breakLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, kNBR_SCREEN_W, 1.0f)];
    breakLineView.backgroundColor = UIColorFromRGB(0xCBD3DB);		
    
    selectTagView = [[UIView alloc] initWithFrame:CGRectMake(0, 38.0f, kNBR_SCREEN_W / 3.0f, 2.0f)];
    selectTagView.backgroundColor = kNBR_ProjectColor_StandBlue;
    
    [segmentChangedView addSubview:breakLineView];
    [segmentChangedView addSubview:selectTagView];
    [self.view addSubview:segmentChangedView];
    [self.view addSubview:boundScrollView];
    
    
    //右上角的发布按钮
    UIBarButtonItem *rightAddItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tianjia01"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarbuttonAction:)];
    self.navigationItem.rightBarButtonItem = rightAddItem;
    
    [self configViewControllerMode];
    
    return ;
}

- (void) rightBarbuttonAction : (id) sender
{
    switch (currentSegmentIndex)
    {
        case 0:
        {
            CommitNewContentViewController *nVC = [[CommitNewContentViewController alloc] initWithNibName:nil bundle:nil];
            nVC.title = @"发布里手帮";
            nVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:nVC animated:YES];
        }
            break;

        case 1:
        {
            CommitActivityContentViewController *nVC = [[CommitActivityContentViewController alloc] initWithNibName:nil bundle:nil];
            nVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:nVC animated:YES];
            
        }
            break;

        case 2:
        {
            CommitNewContentViewController *nVC = [[CommitNewContentViewController alloc] initWithNibName:nil bundle:nil];
            nVC.title = @"发布安全预警";
            nVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:nVC animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    return ;
}

- (void) segmentChangedWithIndex : (UITapGestureRecognizer*) gesture
{
    currentSegmentIndex = gesture.view.tag;
    
    [boundScrollView setContentOffset:CGPointMake(currentSegmentIndex * kNBR_SCREEN_W, 0) animated:YES];
    
    [UIView animateWithDuration:.25f animations:^{
        selectTagView.frame = CGRectMake(currentSegmentIndex * kNBR_SCREEN_W / 3.0f, 38.0f, kNBR_SCREEN_W / 3.0f, 2.0f);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == subTableView[0])
    {
        return boundTableViewDateSource[0].count;
    }
    else if (tableView == subTableView[1])
    {
        return boundTableViewDateSource[1].count;
    }
    else if (tableView == subTableView[2])
    {
        return boundTableViewDateSource[2].count;
    }

    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger tableIndex = 0;
    
    if (tableView == subTableView[0]) tableIndex = 0;
    if (tableView == subTableView[1]) tableIndex = 1;
    if (tableView == subTableView[2]) tableIndex = 2;
    
    if(tableView == subTableView[0] || tableView == subTableView[2])
    {
        FriendCircleContentEntity *entity = boundTableViewDateSource[tableIndex][indexPath.row];

        return [CommentTableViewCell heightWithEntity:entity];
    }
    else if (tableView == subTableView[1])
    {
        ActivityDateEntity *entity = boundTableViewDateSource[tableIndex][indexPath.row];
        
        return [ActivityTableViewCell heightWithEntity:entity];
    }
    return 0.0f;
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger tableIndex = 0;
    
    if (tableView == subTableView[0]) tableIndex = 0;
    if (tableView == subTableView[1]) tableIndex = 1;
    if (tableView == subTableView[2]) tableIndex = 2;
    
    if(tableView == subTableView[0] || tableView == subTableView[2])
    {
        FriendCircleContentEntity *entity = boundTableViewDateSource[tableIndex][indexPath.row];
        CommentTableViewCell *cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
        cell.delegate = self;
        [cell setDateEntity:entity];
        return cell;
    }
    else
    {
        ActivityDateEntity *entity = boundTableViewDateSource[tableIndex][indexPath.row];
        
        ActivityTableViewCell *cell = [[ActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
        
        [cell configWithEntity:entity];
        
        return cell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (currentSegmentIndex == 0 || currentSegmentIndex == 2)
    {
        ComentDetailViewController *nVC = [[ComentDetailViewController alloc] initWithNibName:nil bundle:nil];
        nVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:nVC animated:YES];
    }
    else if (currentSegmentIndex == 1)
    {
        ActivityDetailViewController *nVC = [[ActivityDetailViewController alloc] initWithNibName:nil bundle:nil];
        nVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:nVC animated:YES];
    }
    
    return ;
}

- (void) commentTableViewCell : (CommentTableViewCell*) _cell tapSubImageViews : (UIImageView*) tapView allSubImageViews : (NSMutableArray *) _allSubImageviews
{
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    imageViewer.delegate = self;
    [imageViewer showWithImageViews:_allSubImageviews selectedView:tapView];
}

- (void)imageViewer:(XHImageViewer *)imageViewer  willDismissWithSelectedView:(UIImageView*)selectedView
{
    
    return ;
}

#pragma mark Request

- (void) requestList0WithType : (NSString*) _type
{
    NSInteger requestIndex = _type.integerValue == 0 ? 0 : 2;
    
    listRequest[requestIndex] = [CreaterRequest_Show CreateShowListRequestWithIndex:ITOS(dataIndex[1]) size:kNBR_PAGE_SIZE_STR type:_type];
    
    __weak ASIHTTPRequest *blockRequest = listRequest[requestIndex];
    
    [blockRequest setCompletionBlock:^{
        [self removeLoadingView];
        NSDictionary *responseDict = [blockRequest.responseString JSONValue];
        
        if ([CreaterRequest_Show CheckErrorResponse:responseDict errorAlertInViewController:self])
        {
            NSMutableArray *newContentArr = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < [responseDict arrayWithKeyPath:@"data\\result\\data"].count; i++)
            {
                NSDictionary *entityDict = [responseDict arrayWithKeyPath:@"data\\result\\data"][i];
                
                FriendCircleContentEntity *newContentEntity = [[FriendCircleContentEntity alloc] init];
                
                NSMutableArray *imageList = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < [entityDict arrayWithKeyPath:@"files"].count; i++)
                {
                    [imageList addObject:[((NSDictionary*)([entityDict arrayWithKeyPath:@"files"][i])) stringWithKeyPath:@"url"]];
                }
                
                NSString *createdTime = [entityDict stringWithKeyPath:@"created"];
                
                newContentEntity.avterURL           = [entityDict stringWithKeyPath:@"userInfo\\avatar"];
                newContentEntity.nickName           = [entityDict stringWithKeyPath:@"userInfo\\nickName"];
                newContentEntity.content            = [entityDict stringWithKeyPath:@"content"];
                newContentEntity.contentImgURLList  = imageList;
                newContentEntity.address            = [entityDict stringWithKeyPath:@"village\\name"];
                newContentEntity.commitDate         = [self nowDateStringForDistanceDateString:createdTime];
                newContentEntity.lookCount          = ITOS([entityDict numberWithKeyPath:@"views"]);
                newContentEntity.commentCount       = ITOS([entityDict numberWithKeyPath:@"posts"]);;
                newContentEntity.pointApproves      = @"";
                [newContentArr addObject:newContentEntity];
            }
            
            NSMutableArray *insertIndexPath = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < newContentArr.count; i++)
            {
                [insertIndexPath addObject:[NSIndexPath indexPathForRow:boundTableViewDateSource[requestIndex].count + i inSection:0]];
            }
            
            [boundTableViewDateSource[requestIndex] addObjectsFromArray:newContentArr];
            [subTableView[requestIndex] insertRowsAtIndexPaths:insertIndexPath withRowAnimation:UITableViewRowAnimationAutomatic];
            
            return ;
        }
    }];
    
    [self setDefaultRequestFaild:blockRequest];
    
    [blockRequest startAsynchronous];
    [self addLoadingView];
    
}

- (void) requestList1WithFlag : (NSString*) _flag
{
    listRequest[1] = [CreaterRequest_Activity CreateActivityRequestWithIndex:ITOS(dataIndex[1]) size:kNBR_PAGE_SIZE_STR flag:_flag];
    
    __weak ASIHTTPRequest *blockRequest = listRequest[1];
    
    [listRequest[1] setCompletionBlock:^{
        NSDictionary *responseDict = [blockRequest.responseString JSONValue];
        
        if ([CreaterRequest_Activity CheckErrorResponse:responseDict errorAlertInViewController:self])
        {
            NSArray *activityListDictArr = [responseDict arrayWithKeyPath:@"data\\result\\data"];
            
            NSMutableArray *newActivityArr = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < activityListDictArr.count; i++)
            {
                NSDictionary *subActivityDict = activityListDictArr[i];
                
                NSDateFormatter *mmddFormater = [[NSDateFormatter alloc] init];
                mmddFormater.dateFormat = @"M月d日";
                
                NSDateFormatter *YYMMdHmsFormater = [[NSDateFormatter alloc] init];
                YYMMdHmsFormater.dateFormat = @"YY年M月d日 HH:mm:ss";

                NSDate *regStrDate = [self dateWithString:[subActivityDict stringWithKeyPath:@"registerStart"]];
                NSDate *regEndDate = [self dateWithString:[subActivityDict stringWithKeyPath:@"registerEnd"]];
                NSDate *nowDate = [NSDate date];
                
                ActivityDateEntity *newActivityEntity = [[ActivityDateEntity alloc] init];
                newActivityEntity.backGounrdUrl = @"testActityBackGound"; //图片暂时全部默认
                newActivityEntity.regDate = [NSString
                                             stringWithFormat:@"%@-%@",
                                             [mmddFormater stringFromDate:regStrDate],
                                             [mmddFormater stringFromDate:regEndDate]];
                
                newActivityEntity.leftTagStr = [NSString
                                                stringWithFormat:@"%d/%d", [subActivityDict
                                                                            stringWithKeyPath:@"applies"].integerValue, [subActivityDict
                                                                                                                         stringWithKeyPath:@"joins"].integerValue];
                
                newActivityEntity.titile = [subActivityDict stringWithKeyPath:@"title"];
                newActivityEntity.commitDate = [YYMMdHmsFormater
                                                stringFromDate:[self
                                                                dateWithString:[subActivityDict
                                                                                stringWithKeyPath:@"created"]]];
                
                newActivityEntity.price = [subActivityDict stringWithKeyPath:@"fee"];
                
                
                NSDate *strDate = [self dateWithString:[subActivityDict stringWithKeyPath:@"startDate"]];
                NSDate *endDate = [self dateWithString:[subActivityDict stringWithKeyPath:@"endDate"]];
                
                if ([nowDate timeIntervalSince1970] > [regStrDate timeIntervalSince1970] &&
                    [nowDate timeIntervalSince1970] < [regEndDate timeIntervalSince1970])
                {
                    newActivityEntity.activityState = ACTIVITY_STATE_RES;
                }
                
                if ([nowDate timeIntervalSince1970] > [strDate timeIntervalSince1970] &&
                    [nowDate timeIntervalSince1970] < [endDate timeIntervalSince1970])
                {
                    newActivityEntity.activityState = ACTIVITY_STATE_STARTING;
                }
                
                if ([nowDate timeIntervalSince1970] > [endDate timeIntervalSince1970])
                {
                    newActivityEntity.activityState = ACTIVITY_STATE_END;
                }
                
                if ([subActivityDict numberWithKeyPath:@"flag"] != 0)
                {
                    newActivityEntity.activityState = ACTIVITY_STATE_VAIL;
                }
                
                [newActivityArr addObject:newActivityEntity];
            }
            
            NSMutableArray *insertIndexPath = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < newActivityArr.count; i++)
            {
                [insertIndexPath addObject:[NSIndexPath indexPathForRow:boundTableViewDateSource[1].count + i inSection:0]];
            }
            
            [boundTableViewDateSource[1] addObjectsFromArray:newActivityArr];
            [subTableView[1] insertRowsAtIndexPaths:insertIndexPath withRowAnimation:UITableViewRowAnimationAutomatic];

            return ;
        }
    }];
    
    [self setDefaultRequestFaild:listRequest[1]];
    [self addLoadingView];
    [listRequest[1] startAsynchronous];
}

@end
