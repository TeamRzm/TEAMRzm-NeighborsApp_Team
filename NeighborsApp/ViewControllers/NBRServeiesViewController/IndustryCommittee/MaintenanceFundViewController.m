//
//  MaintenanceFundViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/31.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "MaintenanceFundViewController.h"
#import "CreaterRequest_Owner.h"
#import "RefreshControl.h"

@interface MaintenanceFundViewController ()<RefreshControlDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView     *boundTableView;
    NSMutableArray  *boundDataSource;
    
    ASIHTTPRequest  *fundInfoRequest;
    NSInteger        pageIndex;
    RefreshControl  *refreshControl;
    NSInteger        totalCount;
    BOOL             isLoading;
}
@end

@implementation MaintenanceFundViewController

- (void) requestFundInfo
{
    fundInfoRequest = [CreaterRequest_Owner CreateFundRequestWithIndex:ITOS(pageIndex) size:kNBR_PAGE_SIZE_STR start:@"" end:@""];
    
    __weak ASIHTTPRequest *blockRequest = fundInfoRequest;
    
    [blockRequest setCompletionBlock:^{
        isLoading = NO;
        [self removeLoadingView];
        
        [refreshControl finishRefreshingDirection:RefreshDirectionTop];
        
        NSDictionary *responseDict = blockRequest.responseString.JSONValue;
        
        if ([CreaterRequest_Owner CheckErrorResponse:responseDict errorAlertInViewController:self])
        {
            totalCount = [responseDict numberWithKeyPath:@"data\\result\\totalRecord"];
            
            NSArray *newRequestDataArr = [responseDict arrayWithKeyPath:@"data\\result\\data"];
            
            if (pageIndex == 0)
            {
                boundDataSource = [[NSMutableArray alloc] initWithArray:newRequestDataArr];
            }
            else
            {
                [boundDataSource addObjectsFromArray:newRequestDataArr];
            }
            
            CGFloat fundSum = self.fundLeftString.floatValue + self.fundUsedString.floatValue;
            NSString *fundSumString = [NSString stringWithFormat:@"%.2f", fundSum];
            
            self.inFund.text = [NSString stringWithFormat:@"剩余：%@", [self.fundLeftString priceString]];
            self.outFund.text = [NSString stringWithFormat:@"已使用：%@", [self.fundUsedString priceString]];
            self.fundSumLable.text = [fundSumString priceString];
            boundTableView.tableHeaderView = self.headView;
            [boundTableView reloadData];
            
            return ;
        }
    }];
    
    [blockRequest setFailedBlock:^{
        isLoading = NO;
        
        [self showBannerMsgWithString:@"网络连接失败，请您检查您的网络设置"];
        
        [self removeLoadingView];
        
        [refreshControl finishRefreshingDirection:RefreshDirectionTop];
    }];
    
    [self addLoadingView];
    [blockRequest startAsynchronous];
    isLoading = YES;
    return ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"微信基金";
    // Do any additional setup after loading the view from its nib.
    boundDataSource = [[NSMutableArray alloc] init];
    
    boundTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kNBR_SCREEN_W, kNBR_SCREEN_H - 64) style:UITableViewStyleGrouped];
    boundTableView.delegate = self;
    boundTableView.dataSource = self;
    [self.view addSubview:boundTableView];
    
    refreshControl = [[RefreshControl alloc] initWithScrollView:boundTableView delegate:self];
    refreshControl.topEnabled= YES;
    
    self.inFund.text = [@"1222222345.04" priceString];
    
    [self requestFundInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
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
        
        [self requestFundInfo];
    }
    
    return ;
}

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
    return 30.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
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
    sectionHeaderLable.text = @"收支明细";
    [sectionHeaderView addSubview:sectionHeaderLable];
    
    return sectionHeaderView;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *subCellDataDict = boundDataSource[indexPath.row];
    
    cell.textLabel.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14];
    cell.textLabel.text = [subCellDataDict stringWithKeyPath:@"title"];
    cell.textLabel.textColor = kNBR_ProjectColor_DeepBlack;
    
    cell.detailTextLabel.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:13];
    cell.detailTextLabel.text = [self stringWithString:[subCellDataDict stringWithKeyPath:@"fundDate"]];
    cell.detailTextLabel.textColor = kNBR_ProjectColor_MidGray;

    NSAttributedString *priceAttString;
    //1为收入,0为支出
    if ([subCellDataDict numberWithKeyPath:@"type"] == 0)
    {
        NSDictionary *inPriceFormatt = @{
                                         NSFontAttributeName : [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:15],
                                         NSForegroundColorAttributeName : [UIColor colorWithRed:64.0f / 255.0f green:140.0f / 255.0f blue:25.0f / 255.0f alpha:1.0f],
                                         };
        
        priceAttString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@",[subCellDataDict stringWithKeyPath:@"amount"]] attributes:inPriceFormatt];
    }
    else
    {
        NSDictionary *inPriceFormatt = @{
                                         NSFontAttributeName : [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:15],
                                         NSForegroundColorAttributeName : [UIColor colorWithRed:155.0f / 255.0f green:50.0f / 255.0f blue:40.0f / 255.0f alpha:1.0f],
                                         };
        
        priceAttString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥-%@",[subCellDataDict stringWithKeyPath:@"amount"]] attributes:inPriceFormatt];
    }
    
    UILabel *priceNumberLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kNBR_SCREEN_W - 20, 50)];
    priceNumberLable.textAlignment = NSTextAlignmentRight;
    priceNumberLable.attributedText = priceAttString;
    [cell.contentView addSubview:priceNumberLable];
    
    return cell;
}

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction
{
    if (direction == RefreshDirectionTop)
    {
        pageIndex = 0;
        
        [self requestFundInfo];
    }
    return ;
}

@end
