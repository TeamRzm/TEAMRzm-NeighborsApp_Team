//
//  NBRServeiesViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/3/26.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRServeiesViewController.h"
#import "NBRDynamicofPropertyViewController.h"
#import "NBRSmallRosterViewController.h"
#import "ComplaintsAndRepairViewController.h"
#import "PlotCertListViewController.h"
#import "ServerProjectViewController.h"
#import "IndustryCommitteeViewController.h"

#import "CreateRequest_Server.h"
#import "CreaterRequest_Residence.h"
#import "CreaterRequest_Village.h"

#import "RefreshControl.h"



@interface NBRServeiesViewController () <PlotCertListViewControllerDelegate,RefreshControlDelegate>
{
    ASIHTTPRequest  *bannerRequest;
    ASIHTTPRequest  *exchangeVillageRequest;
    
    RefreshControl  *refreshController;
}
@end

@implementation NBRServeiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"服务"];
    [self initSubView];
    [self SetBaseNavigationRightItemWithTitle:@"切换小区"];
    [self requestBanner];
}

#pragma mark Init Method
- (void) requestBanner
{
    bannerRequest = [CreaterRequest_Residence CreateResidenceNewsRequestWithFlag:@"1"
                                                                            size:@""
                                                                           index:@""];
    
    __weak ASIHTTPRequest* blockRequest = bannerRequest;
    
    [blockRequest setCompletionBlock:^{
        [self removeLoadingView];
        NSDictionary *responseDict = blockRequest.responseString.JSONValue;
        
        [refreshController finishRefreshingDirection:RefreshDirectionTop];
        
        if ([CreaterRequest_Residence CheckErrorResponse:responseDict errorAlertInViewController:self])
        {
            scrollDataArr = (NSMutableArray *)[responseDict arrayWithKeyPath:@"data\\result\\data"];
            
            [self CreateHeaderView];
            [myTableview reloadData];
            return ;
        }
        
    }];
    
    [self setDefaultRequestFaild:blockRequest];
    
    [self addLoadingView];
    [blockRequest startAsynchronous];
}

