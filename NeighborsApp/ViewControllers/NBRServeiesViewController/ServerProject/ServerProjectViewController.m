//
//  ServerProjectViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/26.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "ServerProjectViewController.h"
#import "CreaterRequest_Conv.h"
#import "RefreshControl.h"
#import "CCLocationManager.h"
#import "ServerProjectTableViewCell.h"
#import "ServerProjectDetailViewController.h"

@interface ServerProjectViewController ()<UITableViewDataSource, UITableViewDelegate,RefreshControlDelegate,CLLocationManagerDelegate>
{
    UITableView     *boundTableView;
    NSMutableArray  *boundDataSource;
    RefreshControl  *refreshController;
    NSInteger       totalCount;
    NSInteger       pageIndex;
    BOOL            isLoading;
    
    NSString        *lat;
    NSString        *lng;
    
    ASIHTTPRequest  *convListReuqest;
    
    CLLocationManager *locationmanager;
}

@end

@implementation ServerProjectViewController

- (void) requestList
{
    convListReuqest = [CreaterRequest_Conv CreateListRequestWithIndex:ITOS(pageIndex) size:kNBR_PAGE_SIZE_STR lat:@"" lng:@""];
    
    ASIHTTPRequest *blockRequest = convListReuqest;
    
    [blockRequest setCompletionBlock:^{
        
        [refreshController finishRefreshingDirection:RefreshDirectionTop];
        
        [self removeLoadingView];
        
        NSDictionary *responseDict = convListReuqest.responseString.JSONValue;
        
        if ([CreaterRequest_Conv CheckErrorResponse:responseDict errorAlertInViewController:self])
        {
            if (pageIndex == 0)
            {
                boundDataSource = [[NSMutableArray alloc] initWithArray:[responseDict arrayWithKeyPath:@"data\\result\\data"]];
            }
            else
            {
                [boundDataSource addObjectsFromArray:[responseDict arrayWithKeyPath:@"data\\result\\data"]];
            }
            
            [boundTableView reloadData];
            
            return ;
        }
        
    }];
    
    [self setDefaultRequestFaild:blockRequest];
    [blockRequest startAsynchronous];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"特约服务";
    
    boundTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kNBR_SCREEN_W, kNBR_SCREEN_H - 64) style:UITableViewStyleGrouped];
    boundTableView.delegate = self;
    boundTableView.dataSource = self;
    [self.view addSubview:boundTableView];
    
    refreshController = [[RefreshControl alloc] initWithScrollView:boundTableView delegate:self];
    refreshController.topEnabled = YES;
    
//    if ([CLLocationManager locationServicesEnabled])
//    {
//        [UIApplication sharedApplication].idleTimerDisabled = TRUE;
//        locationmanager = [[CLLocationManager alloc] init];
//        [locationmanager requestAlwaysAuthorization];        //NSLocationAlwaysUsageDescription
//        locationmanager.delegate = self;
//        
//        
//        [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
//            lat = [NSString stringWithFormat:@"%f", locationCorrrdinate.latitude];
//            lng = [NSString stringWithFormat:@"%f", locationCorrrdinate.longitude];
//            
//            [self requestList];
//        }];
//        
//        [self addLoadingView];
//    }
//    else
//    {
//        [self showBannerMsgWithString:@"该功能需要使用定位服务"];
//        
//        return ;
//    }
    
    [self requestList];
    [self addLoadingView];
    
    return ;
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
    return boundDataSource.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .1f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105.0f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServerProjectTableViewCell *cell = [ServerProjectTableViewCell alloc];
    cell = [[NSBundle mainBundle] loadNibNamed:@"ServerProjectTableViewCell" owner:cell options:nil][0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *subCellDict = boundDataSource[indexPath.row];
    
    //图片
    NSArray *filesArr = [subCellDict arrayWithKeyPath:@"files"];
    if (filesArr.count > 0)
    {
        NSString *iconImageUrl = [subCellDict arrayWithKeyPath:@"files"][0][@"url"];
        cell.iconImageView.imageURL = [NSURL URLWithString:iconImageUrl];
    }
    
    cell.titleLable.text = [subCellDict stringWithKeyPath:@"name"];
//    cell.priceLable.text = ITOS([subCellDict numberWithKeyPath:@"goods"]);
    cell.priceLable.text = @"";
    cell.descLable.text = [subCellDict stringWithKeyPath:@"content"];
    cell.phoneLable.text = [subCellDict stringWithKeyPath:@"constract"];

    return cell;
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (boundDataSource.count >= totalCount)
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
        
        [self requestList];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *subCellDict = boundDataSource[indexPath.row];
    
    ServerProjectDetailViewController *nVC = [[ServerProjectDetailViewController alloc] initWithDict:subCellDict];
    [self.navigationController pushViewController:nVC animated:YES];
}

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction
{
    if (direction == RefreshDirectionTop)
    {
        pageIndex = 0;
        
        [self requestList];
    }
}


@end
