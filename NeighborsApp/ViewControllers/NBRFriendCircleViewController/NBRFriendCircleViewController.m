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

@interface NBRFriendCircleViewController ()<UITableViewDataSource,UITableViewDelegate,CommentTableViewCellDelegate,XHImageViewerDelegate>
{
    UIScrollView    *boundScrollView;
    UITableView     *subTableView[3];
    UILabel         *segmentLabel[3];
    
    UIView *segmentChangedView;
    UIView *selectTagView;
    
    NSInteger     currentSegmentIndex;
}
@end

@implementation NBRFriendCircleViewController

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//    CGFloat newValue = (CGFloat)(change[@"new"]);
//    CGFloat oldValue = (CGFloat)(change[@"old"]);
//    
//    
//    
//    return ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kNBR_ProjectColor_BackGroundGray;
    
#ifdef CONFIG_TEST_DATE
//    [self initTestDate];
#endif
    
    //容器
    boundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + 40, kNBR_SCREEN_W, kNBR_SCREEN_H - 64 - 40 - 49)];
    boundScrollView.contentSize = CGSizeMake(kNBR_SCREEN_W * 2.0f, kNBR_SCREEN_H);
    boundScrollView.scrollEnabled = NO;
    boundScrollView.showsHorizontalScrollIndicator = NO;
    boundScrollView.pagingEnabled = YES;
//    [boundScrollView addObserver:self forKeyPath:@"contentOffset.x" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    segmentChangedView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kNBR_SCREEN_W, 40.0f)];
    
    for (int i = 0; i < 3; i++)
    {
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
    return 10.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (subTableView[1] == tableView)
    {
        return 5.0f;
    }
    return 0.0f;
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (subTableView[1] == tableView && section == 0)
    {
        return 10.0f;
    }
    else if (subTableView[1] == tableView)
    {
        return 5.0f;
    }
    return 0.1f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == subTableView[0] || tableView == subTableView[2])
    {
        FriendCircleContentEntity *entity = [[FriendCircleContentEntity alloc] init];
        entity.avterURL = @"t_avter_9";
        entity.content = @"《规定》深入贯彻习主席系列重要讲话精神特别是关于加强纪律建设的重要指示，紧紧围绕实现党在新形势下的强军目标，认真落实依法治军、从严治军要求，对严格军队党员领导干部纪律约束作出明确规定，是新形势下严格党员领导干部纪律约束、加强军队纪律建设的重要指导性文件。";
        entity.contentImgURLList = @[@"t_avter_5",@"t_avter_6",@"t_avter_7",@"t_avter_8",@"t_avter_1",@"t_avter_2",@"t_avter_3",@"t_avter_4",@"t_avter_0"];
        entity.address = @"新家园小区";
        entity.nickName = @"邻家小妹";
        entity.commitDate = @"5分钟前";
        entity.lookCount = @"2031";
        entity.pointApproves = @"232";
        entity.commentCount = @"14";
        
        return [CommentTableViewCell heightWithEntity:entity];
    }
    else if (tableView == subTableView[1])
    {
        ActivityDateEntity *entity = [[ActivityDateEntity alloc] init];
        entity.backGounrdUrl = @"testActityBackGound";
        entity.regDate = @"4月1日－4月30日";
        entity.leftTagStr = @"16/20";
        entity.titile = @"小区相亲大会";
        entity.commitDate = @"2014年3月25日";
        entity.price = @"0";
        entity.activityState = ACTIVITY_STATE_STARTING;
        
        return [ActivityTableViewCell heightWithEntity:entity];
    }
    return 0.0f;
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == subTableView[0] || tableView == subTableView[2])
    {
        CommentTableViewCell *cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
        cell.delegate = self;
        FriendCircleContentEntity *entity = [[FriendCircleContentEntity alloc] init];
        entity.avterURL = @"t_avter_9";
        entity.content = @"《规定》深入贯彻习主席系列重要讲话精神特别是关于加强纪律建设的重要指示，紧紧围绕实现党在新形势下的强军目标，认真落实依法治军、从严治军要求，对严格军队党员领导干部纪律约束作出明确规定，是新形势下严格党员领导干部纪律约束、加强军队纪律建设的重要指导性文件。";
        entity.contentImgURLList = @[@"t_avter_5",@"t_avter_6",@"t_avter_7",@"t_avter_8",@"t_avter_1",@"t_avter_2",@"t_avter_3",@"t_avter_4",@"t_avter_0"];
        entity.address = @"新家园小区";
        entity.nickName = @"邻家小妹";
        entity.commitDate = @"5分钟前";
        entity.lookCount = @"2031";
        entity.pointApproves = @"232";
        entity.commentCount = @"14";
        [cell setDateEntity:entity];
        return cell;
    }
    else
    {
        ActivityDateEntity *entity = [[ActivityDateEntity alloc] init];
        entity.backGounrdUrl = @"testActityBackGound";
        entity.regDate = @"4月1日－4月30日";
        entity.leftTagStr = @"16/20";
        entity.titile = @"小区相亲大会";
        entity.commitDate = @"2014年3月25日";
        entity.price = @"0";
        entity.activityState = ACTIVITY_STATE_STARTING;

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


@end