-(void) initSubView
{
    titleNameArr = [[NSMutableArray alloc] init];
    [titleNameArr addObject:[NSArray arrayWithObjects:@"物业动态",@"投诉与报修",@"业委会", nil]];
    [titleNameArr addObject:[NSArray arrayWithObjects:@"物业花名册",@"特约服务", nil]];
    
    logoArr = [[NSMutableArray alloc] init];
    [logoArr addObject:[NSArray arrayWithObjects:@"wuyedongtai",@"tousuyubaoxiu",@"yeweihui", nil]];
    [logoArr addObject:[NSArray arrayWithObjects:@"wuyehuamingce",@"teyuefuwu", nil]];
    

    myTableview =[[UITableView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, kNBR_SCREEN_W, kNBR_SCREEN_H - 64 - 49) style:UITableViewStyleGrouped];
    [myTableview setBackgroundView:nil];
    [myTableview setBackgroundColor:[UIColor clearColor]];
    [myTableview setDelegate:self];
    [myTableview setDataSource:self];
    [myTableview setRowHeight:kNBR_SCREEN_W/3.0f];
    [myTableview setSeparatorColor:[UIColor clearColor]];
    [myTableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    refreshController = [[RefreshControl alloc] initWithScrollView:myTableview delegate:self];
    refreshController.topEnabled = YES;
    
    [self.view addSubview:myTableview];
}

-(void) CreateHeaderView
{
    UIView *headerview = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kNBR_SCREEN_W, 140.0f)];
    
    [myTableview setTableHeaderView:headerview];
    
    headerScrollview = [[UIScrollView alloc] initWithFrame:headerview.frame];
    [headerScrollview setPagingEnabled:YES];
    [headerScrollview setDelegate:self];
    [headerScrollview setShowsHorizontalScrollIndicator:NO];
    [headerScrollview setShowsVerticalScrollIndicator:NO];
    [headerScrollview setContentSize:CGSizeMake(kNBR_SCREEN_W*scrollDataArr.count, headerScrollview.frame.size.height)];
    [headerview addSubview:headerScrollview];
    
    for (int j = 0; j < scrollDataArr.count; j++)
    {
        NSDictionary *subDict = scrollDataArr[j];
        //头像
        EGOImageView *avterImgView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@""]];
        avterImgView.imageURL = [NSURL URLWithString:[subDict stringWithKeyPath:@"image"]];
        avterImgView.frame = CGRectMake(0+j*kNBR_SCREEN_W, 0.0f,kNBR_SCREEN_W,headerScrollview.frame.size.height);
        avterImgView.tag = j;
        [avterImgView setContentMode:UIViewContentModeScaleAspectFill];
        [headerScrollview addSubview:avterImgView];
    }
    
    UIView *bottonview = [[UIView alloc] initWithFrame:CGRectMake(0.0f, headerview.frame.size.height-20.0f, kNBR_SCREEN_W, 20.0f)];
    [bottonview setBackgroundColor:[UIColor whiteColor]];
    [bottonview setAlpha:0.7];
    [headerview addSubview:bottonview];
    
     pagcontrol = [[UIPageControl alloc] initWithFrame:bottonview.frame];
    [pagcontrol setNumberOfPages:scrollDataArr.count];
    [pagcontrol setCurrentPageIndicatorTintColor:kNBR_ProjectColor_DeepGray];
    [pagcontrol setPageIndicatorTintColor:kNBR_ProjectColor_MidGray];
    [pagcontrol addTarget:self action:@selector(PageValueChange:) forControlEvents:UIControlEventValueChanged];
    [pagcontrol setCurrentPage:0];
    [headerview addSubview:pagcontrol];
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titleNameArr count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    NSArray *subnameArr = titleNameArr[indexPath.row];
    NSArray *sublogoArr = logoArr[indexPath.row];
    for (int i =0; i<[subnameArr count]; i++)
    {
        UIView *contentview = [[UIView alloc] initWithFrame:CGRectMake(0.0f+i*kNBR_SCREEN_W/3, 0.0f, kNBR_SCREEN_W/3.0f, kNBR_SCREEN_W/3.0f)];
        [contentview setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:contentview];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ItemLogoClicked:)];
        [contentview setUserInteractionEnabled:YES];
        [contentview addGestureRecognizer:gesture];
        [contentview setTag:(indexPath.row*3+i)];
        
        //头像
        UIImageView *logoview = [[UIImageView alloc] initWithFrame:CGRectMake(kNBR_SCREEN_W/6-74/2, 10.0f, 74.0f, 74.0f)];
        [logoview setImage:[UIImage imageNamed:sublogoArr[i]]];
        [contentview addSubview:logoview];
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, logoview.frame.origin.y+5.0f+logoview.frame.size.height, contentview.frame.size.width,20.0f)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setFont:[UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:14.0f]];
        [titleLabel setTextColor:kNBR_ProjectColor_DeepGray];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setText:subnameArr[i]];
        [contentview addSubview:titleLabel];
    }
    
    return cell;
    
}

