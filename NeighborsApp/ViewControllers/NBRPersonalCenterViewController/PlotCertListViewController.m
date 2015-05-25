//
//  PlotCertListViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/23.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "PlotCertListViewController.h"
#import "AddPlotCertViewController.h"
#import "CreaterRequest_Village.h"

@interface PlotCertListViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView                             *boundTableView;
    NSMutableArray                          *boundTableViewDataSource;
    
    ASIHTTPRequest                          *listAppliesRequest;
    
    BOOL                                    isSelectMode;
    id<PlotCertListViewControllerDelegate>  selectDelegate;
}
@end

@implementation PlotCertListViewController

- (id) initWithSelect : (BOOL) _isSelectMode selectDelegate : (id<PlotCertListViewControllerDelegate>) delegate
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        isSelectMode = _isSelectMode;
        selectDelegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (isSelectMode)
    {
        self.title = @"请选择切换的小区";
    }
    else
    {
        self.title = @"小区认证";
    }

    boundTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, kNBR_SCREEN_H) style:UITableViewStyleGrouped];
    boundTableView.delegate = self;
    boundTableView.dataSource = self;
    boundTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:boundTableView];
    
    
    UIView *tableViewFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, 40)];
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(15, 0, kNBR_SCREEN_W - 30, 40);
    commitButton.backgroundColor = kNBR_ProjectColor_StandBlue;
    commitButton.layer.cornerRadius = 5.0f;
    commitButton.layer.masksToBounds = YES;
    commitButton.titleLabel.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:15.0f];
    [commitButton setTitle:@"添加认证" forState:UIControlStateNormal];
    [commitButton addTarget: self action:@selector(addPlotCertButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [tableViewFootView addSubview:commitButton];
    
    boundTableView.tableFooterView = tableViewFootView;
    
    [self requestList];
}

- (void) addPlotCertButtonAction : (id) sender
{
    AddPlotCertViewController *nVC = [[AddPlotCertViewController alloc] initWithNibName:nil bundle:nil];
    nVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView Delegate
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return boundTableViewDataSource.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  120.0f;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *cellBoundView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kNBR_SCREEN_W - 20, 110)];
    cellBoundView.layer.borderWidth = 0.5f;
    cellBoundView.layer.borderColor = kNBR_ProjectColor_LineLightGray.CGColor;
    cellBoundView.backgroundColor = [UIColor whiteColor];
    
    //小区Lable
    UIView *plotLableBgView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W - 20, 30.0f)];
    plotLableBgView.backgroundColor = kNBR_ProjectColor_BackGroundGray;
    [cellBoundView addSubview:plotLableBgView];
    
    UILabel *plotLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kNBR_SCREEN_W - 40, 30.0f)];
    plotLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:13.0f];
    plotLable.textColor = kNBR_ProjectColor_DeepBlack;
    plotLable.text = boundTableViewDataSource[indexPath.row][@"villageName"];
    [cellBoundView addSubview:plotLable];
    
    
    //业主姓名Lable
    UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 60, 40.0f)];
    nameLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:13.0f];
    nameLable.textColor = kNBR_ProjectColor_DeepBlack;
    nameLable.text = @"业主姓名";
    [cellBoundView addSubview:nameLable];

    //Tel Lable
    UILabel *telLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 60, 40.0f)];
    telLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:13.0f];
    telLable.textColor = kNBR_ProjectColor_DeepBlack;
    telLable.text = @"联系电话";
    [cellBoundView addSubview:telLable];
    
    //State Lable
    UILabel *stateLable = [[UILabel alloc] initWithFrame:CGRectMake(kNBR_SCREEN_W - 30 - 100, 0, 100, 30)];
    stateLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:12.0f];
    stateLable.textColor = kNBR_ProjectColor_DeepBlack;
    stateLable.textAlignment = NSTextAlignmentRight;
    stateLable.text = @"审核中";
    stateLable.backgroundColor = [UIColor clearColor];
    [cellBoundView addSubview:stateLable];
    
    switch (((NSNumber*)boundTableViewDataSource[indexPath.row][@"flag"]).integerValue)
    {
        case 0: stateLable.text = @"审核通过";  break;
        case 1: stateLable.text = @"待审核";    break;
        case 2: stateLable.text = @"审核拒绝";  break;
            
        default:
            break;
    }
    
    //实际数据
    //业主姓名
    UILabel *nameCntentLable = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, kNBR_SCREEN_W - 20 - 60, 40.0f)];
    nameCntentLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:13.0f];
    nameCntentLable.textColor = kNBR_ProjectColor_MidGray;
    nameCntentLable.text = boundTableViewDataSource[indexPath.section][@"contact"];
    [cellBoundView addSubview:nameCntentLable];
    
    //Tel姓名
    UILabel *telCntentLable = [[UILabel alloc] initWithFrame:CGRectMake(70, 70, kNBR_SCREEN_W - 20 - 60, 40.0f)];
    telCntentLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:13.0f];
    telCntentLable.textColor = kNBR_ProjectColor_MidGray;
    telCntentLable.text = boundTableViewDataSource[indexPath.section][@"phone"];
    [cellBoundView addSubview:telCntentLable];
    
    //分割线
    UIView *breakLine1 = [[UIView alloc] initWithFrame:CGRectMake(0, 30, CGRectGetWidth(cellBoundView.frame), 1)];
    breakLine1.backgroundColor = kNBR_ProjectColor_LineLightGray;
    
    UIView *breakLine2 = [[UIView alloc] initWithFrame:CGRectMake(0, 70, CGRectGetWidth(cellBoundView.frame), 1)];
    breakLine1.backgroundColor = kNBR_ProjectColor_LineLightGray;
    
    [cellBoundView addSubview:breakLine1];
    [cellBoundView addSubview:breakLine2];
    
    [cell.contentView addSubview:cellBoundView];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectDelegate && [selectDelegate respondsToSelector:@selector(plotCertListViewController:selectAddressDict:)])
    {
        NSDictionary *addressDict = boundTableViewDataSource[indexPath.row];
        
        [selectDelegate plotCertListViewController:self selectAddressDict:addressDict];
        
        return ;
    }
}

- (void) requestList
{
    listAppliesRequest = [CreaterRequest_Village CreateListAppLinesRequest];
    
    __weak ASIHTTPRequest *blockReqeust = listAppliesRequest;
    
    [blockReqeust setCompletionBlock:^{
        [self removeLoadingView];
        
        NSDictionary *responseDict = [blockReqeust.responseString JSONValue];
        
        if ([CreaterRequest_Village CheckErrorResponse:responseDict errorAlertInViewController:self])
        {
            boundTableViewDataSource =  [NSMutableArray arrayWithArray:[responseDict arrayWithKeyPath:@"data\\result"]];
            [boundTableView reloadData];
            return ;
        }
    }];
    
    [self setDefaultRequestFaild:listAppliesRequest];
    
    [blockReqeust startAsynchronous];
    [self addLoadingView];
    
}


@end
