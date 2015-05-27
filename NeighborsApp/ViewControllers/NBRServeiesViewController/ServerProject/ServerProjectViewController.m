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
    convListReuqest = [CreaterRequest_Conv CreateListRequestWithIndex:ITOS(pageIndex) size:kNBR_PAGE_SIZE_STR lat:lat lng:lng];
    
    ASIHTTPRequest *blockRequest = convListReuqest;
    
    [blockRequest setCompletionBlock:^{
        [self removeLoadingView];
        
        NSDictionary *responseDict = convListReuqest.responseString.JSONValue;
        
        if ([CreaterRequest_Conv CheckErrorResponse:responseDict errorAlertInViewController:self])
        {
            return ;
        }
        
    }];
    
    [self setDefaultRequestFaild:blockRequest];
    [blockRequest startAsynchronous];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    boundTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, kNBR_SCREEN_H) style:UITableViewStyleGrouped];
    boundTableView.delegate = self;
    boundTableView.dataSource = self;
    [self.view addSubview:boundTableView];
    
    refreshController = [[RefreshControl alloc] initWithScrollView:boundTableView delegate:self];
    refreshController.enableInsetTop = YES;
    
    if ([CLLocationManager locationServicesEnabled])
    {
        [UIApplication sharedApplication].idleTimerDisabled = TRUE;
        locationmanager = [[CLLocationManager alloc] init];
        [locationmanager requestAlwaysAuthorization];        //NSLocationAlwaysUsageDescription
//        [locationmanager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
        locationmanager.delegate = self;
        
        
        [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            lat = [NSString stringWithFormat:@"%f", locationCorrrdinate.latitude];
            lng = [NSString stringWithFormat:@"%f", locationCorrrdinate.longitude];
            
            [self requestList];
        }];
        
        [self addLoadingView];
    }
    else
    {
        [self showBannerMsgWithString:@"该功能需要使用定位服务"];
        
        return ;
    }
    
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
    return 1;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
    
    return cell;
}

@end