#pragma mark gesture Method
-(void) ItemLogoClicked:(UIGestureRecognizer *) _gesture
{
    NSLog(@"_gesture tag == %d",_gesture.view.tag);
    switch (_gesture.view.tag)
    {
        case 0:
        {
            NBRDynamicofPropertyViewController *dynamicview = [[NBRDynamicofPropertyViewController alloc] initWithMode:DYNAMICO_PROPERTY_VIEWCONTROLLER_MODE_ZONE];
            [dynamicview setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:dynamicview animated:YES];
            
        }
            break;
            
        case 2:
        {
            IndustryCommitteeViewController *dynamicview = [[IndustryCommitteeViewController alloc] initWithNibName:@"IndustryCommitteeViewController" bundle:nil];
            [dynamicview setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:dynamicview animated:YES];
        }
            break;
            
        case 1:
        {
            ComplaintsAndRepairViewController *dynamicview = [[ComplaintsAndRepairViewController alloc] initWithNibName:nil bundle:nil];
            [dynamicview setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:dynamicview animated:YES];
        }
            break;
            
        case 3:
        {
            NBRSmallRosterViewController *rosterview = [[NBRSmallRosterViewController alloc] initWithNibName:nil bundle:nil];
            [rosterview setHidesBottomBarWhenPushed:YES];

            [self.navigationController pushViewController:rosterview animated:YES];
            
        }
            break;
            
        case 4:
        {
            ServerProjectViewController *rosterview = [[ServerProjectViewController alloc] initWithNibName:nil bundle:nil];
            [rosterview setHidesBottomBarWhenPushed:YES];
            
            [self.navigationController pushViewController:rosterview animated:YES];
            
        }
            break ;

            
        default:
            [self showBannerMsgWithString:@"功能开发过程中"];
            break;
    }
}

#pragma mark Navigation Method
-(void) SetBaseNavigationRightItemWithTitle:(NSString *) title
{
    UIButton *rightbt = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbt setFrame:CGRectMake(0.0f, 0.0f, 90.0f, 30.0f)];
    UIImage *image = [UIImage imageNamed:@"bg_btnbg_pressed"];
    image = [image stretchableImageWithLeftCapWidth:5.0f topCapHeight:25.0f];
    [rightbt setBackgroundColor:[UIColor colorWithPatternImage:image]];
    [rightbt setBackgroundColor:kNBR_ProjectColor_StandBlue];
    [rightbt setTitle:title forState:UIControlStateNormal];
    [rightbt.layer setCornerRadius:4.0f];
    UIFont *font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:14.0f];
    [rightbt setTitleColor:kNBR_ProjectColor_StandWhite forState:UIControlStateNormal];
    [rightbt.titleLabel setFont:font];
    [rightbt sizeToFit];
    [rightbt addTarget:self action:@selector(BaseNavigatinRightItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightbt setFrame:CGRectMake(0.0f, 0.0f, rightbt.frame.size.width+15.0f, 30.0f)];
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithCustomView:rightbt];
    [self.navigationItem setRightBarButtonItem:rightitem];
}

-(void) BaseNavigatinRightItemClicked:(UIButton *) sender
{
    PlotCertListViewController *plotCertSelectViewController = [[PlotCertListViewController alloc] initWithSelect:YES selectDelegate:self];

    plotCertSelectViewController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:plotCertSelectViewController animated:YES];
}

#pragma mark scrollview delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger current = scrollView.contentOffset.x/kNBR_SCREEN_W;
    [pagcontrol setCurrentPage:current];
}

-(void) PageValueChange:(UIPageControl *) sender
{
    [headerScrollview setContentOffset:CGPointMake(sender.currentPage*kNBR_SCREEN_W, 0.0f) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) plotCertListViewController : (PlotCertListViewController*) viewController selectAddressDict : (NSDictionary *) _dict
{
    exchangeVillageRequest = [CreaterRequest_Village CreateExchangeRequestWithID:_dict[@"villageId"]];
    
    __weak ASIHTTPRequest *blockRequest = exchangeVillageRequest;
    
    [blockRequest setCompletionBlock:^{
        [self removeLoadingView];
        NSDictionary *responseDict = blockRequest.responseString.JSONValue;
        
        if ([CreaterRequest_Village CheckErrorResponse:responseDict errorAlertInViewController:self])
        {
            [self showBannerMsgWithString:[responseDict stringWithKeyPath:@"data\\code\\message"]];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            [self requestBanner];
            
            return ;
        }
        
    }];

    [self setDefaultRequestFaild:blockRequest];
    
    [self addLoadingView];
    [blockRequest startAsynchronous];
    
    return ;
}

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction
{
    //刷新
    if (direction == RefreshDirectionTop)
    {
        [self requestBanner];
    }
}

@end
